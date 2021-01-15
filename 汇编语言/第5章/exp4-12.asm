;向内存0:200~0:23F依次传送数据0~63(3FH)
assume cs:code

code segment
start:
	mov ax,0
	mov ds,ax
	mov bx,200h
	mov cx,64
s:
	mov [bx],ax
	inc bx
	inc ax
	loop s

	mov ax,4c00h
	int 21h

code ends
end start