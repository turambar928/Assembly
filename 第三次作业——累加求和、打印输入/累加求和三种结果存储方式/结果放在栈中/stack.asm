.model small
.stack 100h
.data
    newline db 13, 10, '$'  ; 回车符和换行符

.code
main proc
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 计算从 1 加到 100 的和
    mov cx, 100             ; 循环计数器
    xor ax, ax              ; 清零 AX
    mov bx, 1               ; 从 1 开始

sum_loop:
    add ax, bx              ; 将 BX 加到 AX 中
    inc bx                  ; BX 自增
    loop sum_loop           ; CX 递减，循环

    ; 将结果压入栈中
    push ax                 ; 将和压入栈

    ; 输出结果
    call print_result

    ; 输出换行符
    mov dx, offset newline
    mov ah, 09h
    int 21h

    ; 程序结束
    mov ax, 4C00h
    int 21h

main endp

; 打印结果
print_result proc
    ; 从栈中取出 sum_result
    pop ax                  ; 弹出结果到 AX
    mov bx, 10              ; 除数 10
    xor cx, cx              ; 清零字符计数

convert_loop:
    xor dx, dx              ; 清零 DX
    div bx                  ; AX / BX, 商在 AX, 余数在 DX
    push dx                 ; 保存余数
    inc cx                  ; 记录字符数量
    test ax, ax             ; 检查 AX 是否为 0
    jnz convert_loop        ; 如果不为 0，继续循环

print_loop:
    pop dx                  ; 取出余数
    add dl, '0'             ; 转换为字符
    mov ah, 02h             ; DOS 打印字符功能
    int 21h                 ; 调用中断
    loop print_loop         ; 循环打印所有字符

    ret
print_result endp

end main
