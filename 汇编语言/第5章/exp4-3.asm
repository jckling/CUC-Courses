;将"mov ax,4c00h"之前的指令复制到0:200处
assume cs:code
code segment
start:
	mov ax,cs	;code段的起始地址
	mov ds,ax
	mov ax,0020h
	mov es,ax
	mov bx,0
	mov cx,17h	;指令长度，16进制
s:
	mov al,[bx]
	mov es:[bx],al
	inc bx
	loop s

	mov ax,4c00h
	int 21h
code ends
end start