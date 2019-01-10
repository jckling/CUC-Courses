#include <iostream>
#include <iomanip>
#include <set>
#include <vector>
#include <map>
#include <algorithm>
using namespace std;

/**************************************************************************

Author: Jck

Date: 2018-12-11

Description: 页面调度

**************************************************************************/

int MaxNum;				// 最大页面编号
int Seed;				// 伪随机数种子
int SeqLength;			// 页面访问序列长度
int FrameNumber;		// 页框数量

set<int> pages;			// 页框栈中的元素（查找用）
vector<int> seq;		// 页框栈

double PageFaultRate;	// 缺页率
bool Fault;				// 缺页标志
bool Changed;			// 替换标志
int MovedPage;			// 替换掉的页面（页号）

struct MyStruct{		// Clock结构体
	int num;
	bool change;
	bool access;
};

vector<MyStruct> clock_pages;	// Clock链表
int p;							// 指向当前页框


// 打印页框栈
void PrintSeq(int pagenumber) {
	if (Fault)
		cout << "x  ";
	else
		cout << "   ";

	if (Changed)
		cout << MovedPage << "->" << pagenumber << " | ";
	else
		cout << "     | ";

	for (int i = 0; i < seq.size(); i++)
		cout << seq[i] << " ";
	cout << endl;
}

// 打印Clock结构体
void PrintClock() {
	for (auto it = clock_pages.cbegin(); it != clock_pages.cend(); ++it)
		cout << it->num << " " << it->access << " " << it->change << endl;
}

// 是否缺页
void PageFault(int pagenumber) {
	Changed = false;
	if (pages.find(pagenumber) == pages.end()) {
		PageFaultRate++;
		Fault = true;
	}
	else 
		Fault = false;
}

// 先进先出
void FIFO(int pagenumber) {
	if (true == Fault) {
		if (pages.size() >= FrameNumber) {
			int temp = seq.front();
			MovedPage = temp;
			Changed = true;
			seq.erase(seq.begin());
			pages.erase(temp);
		}
		pages.insert(pagenumber);
		seq.push_back(pagenumber);
	}
}

// 最近最久未被使用
void LRU(int pagenumber) {
	if (true == Fault) {
		if (pages.size() >= FrameNumber) {
			int temp = seq.front();
			MovedPage = temp;
			Changed = true;
			seq.erase(seq.begin());
			pages.erase(temp);
		}
		pages.insert(pagenumber);
		seq.push_back(pagenumber);
	}
	else {
		vector<int>::iterator position = find(seq.begin(), seq.end(), pagenumber);
		seq.erase(position);
		seq.push_back(pagenumber);
	}
}

// 淘汰页面
int ClockFind() {
	int i, j;
	while (true) {
		for (i = p, j = 0; j < clock_pages.size(); i = (i + 1) % clock_pages.size(), j++) {
			if (clock_pages[i].access == false && clock_pages[i].change == false) {
				p = i;
				return i;
			}
		}

		for (i = p, j = 0; j < clock_pages.size(); i = (i + 1) % clock_pages.size(), j++) {
			if (clock_pages[i].access == false && clock_pages[i].change == true) {
				p = i;
				return i;
			}
			clock_pages[i].access = false;
		}
	}
}

// 访问位+修改位
void Clock(int pagenumber, bool f) {
	if (true == Fault) {
		if (pages.size() >= FrameNumber) {
			int temp = ClockFind();
			MovedPage = temp;
			Changed = true;
			pages.erase(clock_pages[temp].num);
			clock_pages.erase(clock_pages.begin()+temp);	
		}
		MyStruct page;
		page.num = pagenumber;
		page.access = true;
		page.change = f;
		clock_pages.push_back(page);
		pages.insert(pagenumber);
	}
	else {
		for(auto it=clock_pages.begin(); it!=clock_pages.end(); it++){ 
			if (it->num == pagenumber) {
				if (false == it->change)
					it->change = f;
				it->access = true;
				break;
			}
		}
	}
}

// 主函数
int main() {
	// 3 7 6 15
	cout << "Input the Number of Page Frames: ";
	cin >> FrameNumber;
	PageFaultRate = 0;
	p = 0;

	cout << "Input the Max Number of Pages: ";
	cin >> MaxNum;
	
	cout << "Input the Seed: ";
	cin >> Seed;

	cout << "Input the Length of Page Sequence: ";
	cin >> SeqLength;

	// 产生修改位
	vector<bool> changed;
	for (int i = 0; i < SeqLength; i++)
		changed.push_back(rand()%2);

	int page;
	srand(Seed);
	// 访问 缺页 替换 页框栈
	for (int i = 0; i < SeqLength; i++) {
		page = (int)rand()%(MaxNum+1);					// 随机生成访问页号
		cout << setprecision(2) << page << "  ";		// 当前访问的页面号
		PageFault(page);								// 判断是否缺页

		FIFO(page);
		//LRU(page);
		PrintSeq(page);

		/*cout << "#" << page << " "<< changed[i] << "#" << endl;
		Clock(page, changed[i]);
		PrintClock();*/
	}

	// 缺页率
	cout << "Page Fault Rate: " << setprecision(4) << PageFaultRate/SeqLength*100 << "%" << endl;

	system("pause");

	return 0;
} 