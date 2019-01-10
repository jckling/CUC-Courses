#include <Windows.h>
#include <iostream>
using namespace std;

#define Y "conn.log"
#define BUF_SIZE 256

VOID CALLBACK MyFileIOCompletionRoutine(
	DWORD dwErrorCode,                // 對於此次操作返回的狀態  
	DWORD dwNumberOfBytesTransfered,  // 告訴已經操作了多少位元組,也就是在IRP裡的Information  
	LPOVERLAPPED lpOverlapped         // 這個資料結構  
)
{
	printf("IO operation end!\n");
}

int main() {
	HANDLE hFile;
	// 文件异步读写
	/*文件异步读写：
	1：以FILE_FLAG_OVERLAPPED
	2：读取或写入文件
	3：如果立刻读出，成功；
	4：如果不能立刻读出，等待I/O事件完成进行处理*/

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

		// 假设三个I/O处理的时间比较长，到这里还没有结束
		// 实现对第一个I/O处理的等待
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