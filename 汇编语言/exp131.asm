assume cs:code  

code segment 

start:

mov ax,cs 

mov ds,ax 

mov si,offset do0                ;设置ds:si指向源地址 

mov ax,0 

mov es,ax 

mov di,200h                      ;设置es:di指向目标地址 

mov cx,offset do0end-offset do0  ;设置cx为传输长度 

cld                              ;设置传输方向为正 

rep movsb 

mov ax,0 

mov es,ax 

mov word ptr es:[7ch*4],200h 

mov word ptr es:[7ch*4+2],0      ;设置中断向量表 

mov ax,4c00h 

int 21h 

do0:

    push bp

	mov bp,sp

    add [bp+2],bx                    ;ok的偏移地址+bx得到s的偏移地址

	pop bp

	iret

	mov ax,4c00h 

	int 21h 

do0end:

    nop

code ends

end start