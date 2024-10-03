DATAS SEGMENT
    Prompt DB 'input number (1-100): $' ; 输入提示信息
DATAS ENDS
 
STACKS SEGMENT
STACKS ENDS
 
CODES SEGMENT
    ASSUME CS:CODES, DS:DATAS, SS:STACKS
START:
    MOV AX, DATAS
    MOV DS, AX
    CALL INPUT             ; 调用输入过程
    MOV AX, BX
    CALL OUTPUT            ; 调用输出过程
    MOV AH, 4CH
    INT 21H                ; 结束程序

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

OUTPUT PROC
    MOV CX, 10            ; 十进制基数
    XOR BX, BX            ; 清空BX以计数位数

PrintLoop:
    XOR DX, DX            ; 清空DX用于除法
    DIV CX                 ; AX / 10 -> 商在AX中，余数在DX中
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

CODES ENDS
END START
