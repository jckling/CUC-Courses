assume ds:datasg,cs:codesg,ss:stacksg

datasg segment
	db 'w','e','l','c','o','m','e',' ','t','o',' ','m','a','s','m','!'
	db 16 dup (00000010b)
	db 'w','e','l','c','o','m','e',' ','t','o',' ','m','a','s','m','!'
	db 16 dup (00001010b)
	db 'w','e','l','c','o','m','e',' ','t','o',' ','m','a','s','m','!'
	db 16 dup (10011110b)
datasg ends

stacksg segment
	db 16 dup(0)
stacksg ends

codesg segment
start:
		mov ax,0b800h
		mov ds,ax

		mov ax,datasg
		mov es,ax

		mov ax,stacksg
		mov ss,ax
		mov sp,16

		mov bx,160*11
		mov si,0
		mov cx,3

		s:
			push cx
			mov di,80-16
			mov cx,16

			s0:
				mov dl,cs:[si]
				mov ds:[bx+di],dl
				inc di
				mov dl,es:[si+16]
				mov ds:[bx+di],dl
				inc di
				inc si
				loop s0

			add si,16
			add bx,160
			pop cx
			loop s

		mov ax,4c00h
		INT 21h
codesg ends
end start