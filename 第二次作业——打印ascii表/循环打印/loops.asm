;loop循环打印
DATASEG SEGMENT
    NEWLINE DB 0DH, 0AH, '$'   ; 回车换行符
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG
MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX

    MOV CX, 2                 ; 外层循环，控制打印两行
    MOV AL, 'a'               ; 'a'的ASCII码

OUTER_LOOP:
    PUSH CX                   ; 保存外层循环的计数器

    MOV CX, 13                ; 内层循环，控制每行打印 13 个字母

PRINT_LOOP:
    MOV AH, 02H               ; DOS 21H 功能2，用于输出字符
    MOV DL, AL                
    INT 21H                  

    INC AL                    ; 输出下一个字母
    LOOP PRINT_LOOP           ; 内层循环

    LEA DX, NEWLINE           ; 打印换行
    MOV AH, 09H
    INT 21H

    POP CX                    ; 恢复外层循环计数器
    LOOP OUTER_LOOP           ; 外层循环

    MOV AX, 4C00H            ; 正常结束程序
    INT 21H
MAIN ENDP
CODESEG ENDS
END MAIN
