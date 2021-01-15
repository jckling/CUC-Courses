;名称：int 7ch中断例程 
;功能：完成loop指令功能，中断例程安装在0:200处 
;参数：(cx)=循环次数，(bx)=位移 

assume cs:code   
code segment  

start:  
;取得写好的中断例程的存储地址，将他复制到0200：0处
;通过offset lp取得初始地址
;需要传送多少？在中断例程结束的位置设置lpend标号，通过offset lpend-offset lp作为传输长度
       
	   
	   
	   
;设置中断向量表中7ch例程原来存放的入口地址为新的入口地址：0200：0
;考虑地址怎么计算   4N  4N+2
       

        mov ax,4c00h  
        int 21h  

;此段为新的7ch中断例程，思考如何利用jcxz模拟loop指令
lp:     


;在中断例程结束的位置设置lpend标号，可辅助取得中断例程的长度
    
        iret   ;为什么使用iret？请思考原因

        mov ax,4c00h  
        int 21h  

lpend:nop  

code ends  
end start 

