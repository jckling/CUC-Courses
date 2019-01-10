#include <Windows.h>
#include <iostream>
using namespace std;

const size_t  BUF_SIZE = 256;
TCHAR szName[] = TEXT("Local\\MyFileMappingObject");

int main()
{
	// ���ļ�ӳ�����
	HANDLE hMapFile = OpenFileMapping(
		FILE_MAP_ALL_ACCESS,	// read/write access
		FALSE,					// do not inherit the name
		szName);				// name of mapping object
	
	if (NULL == hMapFile)
	{
		cout << "Could not open file mapping object :" << ::GetLastError() << endl;
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

	// ���ӳ������е�����
	MessageBox(NULL, pBuf, TEXT("Process2"), MB_OK);

	// �����һ���ļ�ӳ������ӳ��
	UnmapViewOfFile(hMapFile);

	// �ر��ļ�ӳ�����
	CloseHandle(hMapFile);

	return EXIT_SUCCESS;
}