#include <Windows.h>
#include <iostream>
using namespace std;

#define F "test.txt"

int main() {
	HANDLE hFile;
	DWORD bytesWritten;
	char str[] = "WriteFile test!";

	// 文件创建、写入、打开、读取、删除
	hFile = CreateFile(
		F,						  // open File
		GENERIC_WRITE,			  // open for writing
		FILE_SHARE_READ,          // allow multiple readers
		NULL,                     // no security
		CREATE_ALWAYS,            // create
		FILE_ATTRIBUTE_NORMAL,    // normal file
		NULL);                    // no attr. template

	if (hFile == INVALID_HANDLE_VALUE) {
		cout << "Can't Create File" << endl << endl;
		CloseHandle(hFile);
	}
	else {
		cout << "Create File: " << F << endl;
		system("pause");

		if (FALSE == WriteFile(hFile, str, strlen(str), &bytesWritten, NULL)) {
			cout << "Can't Write File" << endl;
			CloseHandle(hFile);
		}
		else {
			CloseHandle(hFile);
			cout << "Write File Finish" << endl << endl;
			hFile = CreateFile(F,               // file to open
				GENERIC_READ,          // open for reading
				FILE_SHARE_READ,       // share for reading
				NULL,                  // default security
				OPEN_EXISTING,         // existing file only
				FILE_ATTRIBUTE_NORMAL, // normal file
				NULL);                 // no attr. template
			if (hFile == INVALID_HANDLE_VALUE) {
				cout << "Can't Open File: " << F << endl;
				CloseHandle(hFile);
			}
			else {
				if (FALSE == ReadFile(hFile, str, 6, &bytesWritten, NULL)) {
					cout << "Can't Read File: " << F << endl;
					CloseHandle(hFile);
				}
				else {
					cout << "File Contents:" << '\n' << str << endl;
					CloseHandle(hFile);

					system("pause");

					if (FALSE == DeleteFileA(F))
						cout << "Can't Delete File: " << F << endl;
					else
						cout << "\nDelete File: " << F << endl;
				}
			}

		}

	}

	system("pause");

	return 0;
}