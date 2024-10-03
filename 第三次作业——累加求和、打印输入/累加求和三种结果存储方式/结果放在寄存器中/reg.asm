.model small
.stack 100h
.data
	result_msg db 'The sum of numbers from 1 to 100 is: $'
    input_buf db 2, 0, 10 dup(0)  ; 输入缓冲区
	newline db 13, 10, '$' ; 回车符和换行符
.code
main proc
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 计算从 1 加到 100 的和，结果放在寄存器 AX 中
    mov cx, 100       ; 循环计数器
    xor ax, ax        ; 清零 AX
    mov bx, 1         ; 从 1 开始

sum_loop:
    add ax, bx        ; 将 BX 加到 AX 中
    inc bx            ; BX 自增
    loop sum_loop     ; CX 递减，循环

    ; 输出结果（和）
	
    call print_result

    ; 程序结束
    mov ax, 4C00h
    int 21h

main endp

; 打印结果
print_result proc
    ; 将 AX 中的数字转换为字符串并打印
    mov bx, 10
    xor cx, cx

convert_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    ret
print_result endp

end main



