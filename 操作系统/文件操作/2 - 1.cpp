#include <Windows.h>
#include <conio.h>
#include <tchar.h>
#include <iostream>
using namespace std;

const size_t BUF_SIZE = 256;
TCHAR szName[] = TEXT("Local\\MyFileMappingObject");	// Global ��ҪȨ�� SeCreateGlobalPrivilege
TCHAR szMsg[] = TEXT("Message from first process.");

int main()
{
	// �����ļ�ӳ�����
	HANDLE hMapFile = CreateFileMapping(
		INVALID_HANDLE_VALUE,		// use paging file ��ҳ���ļ��д���һ���ɹ�����ļ�ӳ��
		NULL,						// default security
		PAGE_READWRITE,				// read/write access ��дȨ��
		0,							// maximum object size (high-order DWORD)
		BUF_SIZE,					// maximum object size (low-order DWORD)
		szName);					// name of mapping object

	if (NULL == hMapFile)
	{
		cout << "Could not create file mapping object:" << GetLastError() << endl;
		return EXIT_FAILURE;
	}

	// ���ļ�ӳ�����ӳ�䵽���ý��̵ĵ�ַ�ռ�
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

	// ��һ���ڴ��һ��λ�ø��Ƶ���һ��λ��
	CopyMemory((PVOID)pBuf, szMsg, (_tcslen(szMsg) * sizeof(TCHAR)));
	_getch();

	// �����һ���ļ�ӳ������ӳ��
	// �ӵ��ý��̵ĵ�ַ�ռ�ȡ��ӳ���ļ���ӳ����ͼ
	UnmapViewOfFile(pBuf);

	// �ر��ļ�ӳ�����
	CloseHandle(hMapFile);

	return EXIT_SUCCESS;
}