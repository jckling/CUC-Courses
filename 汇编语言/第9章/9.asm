;在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串
assume ds:datasg,cs:codesg

datasg segment
	db 'Hello World!'			;待输出的数据
datasg ends

codesg segment
start:
	mov ax,0b804h				;横向“中间”内存地址
	mov ds,ax

	mov ax,datasg
	mov es,ax
	
	mov si,0
	mov bx,160*12				;纵向“中间”内存地址
	mov cx,0ch					;12个字节

	s:
		mov al,es:[si]			;逐字送入显存的内存地址

		mov ah,00000111b		;效果
		mov ds:[bx],ax			;将效果送入显存地址

		mov ah,01110001b
		mov ds:[bx+160],ax		;换行

		mov ah,11000010b
		mov ds:[bx+160*2],ax	;再换行

		inc si					;下一个字节
		add bx,2
		loop s 					;循环逐字输出

	mov ax,4c00h
	int 21h
codesg ends
end start