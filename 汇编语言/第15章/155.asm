;按F1改变屏幕颜色
assume cs:code

stack segment
	db 128 dup(0)        ;栈段
stack ends

code segment
start:
	mov ax,stack
	mov ss,ax
	mov sp,128        						;栈指针

	push cs
	pop ds

	mov ax,0
	mov es,ax        						;中断向量表起始位置

	mov si,offset int9        				;设置ds:si指向源地址
	mov di,204h        						;设置es:di指向目的地址，将新的int9安装在0:204处
	mov cx,offset int9end-offset int9       ;设置cx为传输长度
	cld        								;设置传输方向为正

	rep movsb        						;循环传输

	push es:[9*4]
	pop es:[200h]
	push es:[9*4+2]
	pop es:[202h]        					;将原来的int 9中断例程的入口地址保存在(IP)0:200，(CS)0:202处

	cli        								;设置IF=0，禁止其他的可屏蔽中断
	mov word ptr es:[9*4],204h
	mov word ptr es:[9*4+2],0        		;设置int 9中断例程的入口为0:204
	sti        								;设置IF=1，处理可屏蔽中断

	mov ax,4c00h
	int 21h

int9:
	push ax        					;保护现场
	push bx
	push cx
	push es

	in al,60h        				;读取键盘输入

	pushf        					;标志寄存器入栈
	call dword ptr cs:[200h]        ;当次中断例程执行时(CS)=0

	cmp al,3bh        				;F1的扫描码（通码）为9eh
	jne int9ret        				;不等于F1的通码则返回

	mov ax,0b800h        			;屏幕上第一个字符起始位置
	mov es,ax
	mov bx,1
	mov cx,2000        				;循环次数，80*25
	s:
		inc byte ptr es:[bx]        ;改变颜色
		add bx,2
		loop s

int9ret:
	pop es        	;还原现场
	pop cx
	pop bx
	pop ax
	iret        	;返回

int9end:
	nop
code ends
end start
