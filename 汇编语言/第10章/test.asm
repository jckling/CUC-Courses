assume cs:code

data segment
	db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db 	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db	'1993','1994','1995'
	;以上是表示21年的21个字符串

	dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5931000
	;以上是表示21年公司总收入的21个dword型数据

	dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw	11542,14430,15257,17800
	;以上是表示21年公司雇员人数的21个word型数据
data ends

table segment
	db 21 dup ('year summ ne ?? ')
table ends

temp segment
	db 16 dup(0)	;用于暂存字符串
temp ends

code segment
start:
		mov ax,table
		mov ds,ax 						;指向数据

		mov ax,data	
		mov es,ax						;存数据

		mov bx,0
		mov si,0
		mov di,0
		mov cx,21						;循环21次

		s0:
			mov ax,es:[si]				;逐字存年份
			mov ds:[bx],ax
			mov ax,es:[si+2]
			mov ds:[bx+2],ax

			mov ax,es:[si+21*4]			;逐字存总收入
			mov ds:[bx+5],ax
			mov ax,es:[si+21*4+2]
			mov ds:[bx+7],ax

			mov ax,es:[di+21*4+21*4]	;逐字存人数
			mov ds:[bx+10],ax

			mov ax,ds:[bx+5]
			mov dx,ds:[bx+7]
			div word ptr ds:[bx+10]		;计算人均收入

			mov ds:[bx+13],ax 			;逐字存人均收入

			add di,2
			add si,4
			add bx,16 					;下一行数据
			loop s0

		call show 						;打印到屏幕上

		mov ax,4c00h
		int 21h

show:
	mov ax,table
	mov es,ax
	mov di,0 		;年份

	mov cx,21		;循环次数
	mov dh,1 		;起始行数，因为运行完程序后会有一条空行，因此就从第二行开始打印
	showyear:
		push cx

		mov byte ptr es:[di+4],0

		mov dl,0 		;列数
		mov cl,2 		;字体属性
		mov si,di	
		call show_str

		add dh,1 		;屏幕下一行
		add di,10h 		;下一行数据

		pop cx
		loop showyear

	mov ax,temp
	mov ds,ax
	mov si,0		;ds:si指向暂存字符串的地方，temp:0
	mov di,5 		;总收入
	mov cx,21		;循环次数
	mov dh,1 		;起始行数
	showsalary:
		push cx
		push dx

		mov ax,es:[di] 		;总收入高位
		mov dx,es:[di+2] 	;总收入低位
		call dtoc_dw 		;转化为以0结尾的字符串

		pop dx
		mov dl,19 	;列数
		mov cl,2 	;字体属性
		call show_str

		add dh,1 		;屏幕下一行
		add di,10h 		;下一行数据

		pop cx
		loop showsalary

	mov di,0ah 	;人数
	mov bl,39 	;列数
	call func_show

	mov di,0dh 	;人均收入
	mov bl,59 	;列数
	call func_show
	ret

func_show:
	mov cx,21		;循环次数
	mov dh,1 		;起始行数

	showdata:
		push cx

		mov ax,es:[di]
		call dtoc 		;将十进制数转化为0结尾的字型数据

		mov dl,bl 		;列数
		mov cl,2		;字体属性
		call show_str

		add dh,1 		;屏幕下一行
		add di,10h 		;下一行数据

		pop cx
		loop showdata
	ret

dtoc:
	push ax
    push bx
    push cx
    push dx
    push si

    mov dx,0					;存余数
	mov bx,10					;除数	
	push dx						;压栈，用于跳出的判断
	dtocs:
		mov cx,ax
		jcxz dtocok				;判断商是否为零		
		div bx					;做除法
		add dx,30h				;加上30h，转变成字符
		push dx					;压栈
		mov dx,0				;被除数高位置0，低位为ax(存商)
		jmp dtocs 				;循环

	dtocok:
		mov ch,0		
		sw:
			pop dx				;出栈
			mov cl,dl
			jcxz swok
			mov ds:[si],dl		;正序出栈
			inc si				;下一个数字(字节)
			jmp sw 				;循环

		swok:
			mov word ptr ds:[si],0 	;结尾加个0
			pop si
     		pop dx
     		pop cx
     		pop bx
     		pop ax
			ret 				;返回

dtoc_dw:
	push ax
    push bx
    push cx
    push dx
    push si

    mov bx,0					;存位数
	getnum:
		mov cx,0ah				;除数
		call divdw 				;获得商、余数
		add cx,30h 				;加上30h，转变成字符
		push cx					;余数入栈
		inc bx					;记录位数

		cmp dx,0				;低位不为0
		jne getnum
		cmp ax,0				;高位不为0
		jne getnum

		mov cx,bx				;位数，出栈次数
	oknum:
		pop ds:[si]
		inc si
		loop oknum

	mov word ptr ds:[si],0		;结尾加个0		
	pop si
    pop dx
    pop cx
    pop bx
    pop ax
	ret 				;返回

divdw:
	push bx
	push ax 	;暂存ax——被除数的低16位

 	mov ax,dx 	;ax=H 被除数的高16位
 	mov dx,0
 	div cx  	;ax为商，dx为余数=rem(H/N)*65536
 	
 	mov bx,ax 	;bx为商，结果的高16位

 	pop ax		;ax为低16位
 	div cx  	;ax 为商，结果的低16位

 	mov cx,dx 	;dx为余数，赋给cx
 	mov dx,bx 	;结果的高16位，赋给dx

 	pop bx
 	ret			;返回

show_str:
	push ax
    push bx
    push cx
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

	show_strs0:	
		mov cl,ds:[si]
		jcxz over				;判断是否为0

		mov al,ds:[si]			;逐字节送入显存的内存地址
		mov ah,dl				;效果
		mov es:[bx],ax			;将(字母+效果)送入显存地址
		
		inc si					;下一个字节
		add bx,2				;偏移+2
		jmp short show_strs0 	;循环

	over:
		pop si
     	pop es
     	pop cx
     	pop bx
     	pop ax 					;恢复
		ret						;返回

code ends
end start