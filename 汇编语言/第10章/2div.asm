assume cs:code,ss:temp

temp segment
	db 64 dup(0)
temp ends

code segment
start:
	mov ax,4240h
	mov dx,00fh
	mov cx,0ah
	call divdw

	mov ax,4c00h
	int 21h

divdw:
	mov bx,ax	;暂存ax——被除数的低16位
 	mov ax,dx 	;ax=H 被除数的高16位
 	mov dx,0
 	div cx  	;ax为商，dx为余数=rem(H/N)*65536
 
 	push ax  	;结果的商的高16位，最后放在dx中

 	mov ax,bx 	;dx为rem(H/N)*65536, 为高16位，ax为低16位，再进行一次除法运算
 	div cx  	;ax为商——最后结果的低16位，dx为余数——为最后结果，应赋给cx

 	mov cx,dx

 	pop dx
 	ret

code ends
end start