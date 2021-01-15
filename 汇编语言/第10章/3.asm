assume cs:code

data segment
	db 10 dup (0)
data ends

code segment
start:
	mov ax,3
	mov bx,data
	mov ds,bx
	mov si,0
	call dtoc

	mov dh,8
	mov dl,3
	mov cl,2
	call show_str

	mov ax,4c00h
    int 21h

dtoc:
	push ax
    push bx
    push dx
    push si						;暂存

    mov dx,0					;存余数
	mov bx,10					;除数
	
	push dx						;压栈

	s:
		mov cx,ax
		jcxz ok					;判断商是否为零
			
		div bx					;做除法

		add dx,30h				;加上30h，转变成字符

		push dx					;压栈

		mov dx,0				;被除数高位置0，低位为ax(存商)

		jmp s 					;循环

	ok:
		mov ch,0
		
		sw:
			pop dx				;出栈
			mov cl,dl
			jcxz swok
			mov ds:[si],dl		;正序出栈
			inc si				;下一个数字(字节)
			jmp sw 				;循环

		swok:
			mov word ptr ds:[si],0
			pop si
     		pop dx
     		pop bx
     		pop ax 				;恢复
			ret 				;返回

show_str:
	push ax
    push bx
    push es
    push si 					;暂存

	mov bx,0b800h
	mov es,bx					;显存起始地址

	mov al,0a0h
	mul dh
	mov bx,ax					;行数

	mov ax,2
	mul dl						;列数

	add bx,ax					;列数+行数
			
	mov dl,cl					;将cl存到dl
	mov ch,0					;用于判断

	s0:	
		mov cl,ds:[si]
		jcxz over				;判断是否为0

		mov al,ds:[si]			;逐字节送入显存的内存地址
		mov ah,dl				;效果
		mov es:[bx],ax			;将(字母+效果)送入显存地址
		inc si					;下一个字节
		add bx,2				;偏移+2
		jmp short s0 			;循环

	over:
		pop si
     	pop es
     	pop bx
     	pop ax 					;恢复
		ret						;返回


code ends
end start