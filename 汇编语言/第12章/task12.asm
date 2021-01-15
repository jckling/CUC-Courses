assume cs:code

code segment
start:
	int 0

	mov ax,4c00h
	int 21h
code ends
end start