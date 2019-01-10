#include <Windows.h>
#include <iostream>
using namespace std;

const size_t  BUF_SIZE = 256;
TCHAR szName[] = TEXT("Local\\MyFileMappingObject");

int main()
{
	// 打开文件映射对象
	HANDLE hMapFile = OpenFileMapping(
		FILE_MAP_ALL_ACCESS,	// read/write access
		FALSE,					// do not inherit the name
		szName);				// name of mapping object
	
	if (NULL == hMapFile)
	{
		cout << "Could not open file mapping object :" << ::GetLastError() << endl;
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

	// 输出映射对象中的内容
	MessageBox(NULL, pBuf, TEXT("Process2"), MB_OK);

	// 解除对一个文件映射对象的映射
	UnmapViewOfFile(hMapFile);

	// 关闭文件映射对象
	CloseHandle(hMapFile);

	return EXIT_SUCCESS;
}