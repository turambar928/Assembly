DATA SEGMENT
    RES DB 3 DUP(0)                         ; 预留空间
    PR  DB 00H, '*', 00H, '=', 2 DUP(2), ' ', '$'  ; 结果格式化
    LINE DB 0DH, 0AH, '$'                   ; 换行符
    IPP  DW 0000H                           ; 主函数返回地址
    TABLE_LABEL DB 'the 9 mul 9 table:', 0DH, 0AH, '$' ; 表头信息
DATA ENDS

STACK SEGMENT
    DB 20 DUP(0)                            ; 堆栈段
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

START:
    MOV AX, DATA                            ; 初始化数据段
    MOV DS, AX

    CALL PRINT_TABLE_LABEL                  ; 调用过程打印表头

    MOV CX, 0009H                           ; 行循环次数为9

    ; 行循环
L1: 
    MOV DH, CL                              ; 当前行号决定最大列数
    MOV DL, 01H                             ; 列循环从1开始

    ; 列循环
L2: 
    CMP DL, DH                              ; 比较当前列和最大列
    JA NEXT                                 ; 如果当前列大于行号，跳到下一行

    PUSH DX                                 ; 保存列数
    PUSH CX                                 ; 保存行数
    XOR AX, AX                              ; 清除 AX，确保 AH 为 0
    MOV AL, DH                              ; 将当前行号存入 AL 作为被乘数
    PUSH AX                                 ; 保存被乘数
    PUSH DX                                 ; 保存乘数

    MOV AL, DH                              ; 被乘数（当前行号）
    MUL DL                                  ; 乘法计算（行号乘以列号）

    PUSH AX                                 ; 保存乘法结果
    CALL NUM                                ; 调用显示子程序

    POP CX                                  ; 恢复行数
    POP DX                                  ; 恢复列数
    INC DL                                  ; 列数加1
    JMP L2                                  ; 继续列循环

NEXT:
    MOV DX, OFFSET LINE                     ; 输出换行符
    MOV AH, 09H
    INT 21H                                 ; DOS 输出中断

    LOOP L1                                 ; 行循环结束条件
    MOV AH, 4CH                             ; 结束程序
    INT 21H

; 子程序：打印乘法表头
PRINT_TABLE_LABEL PROC
    MOV DX, OFFSET TABLE_LABEL              ; 指向表头文本
    MOV AH, 09H
    INT 21H                                 ; DOS 输出中断
    RET
PRINT_TABLE_LABEL ENDP

; 显示乘法结果的子程序
NUM PROC
    POP IPP                                 ; 主函数地址
    POP DX                                  ; 结果
    MOV AX, DX
    MOV BL, 0AH
    DIV BL                                  ; 转换为十进制字符

    ADD AX, 3030H
    MOV PR+4, AL                            ; 保存结果的个位
    MOV PR+5, AH                            ; 保存结果的十位

    POP AX                                  ; 恢复乘数
    AND AL, 0FH
    ADD AL, 30H
    MOV PR+2, AL                            ; 保存乘数

    POP AX                                  ; 恢复被乘数
    AND AL, 0FH
    ADD AL, 30H
    MOV PR, AL                              ; 保存被乘数

    ; 输出乘法结果
    MOV DX, OFFSET PR
    MOV AH, 09H
    INT 21H                                 ; DOS 输出中断

    PUSH IPP
    RET
NUM ENDP

CODE ENDS
END START
