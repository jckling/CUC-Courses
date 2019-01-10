#include <iostream>
#include <iomanip>
using namespace std;

/**************************************************************************

Author: Jck

Date: 2018-11-30

Description: 死锁避免 - 银行家算法

**************************************************************************/


const int P = 5;				// 进程数量
const int R = 3;				// 资源数量
const char separator = ' ';		// 填充字符

// 打印
template<typename T> void printElement(T t, const int& width)
{
	cout << left << setw(width) << setfill(separator) << t;
}

// 计算需求矩阵
void calculateNeed(int need[P][R], int maxm[P][R], int allot[P][R])
{
	for (int i = 0; i < P; i++)
		for (int j = 0; j < R; j++)
			need[i][j] = maxm[i][j] - allot[i][j];		// 需求矩阵 = 最大需求矩阵 - 分配矩阵
}

// 打印当前资源分配情况
void printAllo(int processes[], int avail[], int maxm[][R], int allot[][R])
{
	// 计算需求矩阵
	int need[P][R];
	calculateNeed(need, maxm, allot);

	// 打印
	cout << endl;
	printElement("Process", 15);
	printElement("Max", 18);
	printElement("Allocation", 22);
	printElement("Need", 15);
	cout << endl;

	for (int i = 0; i < 65; i++)
		cout << "-";
	cout << endl;

	for (int i = 0; i < P; i++)
	{
		cout << "P" << setw(5) << left << i << " | ";
		for (int j = 0; j < R; j++)
			cout << setw(5) << left << maxm[i][j] << " ";
		cout << " | ";
		for (int j = 0; j < R; j++)
			cout << setw(5) << left << allot[i][j] << " ";
		cout << " | ";
		for (int j = 0; j < R; j++)
			cout << setw(5) << left << need[i][j] << " ";
		cout << endl;
	}

	cout << "Available: ";
	for (int j = 0; j < R; j++)
		cout << setw(5) << left << avail[j] << " ";

	cout << endl << endl;
}

// 安全性算法
bool isSafe(int processes[], int avail[], int maxm[][R], int allot[][R])
{
	// 打印当前分配情况
	printAllo(processes, avail, maxm, allot);

	// 计算初始需求矩阵
	int need[P][R];
	calculateNeed(need, maxm, allot);

	// 完成标志，初始置为false
	bool finish[P] = { 0 };

	// 安全序列
	int safeSeq[P];

	// 初始Work=Available（工作向量=可利用资源）
	int work[R];
	for (int i = 0; i < R; i++)
		work[i] = avail[i];

	// 打印表头
	cout << endl;
	printElement("Process", 15);
	printElement("Work", 20);
	printElement("Need", 20);
	printElement("Allocation", 18);
	printElement("Work+Allocation", 20);
	printElement("Finish", 10);
	cout << endl;

	for (int i = 0; i < 100; i++)
		cout << "-";
	cout << endl;

	// 安全性算法
	int count = 0;
	while (count < P)
	{
		// 找到没有完成，且需求量≤工作向量的进程
		bool found = false;
		for (int p = 0; p < P; p++)
		{
			if (finish[p] == 0)
			{
				int j;
				for (j = 0; j < R; j++)
					if (need[p][j] > work[j])
						break;

				// 所有资源需求≤工作向量
				if (j == R)
				{
					// 输出进程、当前工作向量、需求矩阵、分配矩阵
					cout << "P" << setw(5) << p << " | ";
					for (int w = 0; w < R; w++)
						cout << setw(5) << work[w] <<  " ";
					cout << " | ";
					for (int w = 0; w < R; w++)
						cout << setw(5) << need[p][w] << " ";
					cout << " | ";
					for (int w = 0; w < R; w++)
						cout << setw(5) << allot[p][w] << " ";

					// 完成工作并释放资源
					for (int k = 0; k < R; k++)
						work[k] += allot[p][k];

					// 将该进程加入安全序列
					safeSeq[count++] = p;

					// 完成标志置为true
					finish[p] = 1;

					// 输出新的工作向量
					cout << " | ";
					for (int w = 0; w < R; w++)
						cout << setw(5) << work[w] << " ";
					cout << " | " << finish[p] << endl;

					found = true;
				}
			}
		}

		// 无法找到安全序列
		if (found == false)
		{
			cout << "\nSystem is not in safe state." << endl << endl;
			return false;
		}
	}

	// 找到安全序列则输出
	cout << "\nSystem is in safe state.\nSafe sequence is: ";
	for (int i = 0; i < P; i++)
		cout << safeSeq[i] << " ";
	cout << endl << endl;
	return true;
}

// 进程请求资源
bool request(int p, int ask[], int processes[], int avail[], int maxm[][R], int allot[][R]) 
{
	// 打印请求
	cout << "\nP" << p << " request ";
	for (int i = 0; i < R; i++)
		cout << ask[i] << " ";

	// 计算初始需求矩阵
	int need[P][R];
	calculateNeed(need, maxm, allot);

	// 尝试进行分配
	int j;
	for (j = 0; j < R; j++)
		if (ask[j] > avail[j] || ask[j] > need[p][j]) // 请求>可用 或 请求>需求
			break;

	if (j == R) 
	{
		for (j = 0; j < R; j++) 
		{
			need[p][j] -= ask[j];
			avail[j] -= ask[j];
			allot[p][j] += ask[j];
		}

		// 分配完毕
		cout << "\nSatisfy the request from P" << p << endl << endl;
		printAllo(processes, avail, maxm, allot);

		// 询问是否继续分配
		cout << "\nContinue Request? (Y/N): ";
		char A;
		if (cin >> A && (A == 'Y' || A == 'y'))
		{
			cout << "\nInput the Process number(0~" << P << "): "; cin >> p;
			for (int i = 0; i < R; i++)
			{
				cout << "Request Resource" << i << ": ";
				cin >> ask[i];
			}		
			request(p, ask, processes, avail, maxm, allot);
		}
		else
			return isSafe(processes, avail, maxm, allot);	// 安全性检查
	}
	else {
		cout << "\nCan't satisfy the request from P" << p << endl;	// 无法满足请求
		return false;
	}
}

// 主函数
int main()
{
	// 进程号
	int processes[] = { 0, 1, 2, 3, 4 };

	// 可利用资源向量
	int avail[] = { 3, 3, 2 };

	// 最大需求矩阵
	int maxm[][R] = { 
					{ 7, 5, 3 },
					{ 3, 2, 2 },
					{ 9, 0, 2 },
					{ 2, 2, 2 },
					{ 4, 3, 3 } };

	// 当前分配矩阵
	int allot[][R] = { 
					{ 0, 1, 0 },
					{ 2, 0, 0 },
					{ 3, 0, 2 },
					{ 2, 1, 1 },
					{ 0, 0, 2 } };

	// 安全性检查
	//isSafe(processes, avail, maxm, allot);

	// P1申请 1,0,2
	int p = 1;
	int ask[] = { 1, 0, 2 };
	request(p, ask, processes, avail, maxm, allot);

	/*bool stat = true;
	do {
		int ask[] = { 0, 0, 0 };
		stat = request(0, ask, processes, avail, maxm, allot);
	} while (stat);*/


	system("pause");
	return 0;
}