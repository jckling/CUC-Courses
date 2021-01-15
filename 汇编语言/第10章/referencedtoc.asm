assume cs:code,ds:data
data segment
     db 10 dup (0)
data ends

code segment
start:   mov ax,12666
     mov bx,data
     mov ds,bx
     mov si,0 ;ds:si指向data首地址
     call dtoc1

     mov dh,8
     mov dl,3
     mov cl,2
     call show_str

     mov ax,4c00h
     int 21h


;名称：dtoc1
;功能：将word型数据转变为表示十进制的字符串，字符串以0为结尾符。
;参数：(ax)=word型数据；
;      ds:si指向字符串首地址。
;返回：无。

dtoc1:   
     ;请实现这个部分

;名称：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串。
;参数：(dh)=行号(取值范围0~24)；
;      (dl)=列号(取值范围0~79)；
;      (cl)=颜色；
;      ds:si指向字符串的首地址。
;返回：无。
show_str:
     push ax
     push bx
     push es
     push si
     mov ax,0b800h
     mov es,ax
     mov ax,160
     mul dh
     mov bx,ax     ;bx=160*dh
     mov ax,2
     mul dl        ;ax=dl*2
     add bx,ax     ;mov bx,(160*dh+dl*2)设置es:bx指向显存首地址
     mov al,cl     ;把颜色cl赋值al
     mov cl,0

show0:
     mov ch,[si]
     jcxz show1    ;(ds:si)=0时，转到show1执行    
     mov es:[bx],ch
     mov es:[bx].1,al
     inc si        ;ds:si指向下一个字符地址
     add bx,2      ;es:bx指向下一个显存地址
     jmp show0

show1:
     pop si
     pop es
     pop bx
     pop ax
     ret

code ends
end start
