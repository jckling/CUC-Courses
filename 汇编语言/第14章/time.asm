;显示月份
assume cs:code

code segment
start:
	mov al,8							;访问的单元的地址
	out 70h,al							;将地址写入70h
	in al,71h							;从端口71h取得指定单元中的数据

	mov ah,al							;al=月份，十位+个位
	mov cl,4							;右移位数
	shr ah,cl							;ah中为月份的十位数码值
	and al,00001111b					;al中为月份的个位数码值

	add ah,30h							;转化为十进制数对应的ASCII码
	add al,30h

	mov bx,0b800h
	mov es,bx
	mov byte ptr es:[160*12+40*2],ah	;显示月份的十位数码
	mov byte ptr es:[160*12+40*2+2],al	;接着显示月份的个位数码

	mov ax,4c00h
	int 21h

code ends
end start