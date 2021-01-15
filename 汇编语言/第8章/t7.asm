;将data段中的数据写入table段中，并计算人均收入（取整）
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

code segment
start:
		mov ax,table
		mov ds,ax

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

			mov ax,ds:[bx+5] 			;总收入低位字节
			mov dx,ds:[bx+7] 			;总收入高位字节
			div word ptr ds:[bx+10] 	;除以人数

			mov ds:[bx+13],ax 			;存人均收入，取整

			add di,2
			add si,4
			add bx,16
			loop s0

		mov ax,4c00h
		int 21h
code ends
end start