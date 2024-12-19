data segment

    tmp dw 0
    time db 0 

    ;菜单1:选择2位数的加法
    menu1 db 0dh,0ah,'1. select 2-digit addition $'
    ;菜单2:选择2位数的减法
    menu2 db 0dh,0ah,'2. select 2-digit subtraction $'
    ;菜单3:选择1位数的乘法
    menu3 db 0dh,0ah,'3. select 1-digit multiplication $'
    ;菜单4:选择1位数的除法
    menu4 db 0dh,0ah,'4. select 1-digit division $'
    ;选择菜单
    menu5 db 0dh,0ah,'5. input option :$',0dh,0ah,'$'

    ;结果正确,恭喜
    right db 0dh,0ah,'result is right ,congratulations !$'
    ;结果错误,请重新输入
    wrong db 0dh,0ah,'result is wrong ,please input again :$'

    ;正确答案是
    right_answer db 0dh,0ah,'right answer is :$'

    ;除数为0
    zero1 db 0dh,0ah,'divisor is 0 ,error:$'

    ;输入的字符串buf
    input_score_buf DB  10,'?',9 DUP('$') 
    total_num dw 0

    ;2位数
    first_num2 dw 0
    second_num2 dw 0
    result_num2 dw 0 ;结果
    ;1位数
    first_num1 dw 0
    second_num1 dw 0
    result_num1 dw 0 ;结果
   
    CRLF DB 0AH,0DH,'$'
    flag db 0 ;标志位
data ends
code segment
    assume cs:code,ds:data,es:data
start:    
    mov    ax,data  
    mov    ds,ax          
    mov    es,ax     

    
    ;随机生成40个数
   ; call  get_random

loop1:
    call show_menu
    ;输入选项
    mov ah,1
    int 21h
    cmp al,'1'
    je add_2_digit
    cmp al,'2'
    je sub_2_digit
    cmp al,'3'
    je mul_1_digit
    cmp al,'4'
    je div_1_digit
    cmp al,'q' ;退出
    je exit
    jmp loop1

add_2_digit:
    call outputcrlf
    ;2位数的加法
    call add_2_digit_func
    jmp loop1
sub_2_digit:
    call outputcrlf
    ;2位数的减法
    call sub_2_digit_func
    jmp loop1
mul_1_digit:
    ;1位数的乘法
    call outputcrlf
    call mul_1_digit_func
    jmp loop1
div_1_digit:
    ;1位数的除法
    call outputcrlf
    call div_1_digit_func
    jmp loop1
exit:
    mov    ah,4ch
    int    21h

;输出换行
OUTPUTCRLF PROC
    LEA DX,CRLF
    MOV AH,09H
    INT 21H
    RET
OUTPUTCRLF ENDP


add_2_digit_func proc
    ;获取一个随机数
    call get_random
    mov tmp,ax
    mov first_num2,ax
    call myprint1
    ;打印+
    mov dl,'+'
    mov ah,2
    int 21h
    ;获取一个随机数
    call get_random
    mov tmp,ax
    mov second_num2,ax
    call myprint1

    ;打印=
    mov dl,'='
    mov ah,2
    int 21h

    ;计算结果 加法
    mov ax,first_num2
    add ax,second_num2
    mov result_num2,ax ;结果
    ;call myprint1

    mov cx,2
input_answer:
    push cx
    ;输入字符串
    lea dx,input_score_buf
    mov ah,0ah
    int 21h

    ;转为数字
    lea si, input_score_buf+1     ; 加载字符串的地址,跳过第一个字节,因为第一个字节是存储字符串长度的,第二个字节是实际的字符
    lea di, total_num          ; 加载存储结果的地址
    call StringToNumber

    ;判断结果
    mov ax,result_num2
    mov bx,total_num
    cmp ax,bx
    je right1
    jmp wrong1
right1:
    ;打印right
    lea dx,right
    mov ah,9
    int 21h
    pop cx
    ret
wrong1:
    pop cx
    cmp cx,1
    je end1111
    ;打印wrong
    lea dx,wrong
    mov ah,9
    int 21h
end1111:
    loop  input_answer

    ;right_answer
    lea dx,right_answer
    mov ah,9
    int 21h

    ;打印正确答案
    mov ax,result_num2
    mov tmp,ax
    call myprint1

    ret
add_2_digit_func endp

sub_2_digit_func proc

;获取一个随机数
    call get_random
    mov tmp,ax
    mov first_num2,ax
    call myprint1
    ;打印+
    mov dl,'-'
    mov ah,2
    int 21h
    ;获取一个随机数
    call get_random
    mov tmp,ax
    mov second_num2,ax
    call myprint1

    ;打印=
    mov dl,'='
    mov ah,2
    int 21h

    ;计算结果 加法
    mov ax,first_num2
    sub ax,second_num2
    mov result_num2,ax ;结果

    ;判断是否是负数
    cmp ax,0
    jg next11111;  如果是大于0,
    mov flag,'-'
    neg ax
    mov result_num2,ax
