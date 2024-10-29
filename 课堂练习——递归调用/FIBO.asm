DATAS SEGMENT
    Prompt DB 'input number (1-100): $' ; 输入提示信息
    NewLine DB 0DH, 0AH, '$'            ; 换行符
DATAS ENDS

STACKS SEGMENT
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS, SS:STACKS
START:
    MOV AX, DATAS
    MOV DS, AX
    CALL INPUT             ; 调用输入过程
    MOV AX, BX             ; 将输入的数字放入AX中（AX = n）
    CALL FIBONACCI         ; 调用斐波那契函数，计算第n项
    MOV AX, BX             ; 结果在BX中
    CALL OUTPUT            ; 调用输出过程，输出斐波那契结果
    MOV DX, OFFSET NewLine ; 输出换行
    MOV AH, 09H            ; DOS功能：显示字符串
    INT 21H
    MOV AH, 4CH
    INT 21H                ; 结束程序

; 输入子程序
INPUT PROC
    ; 显示输入提示
    MOV DX, OFFSET Prompt
    MOV AH, 09H           ; DOS功能：显示字符串
    INT 21H               ; 显示提示

    XOR BX, BX            ; 清空BX以存储结果
    MOV CL, 10            ; 十进制基数
InputLoop:
    MOV AH, 01H           ; 准备读取字符
    INT 21H               ; 读取一个字符

    ; 检查字符是否为数字
    CMP AL, '0'
    JB InputEnd           ; 如果小于'0'，结束输入
    CMP AL, '9'
    JA InputEnd           ; 如果大于'9'，结束输入

    SUB AL, '0'           ; 将ASCII转换为整数
    MOV DL, AL            ; 当前数字存入DL
    MOV AX, BX            ; 将之前的结果移入AX
    MUL CL                ; 乘以10
    ADD AX, DX            ; 加上当前数字
    MOV BX, AX            ; 将结果存入BX
    JMP InputLoop         ; 继续输入
    

InputEnd:
    RET
INPUT ENDP

; 输出子程序
OUTPUT PROC
    MOV CX, 10            ; 十进制基数
    XOR BX, BX            ; 清空BX以计数位数

PrintLoop:
    XOR DX, DX            ; 清空DX用于除法
    DIV CX                ; AX / 10 -> 商在AX中，余数在DX中
    PUSH DX               ; 将余数（数字）压入栈
    INC BX                ; 位数计数加1
    TEST AX, AX           ; 检查商是否为零
    JNZ PrintLoop         ; 如果不为零，继续

PrintDigits:
    POP DX                ; 从栈中取出数字
    ADD DL, '0'           ; 转换为ASCII字符
    MOV AH, 02H           ; 准备显示一个字符
    INT 21H               ; 输出字符
    DEC BX                ; 位数计数减1
    JNZ PrintDigits       ; 打印剩余的数字

    RET 
OUTPUT ENDP

; 斐波那契递归函数
FIBONACCI PROC
    ; 输入: n 存在 AX 中
    ; 输出: 第 n 项的斐波那契数在 BX 中

    CMP AX, 0
    JE FIB_ZERO           ; 如果 n == 0，返回 0
    CMP AX, 1
    JE FIB_ONE            ; 如果 n == 1，返回 1

    ; 递归计算 F(n-1) + F(n-2)
    PUSH AX               ; 保存当前的 n 值
    DEC AX                ; 计算 F(n-1)
    CALL FIBONACCI        ; 递归调用计算 F(n-1)
    MOV CX, BX            ; 将 F(n-1) 的结果存入 CX

    ;POP AX                
    DEC AX                ; 减1得到 F(n-2)
    PUSH CX               ; 将 F(n-1) 的值保存在栈中
    CALL FIBONACCI        ; 递归调用计算 F(n-2)

    POP CX                ; 取出栈中的 F(n-1)
    ADD BX, CX            ; F(n) = F(n-1) + F(n-2)
    POP AX                  ; 恢复 n 的值
    RET

FIB_ZERO:
    MOV BX, 0             ; 返回 0
    RET

FIB_ONE:
    MOV BX, 1             ; 返回 1
    RET
FIBONACCI ENDP





CODES ENDS
END START
