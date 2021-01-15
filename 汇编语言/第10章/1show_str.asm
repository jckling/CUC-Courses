assume cs:code

data segment
	db 'Welcome to masm!',0
data ends

code segment
start:
	mov dh,8				;行
	mov dl,3				;列
	mov cl,2				;颜色
	mov ax,data
	mov ds,ax
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h

show_str:
	mov bx,0b800h
	mov es,bx				;显存起始地址

	mov al,0a0h 			;一行160个字节
	mul dh
	mov bx,ax				;行数

	mov al,2
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
		ret						;返回

code ends
end start