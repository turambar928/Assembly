assume cs:code

data segment
    db 'Tongji University!' ; 字符串
    db 00000010b          ; 绿字 (前景绿色，背景黑色) 
    db 11,12,13,64       
data ends

stack segment
    dw 8 dup (0)         ; 栈空间
stack ends

code segment
start:
    ; 初始化数据段和栈段
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 16

    ; 清屏操作
    jmp cls

; 清屏部分
cls:
    mov bx, 0b800h        ; 显存地址 0xb800
    mov es, bx            ; 将 ES 寄存器指向显存
    mov bx, 0             ; 初始化 BX 寄存器为 0
    mov cx, 4000          ; 4000 字节，表示 25 行 * 80 字符 * 2 字节（字符 + 属性）
clear_screen:
    mov dl, 0             ; 将 NULL 字符 (ASCII 0) 放入低位
    mov dh, 0             ; 将颜色设为黑色背景和绿色前景色（0x02）
    mov es:[bx], dx       ; 将字符和颜色写入显存
    add bx, 2             ; 每次操作 2 字节（字符 + 属性）
    loop clear_screen     ; 循环直到清空所有 4000 字节

    ; 打印字符串
    mov cx, 3             ; 打印 3 行
row:
    ; 计算每行的起始位置和颜色
    mov dx, cx
    mov si, 3
    sub si, cx
    mov ch, 0
    mov cl, 19[si]        ; 每行字符串的颜色
    mov bp, 0             ; 字符的起始位置

    ; 循环打印每行
col:
    add bp, 1920          
    mov ah, 0
    mov al, ds:[22]     
    add bp, ax            
    mov si, 3
    sub si, dx
    mov ah, 16[si]
    mov bx, 0
    mov cx, 18            ; 打印每行的 16 个字符
fill:
    mov al, [bx]          ; 获取字符
    push ds
    mov si, 0b800h        ; 设置显存地址
    mov ds, si
    mov ds:[bp], ax       ; 将字符和属性写入显存
    pop ds
    inc bx
    add bp, 2             ; 移动到下一个字符位置
    loop fill

    mov cx, dx
    loop row

    ; 程序退出
    mov ax, 4C00h
    int 21h

code ends
end start
