;a段和b段的数据依次相加，结果存到c段
assume cs:code

a segment
	db 1,2,3,4,5,6,7,8
a ends

b segment
	db 1,2,3,4,5,6,7,8
b ends

c segment
	db 0,0,0,0,0,0,0,0
c ends

code segment
start:
	mov ax,a
	mov ds,a
	mov ax,b
	mov es,ax

	mov bx,0

	mov cx,8
	s:	mov al,ds:[bx]
		add al,es:[bx]
		mov es:[bx],al
		inc bx
		loop s

	mov ax,c
	mov ds,ax
	mov bx,0
	mov cx,8
	s1:	mov ds:[bx],es:[bx]
		inc bx
		loop s1

	mov ax,4c00h
	int 21h
code ends
end start