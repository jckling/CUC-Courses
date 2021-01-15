;将每个单词的前4个字母改写为大写字母
assume cs:codesg,ds:datasg,ss:stacksg

stacksg segment					;栈段，容量为16个字节
    dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       '
datasg ends

codesg segment
start:
    mov ax,stacksg
    mov ss,ax
    mov sp,16
    mov ax,datasg
    mov ds,ax
    mov bx,3

    mov cx,4					;外层循环次数，共四个单词
    s0:
        push cx
        mov si,0
        mov cx,4				;内层次数，前四个字母
        s:
            mov al,[bx+si]
            and al,11011111b
            mov [bx+si],al
            inc si
            loop s

        add bx,16 				;下一行单词
        pop cx
        loop s0					;外层循环次数-1

    mov ax,4c00h
	int 21h
    
codesg ends
end start