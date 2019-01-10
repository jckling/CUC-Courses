#include <Windows.h>
#include <conio.h>
#include <tchar.h>
#include <iostream>
using namespace std;

const size_t BUF_SIZE = 256;
TCHAR szName[] = TEXT("Local\\MyFileMappingObject");	// Global 需要权限 SeCreateGlobalPrivilege
TCHAR szMsg[] = TEXT("Message from first process.");

int main()
{
	// 创建文件映射对象
	HANDLE hMapFile = CreateFileMapping(
		INVALID_HANDLE_VALUE,		// use paging file 在页面文件中创建一个可共享的文件映射
		NULL,						// default security
		PAGE_READWRITE,				// read/write access 读写权限
		0,							// maximum object size (high-order DWORD)
		BUF_SIZE,					// maximum object size (low-order DWORD)
		szName);					// name of mapping object

	if (NULL == hMapFile)
	{
		cout << "Could not create file mapping object:" << GetLastError() << endl;
		return EXIT_FAILURE;
	}

	// 将文件映射对象映射到调用进程的地址空间
	LPCTSTR pBuf = (LPCTSTR)MapViewOfFile(
		hMapFile,					// handle to map object
		FILE_MAP_ALL_ACCESS,		// read/write permission
		0,
		0,
		BUF_SIZE);

	if (NULL == pBuf)
	{
		cout << "Could not map view of file :" << GetLastError() << endl;
		CloseHandle(hMapFile);
		return EXIT_FAILURE;
	}

	// 将一块内存从一个位置复制到另一个位置
	CopyMemory((PVOID)pBuf, szMsg, (_tcslen(szMsg) * sizeof(TCHAR)));
	_getch();

	// 解除对一个文件映射对象的映射
	// 从调用进程的地址空间取消映射文件的映射视图
	UnmapViewOfFile(pBuf);

	// 关闭文件映射对象
	CloseHandle(hMapFile);

	return EXIT_SUCCESS;
}