#include <Windows.h>
#include <iostream>
using namespace std;

#define Y "conn.log"
#define BUF_SIZE 256

VOID CALLBACK MyFileIOCompletionRoutine(
	DWORD dwErrorCode,                // ��춴˴β������صĠ�B  
	DWORD dwNumberOfBytesTransfered,  // ���V�ѽ������˶���λԪ�M,Ҳ������IRP�e��Information  
	LPOVERLAPPED lpOverlapped         // �@���Y�ϽY��  
)
{
	printf("IO operation end!\n");
}

int main() {
	HANDLE hFile;
	// �ļ��첽��д
	/*�ļ��첽��д��
	1����FILE_FLAG_OVERLAPPED
	2����ȡ��д���ļ�
	3��������̶������ɹ���
	4������������̶������ȴ�I/O�¼���ɽ��д���*/

	hFile = CreateFile(Y,
		GENERIC_READ | GENERIC_WRITE,
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_FLAG_OVERLAPPED,
		NULL);

	if (hFile == INVALID_HANDLE_VALUE) {
		cout << "Can't Open File: " << Y << endl << endl;
		CloseHandle(hFile);
	}
	else {
		DWORD   nReadByte;
		/*OVERLAPPED overlap = { 0, 0, 0, 0, NULL };
		char buf[512];
		if (ReadFile(hFile, buf, 6, &nReadByte, &overlap)) {
			cout << "success" << endl;
			cout << nReadByte << endl;
			cout << buf << endl;
		}
		else {
			if (GetLastError() == ERROR_IO_PENDING){
				WaitForSingleObject(hFile, INFINITE);
				bool rc = GetOverlappedResult(hFile, &overlap, &nReadByte, FALSE);
				cout << rc << endl;
			}
			else {
				cout << "what happened?" << endl;
			}
		}*/
		
		BYTE    bBuf1[BUF_SIZE], bBuf2[BUF_SIZE], bBuf3[BUF_SIZE];
		HANDLE  hEvent1 = CreateEvent(NULL, FALSE, FALSE, NULL);
		HANDLE  hEvent2 = CreateEvent(NULL, FALSE, FALSE, NULL);
		HANDLE  hEvent3 = CreateEvent(NULL, FALSE, FALSE, NULL);
		OVERLAPPED ov1 = { 0, 0, 0, 0, hEvent1 };
		OVERLAPPED ov2 = { 0, 0, 0, 0, hEvent2 };
		OVERLAPPED ov3 = { 0, 0, 0, 0, hEvent3 };
		bool b1, b2, b3;

		b1 = ReadFile(hFile, bBuf1, sizeof(bBuf1), &nReadByte, &ov1);
		b2 = ReadFile(hFile, bBuf2, sizeof(bBuf2), &nReadByte, &ov2);
		b3 = ReadFile(hFile, bBuf3, sizeof(bBuf3), &nReadByte, &ov3);

		cout << b1 << b2 << b3 << endl;

		// ��������I/O�����ʱ��Ƚϳ��������ﻹû�н���
		// ʵ�ֶԵ�һ��I/O����ĵȴ�
		bool rc = GetOverlappedResult(hFile, &ov1, &nReadByte, TRUE);
		cout << rc << endl;
		cout << nReadByte << endl;
		cout << bBuf1 << endl;
		cout << bBuf2 << endl;
		cout << bBuf3 << endl;



		CloseHandle(hFile);
	}

	system("pause");

	return 0;
}