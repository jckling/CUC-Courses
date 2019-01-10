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

Description: ҳ�����

**************************************************************************/

int MaxNum;				// ���ҳ����
int Seed;				// α���������
int SeqLength;			// ҳ��������г���
int FrameNumber;		// ҳ������

set<int> pages;			// ҳ��ջ�е�Ԫ�أ������ã�
vector<int> seq;		// ҳ��ջ

double PageFaultRate;	// ȱҳ��
bool Fault;				// ȱҳ��־
bool Changed;			// �滻��־
int MovedPage;			// �滻����ҳ�棨ҳ�ţ�

struct MyStruct{		// Clock�ṹ��
	int num;
	bool change;
	bool access;
};

vector<MyStruct> clock_pages;	// Clock����
int p;							// ָ��ǰҳ��


// ��ӡҳ��ջ
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

// ��ӡClock�ṹ��
void PrintClock() {
	for (auto it = clock_pages.cbegin(); it != clock_pages.cend(); ++it)
		cout << it->num << " " << it->access << " " << it->change << endl;
}

// �Ƿ�ȱҳ
void PageFault(int pagenumber) {
	Changed = false;
	if (pages.find(pagenumber) == pages.end()) {
		PageFaultRate++;
		Fault = true;
	}
	else 
		Fault = false;
}

// �Ƚ��ȳ�
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

// ������δ��ʹ��
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

// ��̭ҳ��
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

// ����λ+�޸�λ
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

// ������
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

	// �����޸�λ
	vector<bool> changed;
	for (int i = 0; i < SeqLength; i++)
		changed.push_back(rand()%2);

	int page;
	srand(Seed);
	// ���� ȱҳ �滻 ҳ��ջ
	for (int i = 0; i < SeqLength; i++) {
		page = (int)rand()%(MaxNum+1);					// ������ɷ���ҳ��
		cout << setprecision(2) << page << "  ";		// ��ǰ���ʵ�ҳ���
		PageFault(page);								// �ж��Ƿ�ȱҳ

		FIFO(page);
		//LRU(page);
		PrintSeq(page);

		/*cout << "#" << page << " "<< changed[i] << "#" << endl;
		Clock(page, changed[i]);
		PrintClock();*/
	}

	// ȱҳ��
	cout << "Page Fault Rate: " << setprecision(4) << PageFaultRate/SeqLength*100 << "%" << endl;

	system("pause");

	return 0;
} 