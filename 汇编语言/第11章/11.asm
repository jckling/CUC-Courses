;以0结尾的字符串中的小写字母转变为大写字母
assume cs:codesg

datasg segment
	db "Hello World! Let's masm!",0
datasg ends

codesg segment
begin:
	mov ax,datasg
	mov ds,ax
	mov si,0
	call letterc

	mov ax,4c00h
	int 21h

letterc:
	mov cl,0
	compare:
		mov ch,ds:[si]
		jcxz ok
		cmp byte ptr ds:[si],97			;小写a
		jb back
		cmp byte ptr ds:[si],122		;小写z
		ja back
		sub byte ptr ds:[si],32			;大写A，65
	back:
		inc si
		jmp compare
	ok:
		ret

codesg ends
end begin