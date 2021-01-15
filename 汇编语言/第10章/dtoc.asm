assume cs:code

code segment
start:

	mov ax,4c00h
	int 21h
dtoc:
	push ax
    push bx
    push cx
    push dx
    push si

    mov bx,0					;存位数
	s:
		mov cx,10				;除数
		call divdw

		push cx					;余数入栈

		inc bx					;记录位数

		cmp ax,0				;低位不为0
		jne s
		cmp dx,0				;高位不为0
		jne s

		mov cx,bx				;位数，出栈次数
	ok:
		pop ds:[si]	
		inc si
		loop ok

	add byte ptr ds:[si],'0'	;结尾加个‘0’
		
	pop si
    pop dx
    pop cx
    pop bx
    pop ax
	ret 				;返回


divdw:
	mov bx,ax	;暂存ax——被除数的低16位
 	mov ax,dx 	;ax=H 被除数的高16位
 	mov dx,0
 	div cx  	;ax为商，dx为余数=rem(H/N)*65536
 
 	push ax  	;结果的商，最后放在dx中

 	mov ax,bx 	;dx为rem(H/N)*65536, 为高16位，ax为低16位，再进行一次除法运算
 	div cx  	;ax 为商——最后结果的低16位，dx为余数——为最后结果，应赋给cx

 	mov cx,dx

 	pop dx
 	ret			;返回

code ends
end start