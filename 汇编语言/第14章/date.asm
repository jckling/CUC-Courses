;以“年/月/日 时:分:秒”的格式，显示当前的日期、时间
assume cs:codesg,ds:datasg

datasg segment
	db 9,8,7,4,2,0				;单元位置
	db '// :: '					;符号
datasg ends

codesg segment
start:
	mov ax,datasg
	mov ds,ax
	mov bx,0b800h				;显存起始地址
	mov es,bx

	mov bx,0					;获取单元位置
	mov di,6					;获取符号
	mov si,0					;递增显存位置
	mov cx,6					;循环次数

	s:
		push cx					;入栈，因为逻辑位移指令要用到cl
		mov al,ds:[bx]
		out 70h,al				;向70h端口写入要访问的单元的地址
		in al,71h				;从71h端口取得数据

		mov ah,al
		mov cl,4				;逻辑位移位数
		shr ah,cl 				;右移4位，十位数
		and al,00001111b		;个位数

		add ah,30h				;BCD码+30h=十进制ASCII码
		add al,30h

		pop cx					;出栈，恢复循环次数
		call show				;调用函数，显示在屏幕上
		inc bx					;下一个单元地址
		add si,6				;递增显示位置
		loop s 					;循环

	mov ax,4c00h
	int 21h

show:	
	mov byte ptr es:[160*12+30*2+si],ah 	;显示十位数
	mov byte ptr es:[160*12+30*2+2+si],al	;显示个位数
	mov al,ds:[di]							;获得符号
	mov byte ptr es:[160*12+30*2+4+si],al	;显示符号
	inc di									;下一个符号的地址
	ret							;返回

codesg ends
end start
