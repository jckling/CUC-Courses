;显示一个用0结束的字符串
assume cs:code

code segment
start:
	mov ax,cs
	mov ds,ax
	mov si,offset capital
	mov ax,0
	mov es,ax
	mov di,200h
	mov cx,offset capitalend-offset capital
	cld
	rep movsb

	mov ax,0
	mov es,ax
	mov word ptr es:[7ch*4],200h
	mov word ptr es:[7ch*4+2],0
	mov ax,4c00h
	int 21h

capital:
	mov bx,0b800h
	mov es,bx				;显存起始地址

	mov al,0a0h 			;每行160字节
	mul dh
	mov bx,ax				;行数

	mov ax,2 				;每列2字节
	mul dl					;列数

	add bx,ax				;列数+行数
			
	mov dl,cl				;将cl存到dl
	mov ch,0				;用于判断

	s:	
		mov cl,ds:[si]
		jcxz ok				;判断是否为0

		mov al,ds:[si]		;逐字节送入显存的内存地址
		mov ah,dl			;效果
		mov es:[bx],ax		;将(字母+效果)送入显存地址
		inc si				;下一个字节
		add bx,2			;偏移+2
		jmp short s 		;循环

	ok:
		iret				;返回

capitalend:
	nop

code ends
end start