#include<Windows.h>
#include<TlHelp32.h>
#include<tchar.h>
#include<stdio.h>

// process name
#define DEF_PROC_NAME ("notepad.exe")

// global
LPVOID g_pfWriteFile = NULL;
CREATE_PROCESS_DEBUG_INFO g_cpdi;
BYTE g_chINT3 = 0xCC, g_ch0rgByte = 0;

// find process id
DWORD FindProcessID(LPCTSTR szProcessName)
{
	DWORD dwPID = 0xFFFFFFFF;
	HANDLE hSnapShot = INVALID_HANDLE_VALUE;
	PROCESSENTRY32 pe;

	// take a snapshot
	hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);
	pe.dwSize = sizeof(PROCESSENTRY32);

	// find process
	Process32First(hSnapShot, &pe);
	do
	{
		if (!_tcsicmp(szProcessName, (LPCTSTR)pe.szExeFile))
		{
			dwPID = pe.th32ProcessID;
			break;
		}
	} while (Process32Next(hSnapShot, &pe));

	CloseHandle(hSnapShot);

	return dwPID;
}

// debug
BOOL OnCreateProcessDebugEvent(LPDEBUG_EVENT pde)
{
	// get address of WriteFile()
	g_pfWriteFile = GetProcAddress(GetModuleHandleA("kernel32.dll"), "WriteFile");

	// change first byte to 0xCC（INT 3）
	// use orignalbyte to backup g_ch0rgByte
	memcpy(&g_cpdi, &pde->u.CreateProcessInfo, sizeof(CREATE_PROCESS_DEBUG_INFO));
	ReadProcessMemory(g_cpdi.hProcess, g_pfWriteFile, &g_ch0rgByte, sizeof(BYTE), NULL);
	WriteProcessMemory(g_cpdi.hProcess, g_pfWriteFile, &g_chINT3, sizeof(BYTE), NULL);

	return TRUE;
}

// handle events
BOOL OnExceptionDebugEvent(LPDEBUG_EVENT pde)
{
	CONTEXT ctx;
	PBYTE lpBuffer = NULL;

#ifndef _WIN64
	DWORD dwNumOfBytesToWrite, dwAddrOfBuffer, i;
#else
	LONGLONG dwNumOfBytesToWrite, dwAddrOfBuffer, i;
#endif
	PEXCEPTION_RECORD per = &pde->u.Exception.ExceptionRecord;

	// exception INT 3
	if (EXCEPTION_BREAKPOINT == per->ExceptionCode)
	{
		// address of WriteFile()
		if (g_pfWriteFile == per->ExceptionAddress)
		{
			// #1. Unhook
			// change 0xCC to original byte
			WriteProcessMemory(g_cpdi.hProcess, g_pfWriteFile, &g_ch0rgByte, sizeof(BYTE), NULL);

			// #2. get context of thread
			ctx.ContextFlags = CONTEXT_ALL;
			GetThreadContext(g_cpdi.hThread, &ctx);

			// #3. get params of WriteFile()
			// param 2 ：ESP + 0x8
			// param 3 ：ESP + 0xC

#ifndef _WIN64
			ReadProcessMemory(g_cpdi.hProcess, (LPVOID)(ctx.Esp + 0x8), &dwAddrOfBuffer, sizeof(DWORD), NULL);
			ReadProcessMemory(g_cpdi.hProcess, (LPVOID)(ctx.Esp + 0xC), &dwNumOfBytesToWrite, sizeof(DWORD), NULL);
#else
			dwAddrOfBuffer = ctx.Rdx;
			dwNumOfBytesToWrite = ctx.R8;
#endif
			
			// #4. allocate temporary buffer
			lpBuffer = (PBYTE)malloc(dwNumOfBytesToWrite + 1);
			memset(lpBuffer, 0, dwNumOfBytesToWrite + 1);

			// #5. copy to temporary buffer
			ReadProcessMemory(g_cpdi.hProcess, (LPVOID)dwAddrOfBuffer, lpBuffer, dwNumOfBytesToWrite, NULL);
			printf("\n### orignal string : %s\n", lpBuffer);
			printf("\n### orignal string length : %lld\n", dwNumOfBytesToWrite);

			// #6. convert lowercase letters to uppercase
			//for (i = 0; i < dwNumOfBytesToWrite; i++)
			//{
			//	if (0x61 < lpBuffer[i] && lpBuffer[i] <= 0x7A)
			//		lpBuffer[i] -= 0x20;
			//}

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// custom content
			char s[] = "you have been hacked!";
			SIZE_T bytes_written = 0;
			dwNumOfBytesToWrite = strlen(s)+1;
			lpBuffer = (PBYTE)malloc(dwNumOfBytesToWrite);
			for (i = 0; i < dwNumOfBytesToWrite-1; i++)
			{
				lpBuffer[i] = s[i];
			}
			lpBuffer[i] = '\0';
			// change the value in register (param)
			ctx.R8 = dwNumOfBytesToWrite;
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			printf("\n### converted string : %s\n", lpBuffer);
			printf("\n### converted string length : %lld\n", dwNumOfBytesToWrite);

			// #7. copy to buffer of riteFile()
			WriteProcessMemory(g_cpdi.hProcess, (LPVOID)dwAddrOfBuffer, lpBuffer, dwNumOfBytesToWrite, &bytes_written);

			// #8. free temporary buffer
			free(lpBuffer);

			// #9. change EIP to the first address of WriteFile()
			//  now = WriteFile()+1 (after INT 3)

#ifndef _WIN64
			ctx.Eip = (DWORD)g_pfWriteFile;
#else
			ctx.Rip = (LONGLONG)g_pfWriteFile;
#endif
			SetThreadContext(g_cpdi.hThread, &ctx);

			// #10. run debug process
			ContinueDebugEvent(pde->dwProcessId, pde->dwThreadId, DBG_CONTINUE);
			Sleep(0);

			// #11. API hook
			WriteProcessMemory(g_cpdi.hProcess, g_pfWriteFile, &g_chINT3, sizeof(BYTE), NULL);

			return TRUE;
		}
	}
	return FALSE;
}

// loop
void DebugLoop()
{
	DEBUG_EVENT de;
	DWORD dwCOntinueStates;

	// wait for debug event
	while (WaitForDebugEvent(&de, INFINITE))
	{
		dwCOntinueStates = DBG_CONTINUE;
		// wait for debug process to generate or attach to the event
		if (CREATE_PROCESS_DEBUG_EVENT == de.dwDebugEventCode)
		{
			OnCreateProcessDebugEvent(&de);
		}
		// exception events
		else if (EXCEPTION_DEBUG_EVENT == de.dwDebugEventCode)
		{
			if (OnExceptionDebugEvent(&de))
				continue;
		}
		// debug process exit
		else if (EXIT_PROCESS_DEBUG_EVENT == de.dwDebugEventCode)
		{
			break;
		}
		// run debug process
		ContinueDebugEvent(de.dwProcessId, de.dwThreadId, dwCOntinueStates);
	}
}

// main
int main(int argc, char*argv[])
{
	DWORD dwPID = FindProcessID(DEF_PROC_NAME);
	if (!DebugActiveProcess(dwPID))
	{
		printf("DebugActiveProcess(%d) failed!!!\n" "Error Code = %d\n", dwPID, GetLastError());
		system("pause");
		return 1;
	}

	// loop
	DebugLoop();
	system("pause");
	return 0;
}