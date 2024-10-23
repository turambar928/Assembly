.MODEL SMALL
.STACK 100h

.DATA  
    ; 错误的乘法表数据
    t1 db 7,2,3,4,5,6,7,8,9
       db 2,4,7,8,10,12,14,16,18
       db 3,6,9,12,15,18,21,24,27
       db 4,8,12,16,7,24,28,32,36
       db 5,10,15,20,25,30,35,40,45
       db 6,12,18,24,30,7,42,48,54
       db 7,14,21,28,35,42,49,56,63
       db 8,16,24,32,40,48,56,7,72
       db 9,18,27,36,45,54,63,72,81

    ; 正确的乘法表数据
    correct db 1,2,3,4,5,6,7,8,9
            db 2,4,6,8,10,12,14,16,18
            db 3,6,9,12,15,18,21,24,27
            db 4,8,12,16,20,24,28,32,36
            db 5,10,15,20,25,30,35,40,45
            db 6,12,18,24,30,36,42,48,54
            db 7,14,21,28,35,42,49,56,63
            db 8,16,24,32,40,48,56,64,72
            db 9,18,27,36,45,54,63,72,81

    spc db "  ", '$'
    errMsg db "  error", 0DH, 0AH, '$'
    accMsg db "accomplished", 0DH, 0AH, '$'
    newl db 0DH, 0AH, '$'

.CODE
MAIN:
    MOV    AX, @DATA
    MOV    DS, AX

    ; 打印 "x  y"

    MOV    DL, 'x'
    MOV    AH, 02H
    INT    21H
    LEA    DX, spc
    MOV    AH, 09H
    INT    21H
    MOV    DL, 'y'
    MOV    AH, 02H
    INT    21H
    LEA    DX, newl
    MOV    AH, 09H
    INT    21H

    ; 外循环计数器
    MOV    CX, 9
    MOV    AX, 1        ; 初始化 AX 为 1，表示从第 1 行开始
    MOV    SI, 0
    ;MOV    DI, 0  ; DI 用于遍历正确的乘法表

OUTER_LOOP:
    PUSH   CX
    MOV    BX, 1        ; 列号从 1 开始
    MOV    CX, 9

INNER_LOOP:
    MOV    DL, correct[SI]   ; 取正确的乘法表数据
    MOV    DH, t1[SI]        ; 取错误的乘法表数据
    CMP    DL, DH            ; 比较正确和错误的数据
    JNE    PRINT_ERR         ; 如果数据不相等，跳转到错误处理
    JMP    NEXT_STEP

PRINT_ERR:
; 保存 AX 的值到一个寄存器（如 BX），防止修改 AL 影响 AX
    PUSH    AX
    ; 输出 x 坐标 (行号, AX 寄存器)
    MOV    AL, AL              ; 将 AX 的低字节 (AL) 设置为行号
    ADD    AL, 30H             ; 将行号转换为 ASCII
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H

    ; 显示空格
    LEA    DX, spc
    MOV    AH, 09H
    INT    21H

    ; 输出 y 坐标 (列号, BX 寄存器)
    MOV    AL, BL              ; 将列号保存到 AL
    ADD    AL, 30H             ; 将列号转换为 ASCII
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H

    ; 显示错误提示
    LEA    DX, errMsg
    MOV    AH, 09H
    INT    21H

    POP     AX

NEXT_STEP:
    INC    BX               ; 增加列号
    INC    SI               ; 移动到下一个错误表数据
    ;INC    DI               ; 移动到下一个正确表数据
    LOOP   INNER_LOOP
    POP    CX
    INC    AX               ; 增加行号
    LOOP   OUTER_LOOP

    ; 打印完成提示信息
    LEA    DX, accMsg
    MOV    AH, 09H
    INT    21H

    MOV    AH, 4CH         ; 程序正常结束
    INT    21H

END MAIN
