#include <stdio.h>
#include <Windows.h>
#include <TlHelp32.h>
#include <Shlwapi.h>
 
// declare function
DWORD findPID(LPCTSTR szProcessName);
BOOL injectDLL(DWORD dwPID, LPCTSTR szDLLName);
 
// usage
int main(int argc, char *argv[])
{
    if (argc != 3) {
        printf("[*] Usage : %s [Target] [DLL]\n", argv[0]);
        return 1;
    }
 
    if (!PathFileExistsA(argv[2])) {
        printf("[-] DLL Not Exists : %s\n", argv[2]);
        return 1;
    }
 
    DWORD pid = findPID(argv[1]);
    if (pid == 0xFFFFFFFF) {
        printf("[-] Process not found\n");
        return 1;
    }
    else {
        printf("[*] pid : %u\n", pid);
    }
    if (!injectDLL(pid, argv[2])) {
        printf("[-] Injection Failed\n");
        return 1;
    }
    else {
        printf("[*] Injection Successed\n");
    }
 
    return 0;
}

// find process id
DWORD findPID(LPCTSTR szProcessName)
{
    DWORD dwPID = 0xFFFFFFFF;
    HANDLE hSnapshot = INVALID_HANDLE_VALUE;
    PROCESSENTRY32 pe;
	
	// take a snapshot
    pe.dwSize = sizeof(PROCESSENTRY32);
    hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);
    if (hSnapshot == INVALID_HANDLE_VALUE) {
        printf("[*] CreateToolhelp32Snapshot Error\n");
        return 0xFFFFFFFF;
    }
	
	// find process
    Process32First(hSnapshot, &pe);
    do {
        if (!_stricmp(szProcessName, pe.szExeFile)) {
            dwPID = pe.th32ProcessID;
            break;
        }
    } while (Process32Next(hSnapshot, &pe));
 
    CloseHandle(hSnapshot);
    return dwPID;
}

// inject dll
BOOL injectDLL(DWORD dwPID, LPCTSTR szDLLName)
{
    HANDLE hProcess, hThread;
    HMODULE hMod;
 
    LPVOID pRemoteBuf;
    DWORD dwBufSize = lstrlen(szDLLName) + 1;
    LPTHREAD_START_ROUTINE pThreadProc;
 
    // Get target process handle
    if ((hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwPID)) == INVALID_HANDLE_VALUE) {
        printf("[-] OpenProcess Error\n");
        printf("[-] gle : 0x%x\n", GetLastError());
        return FALSE;
    }
 
    // Allocate memory to target process
    if ((pRemoteBuf = VirtualAllocEx(hProcess, NULL, dwBufSize, MEM_COMMIT, PAGE_READWRITE)) == INVALID_HANDLE_VALUE) {
        printf("[-] VirtualAllocEx Error\n");
        printf("[-] gle : 0x%x\n", GetLastError());
        return FALSE;
    }
    
    // Write DLL name to target process memory
    if (WriteProcessMemory(hProcess, pRemoteBuf, szDLLName, dwBufSize, NULL) == FALSE) {
        printf("[-] WriteProcessMemory Error\n");
        printf("[-] gle : 0x%x\n", GetLastError());
        return FALSE;
    }
    
    // Get handle of "kernel32.dll"
    if ((hMod = GetModuleHandle("kernel32.dll")) == INVALID_HANDLE_VALUE) {
        printf("[-] GetModuleHandle Error\n");
        printf("[-] gle : 0x%x\n", GetLastError());
        return FALSE;
    }
 
    // Get address of "LoadLibraryA"
    if ((pThreadProc = (LPTHREAD_START_ROUTINE)GetProcAddress(hMod, "LoadLibraryA")) == INVALID_HANDLE_VALUE) {
        printf("[-] GetProcAddress Error\n");
        printf("[-] gle : 0x%x\n", GetLastError());
        return FALSE;
    }
 
    // Create and run remote thread in target process
    if ((hThread = CreateRemoteThread(hProcess, NULL, 0, pThreadProc, pRemoteBuf, 0, NULL)) == INVALID_HANDLE_VALUE) {
        printf("[-] CreateRemoteThread Error\n");
        printf("[-] gle : 0x%x\n", GetLastError());
        return FALSE;
    }
	
    WaitForSingleObject(hThread, INFINITE);

    CloseHandle(hThread);

	//// Free memory
	//if (VirtualFreeEx(hProcess, pRemoteBuf, dwBufSize, MEM_DECOMMIT)) {
	//	printf("[-] VirtualFreeEx Error\n");
	//	printf("[-] gle : 0x%x\n", GetLastError());
	//	return FALSE;
	//}

    CloseHandle(hProcess);

    return TRUE;
}