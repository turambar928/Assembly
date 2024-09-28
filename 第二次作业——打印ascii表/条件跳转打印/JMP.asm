;条件跳转打印
STKSEG SEGMENT STACK
DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    NEWLINE DB 0DH,0AH,'$'   ; 回车换行符
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR
    MOV AX,DATASEG
    MOV DS,AX

    MOV AL,97          ; 初始化 AL 为 'a'
    MOV BX,0           ; BX 用于跟踪每行打印的字符数
    MOV CX,0           ; CX 用于打印计数

PRINT_CHAR:
    CMP CX,25         
    JG DONE           

    MOV AH,2           ; DOS 21H 功能2，输出字符
    MOV DL,AL          
    INT 21H            

    INC AL             
    INC BX 
    INC CX            

    CMP BX,12          ; 检查是否已经打印了13个字符
    JLE PRINT_CHAR     ; 如果还不到13个字符，继续打印

    LEA DX,NEWLINE      ;打印换行
    MOV AH,09H
    INT 21H

    MOV BX,0            ; 重置 BX，准备打印下一行
    JMP PRINT_CHAR     ; 否则继续打印剩下的字符

DONE:                   ; 完成，退出程序
    MOV AX,4C00H
    INT 21H
MAIN ENDP
CODESEG ENDS
END MAIN