next11111:
    mov cx,2
input_answer2:
    push cx
    ;输入字符串
    lea dx,input_score_buf
    mov ah,0ah
    int 21h

    ;转为数字
    lea si, input_score_buf+1     ; 加载字符串的地址,跳过第一个字节,因为第一个字节是存储字符串长度的,第二个字节是实际的字符
    mov cl,[si] ;获取字符串长度 
    mov al,[si+1] ;判断是否是负号
    cmp al,'-'
    jne next2
    add si,1; 跳过负号
    dec cl; 重新赋值字符串长度
    mov [si],cl; 重新赋值字符串长度
next2:
 
    lea di, total_num          ; 加载存储结果的地址
    call StringToNumber

    ;判断结果
    mov ax,result_num2
    mov bx,total_num
    cmp ax,bx
    je right2 ;je是有符号比较还是无符号比较:有符号比较
    jmp wrong2
right2:
    ;打印right
    lea dx,right
    mov ah,9
    int 21h
    pop cx
    mov flag,0
    ret
wrong2:
    pop cx
    cmp cx,1
    je end222
    ;打印wrong
    lea dx,wrong
    mov ah,9
    int 21h
end222:
    loop  input_answer2

    ;right_answer
    lea dx,right_answer
    mov ah,9
    int 21h

    ;判断flag是否是-
    cmp flag,'-'
    jne no_flag
    ;打印-
    mov dl,'-'
    mov ah,2
    int 21h

no_flag:
    mov ax,result_num2
    mov tmp,ax
    call myprint1

    mov flag,0
    ret
sub_2_digit_func endp

mul_1_digit_func proc

   ;获取一个随机数
    call get_random1
    mov tmp,ax
    mov first_num1,ax
    call myprint1
    ;打印+
    mov dl,'*'
    mov ah,2
    int 21h
    ;获取一个随机数
    call get_random1
    mov tmp,ax
    mov second_num1,ax
    call myprint1

    ;打印=
    mov dl,'='
    mov ah,2
    int 21h

    ;计算结果 乘法
    mov dx,0
    mov ax,first_num1
    mov bx,second_num1
    mul bl
    mov result_num1,ax ;结果


    mov cx,2
input_answer3:
    push cx
    ;输入字符串
    lea dx,input_score_buf
    mov ah,0ah
    int 21h

    ;转为数字
    lea si, input_score_buf+1     ; 加载字符串的地址,跳过第一个字节,因为第一个字节是存储字符串长度的,第二个字节是实际的字符
    lea di, total_num          ; 加载存储结果的地址
    call StringToNumber

    ;判断结果
    mov ax,result_num1
    mov bx,total_num
    cmp ax,bx
    je right3
    jmp wrong3
right3:
    ;打印right
    lea dx,right
    mov ah,9
    int 21h
    pop cx
    ret
wrong3:
    pop cx
    cmp cx,1
    je end3333
    ;打印wrong
    lea dx,wrong
    mov ah,9
    int 21h
end3333:
    loop  input_answer3

    ;right_answer
    lea dx,right_answer
    mov ah,9
    int 21h

    ;打印正确答案
    mov ax,result_num1
    mov tmp,ax
    call myprint1


    ret
mul_1_digit_func endp

div_1_digit_func proc


   ;获取一个随机数
    call get_random1
    mov tmp,ax
    mov first_num1,ax
    call myprint1
    ;打印+
    mov dl,'/'
    mov ah,2
    int 21h
    ;获取一个随机数
    call get_random1
    mov tmp,ax
    mov second_num1,ax
    call myprint1

    ;打印=
    mov dl,'='
    mov ah,2
    int 21h

    ;计算结果 乘法
    mov dx,0
    mov ax,first_num1
    mov bx,second_num1

    ;判断除数是否为0
    cmp bx,0
    jne no_zero
    ;zero1
    lea dx,zero1
    mov ah,9
    int 21h
    ret ;直接返回

no_zero:
    div bl
    mov ah,0
    mov result_num1,ax ;结果


    mov cx,2
input_answer4:
    push cx
    ;输入字符串
    lea dx,input_score_buf
    mov ah,0ah
    int 21h

    ;转为数字
    lea si, input_score_buf+1     ; 加载字符串的地址,跳过第一个字节,因为第一个字节是存储字符串长度的,第二个字节是实际的字符
    lea di, total_num          ; 加载存储结果的地址
    call StringToNumber

    ;判断结果
    mov ax,result_num1
    mov bx,total_num
    cmp ax,bx
    je right4
    jmp wrong4
right4:
    ;打印right
    lea dx,right
    mov ah,9
    int 21h
    pop cx
    ret
wrong4:
    pop cx
    cmp cx,1
    je end444
    ;打印wrong
    lea dx,wrong
    mov ah,9
    int 21h
end444:
    loop  input_answer4

    ;right_answer
    lea dx,right_answer
    mov ah,9
    int 21h

    ;打印正确答案
    mov ax,result_num1
    mov tmp,ax
    call myprint1


    ret
    ret
div_1_digit_func endp



show_menu proc 
    ;显示菜单
    lea dx,menu1
    mov ah,9
    int 21h
    lea dx,menu2
    mov ah,9
    int 21h
    lea dx,menu3
    mov ah,9
    int 21h
    lea dx,menu4
    mov ah,9
    int 21h
    lea dx,menu5
    mov ah,9
    int 21h

    ret 
show_menu endp


get_random proc
    ;延时函数
    call delay

    MOV AH, 2CH ;得到系统时间
    INT 21H ;返回值 
    add dl,1
    MOV time, dl   
    ; AH = 2CH号功能，得到系统时间，dl = 秒钟。
    ; 也就是ni = time， 然后 nii = (A * ni + B) % p + 1,A是一个常数，B是一个常数，p是一个素数
    ;举例：A = 7, B = 3, p = 11
    ;得到0-100之间的数
    ;nii = (7 * ni + 3) % 99
    

    mov ax,7
    mov bl,time
    mul bl  ;ax = 7 * time
    mov bl,time
    add al,bl ;ax = 7 * time + 3
    mov bx,99
    div bl ;ax = (7 * time + 3) % 99
    ;余数是ah
    ;如果ah<10,那么+10
    cmp ah,10
    jae loop_next; jae是大于等于
    add ah,10
loop_next:
    mov al,ah
    mov ah,0
    ;返回ax
    ret
get_random endp



get_random1 proc
    ;延时函数
    call delay

    MOV AH, 2CH ;得到系统时间
    INT 21H ;返回值 
    add dl,1
    MOV time, dl   
    ; AH = 2CH号功能，得到系统时间，dl = 秒钟。
    ; 也就是ni = time， 然后 nii = (A * ni + B) % p + 1,A是一个常数，B是一个常数，p是一个素数
    ;举例：A = 7, B = 3, p = 11
    ;得到0-100之间的数
    ;nii = (7 * ni + 3) % 10 , 0-9 
    

    mov ax,7
    mov bl,time
    mul bl  ;ax = 7 * time
    mov bl,time
    add al,bl ;ax = 7 * time + 3
    mov bx,10
    div bl ;ax = (7 * time + 3) % 99

    mov al,ah
    mov ah,0
    ;返回ax
    ret
get_random1 endp

delay proc
    push cx
    push dx

    ;延时10000次
    mov cx,50000
    delay1:
    nop
    loop delay1


    pop dx
    pop cx
    ret
delay endp


;打印
myprint1 proc
    push ax
    push bx
    push dx
    push cx

    mov ax,0
    mov dx, 0
    mov bx, 0
    mov ax, tmp
    mov bx, 100
    div bx ; ax存100位数, 
    push dx

    ;打印ax
    add ax, '0'
    mov dl, al
    mov ah, 2
    int 21h

    pop dx
    mov ax, dx
    mov dx, 0
    mov bx, 10
    div bx ; ax存10位数, dx存个位数
    push dx
    ;打印10位数
    add ax, '0'
    mov dl, al
    mov ah, 2
    int 21h
    ;打印个位数
    pop dx
    add dx, '0'
    mov dl, dl
    mov ah, 2
    int 21h

    ;打印空格
    mov dl, ' '
    mov ah, 2
    int 21h

    pop cx
    pop dx
    pop bx
    pop ax
    ret
myprint1 endp



; 子程序：StringToNumber
; 功能：将以null结尾的字符串转换为数字
StringToNumber proc near
    push ax
    push bx
    push cx
    push dx
    xor ax, ax      ; 清除AX寄存器
    xor cx, cx      ; 清除CX寄存器
    ;把第一个字符取出来
    mov bx,0
    mov bl, [si]    ; 加载第一个字符到AL,这是实际的字符长度  1234 那就是=4
    ;存储到tmp
    ; mov tmp, bx  ;实际的字符长度存储到tmp
    add si, 1     
    sub bl, 1   

    mov cx,0
    mov ax,1
    mov bp,0
NextDigit:
    lodsb               ; 加载下一个字符到AL lodsb 是把 ds:si 指向的内存单元中的字节传送到 al 中，并且 si 加 1
    cmp al, 0dh         ; 检查是否到达字符串结尾
    je ConversionDone
    sub al, '0'         ; 将字符转换为数字
    ;如果bl=0
    mov ah,0
    cmp bl,0
    je last
    mov cl,bl
mulloop:
    mov dx,10
    mul dx    
    loop mulloop
    DEC bl
last:
    add bp,ax
    jmp NextDigit

ConversionDone:
    ; 存储结果
    mov [di], bp
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
StringToNumber endp





code ends
end start
