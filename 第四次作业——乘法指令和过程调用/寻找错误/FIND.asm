.MODEL SMALL
.STACK 100h

.DATA  
    ; ����ĳ˷�������
    t1 db 7,2,3,4,5,6,7,8,9
       db 2,4,7,8,10,12,14,16,18
       db 3,6,9,12,15,18,21,24,27
       db 4,8,12,16,7,24,28,32,36
       db 5,10,15,20,25,30,35,40,45
       db 6,12,18,24,30,7,42,48,54
       db 7,14,21,28,35,42,49,56,63
       db 8,16,24,32,40,48,56,7,72
       db 9,18,27,36,45,54,63,72,81

    ; ��ȷ�ĳ˷�������
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

    ; ��ӡ "x  y"

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

    ; ��ѭ��������
    MOV    CX, 9
    MOV    AX, 1        ; ��ʼ�� AX Ϊ 1����ʾ�ӵ� 1 �п�ʼ
    MOV    SI, 0
    ;MOV    DI, 0  ; DI ���ڱ�����ȷ�ĳ˷���

OUTER_LOOP:
    PUSH   CX
    MOV    BX, 1        ; �кŴ� 1 ��ʼ
    MOV    CX, 9

INNER_LOOP:
    MOV    DL, correct[SI]   ; ȡ��ȷ�ĳ˷�������
    MOV    DH, t1[SI]        ; ȡ����ĳ˷�������
    CMP    DL, DH            ; �Ƚ���ȷ�ʹ��������
    JNE    PRINT_ERR         ; ������ݲ���ȣ���ת��������
    JMP    NEXT_STEP

PRINT_ERR:
; ���� AX ��ֵ��һ���Ĵ������� BX������ֹ�޸� AL Ӱ�� AX
    PUSH    AX
    ; ��� x ���� (�к�, AX �Ĵ���)
    MOV    AL, AL              ; �� AX �ĵ��ֽ� (AL) ����Ϊ�к�
    ADD    AL, 30H             ; ���к�ת��Ϊ ASCII
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H

    ; ��ʾ�ո�
    LEA    DX, spc
    MOV    AH, 09H
    INT    21H

    ; ��� y ���� (�к�, BX �Ĵ���)
    MOV    AL, BL              ; ���кű��浽 AL
    ADD    AL, 30H             ; ���к�ת��Ϊ ASCII
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H

    ; ��ʾ������ʾ
    LEA    DX, errMsg
    MOV    AH, 09H
    INT    21H

    POP     AX

NEXT_STEP:
    INC    BX               ; �����к�
    INC    SI               ; �ƶ�����һ�����������
    ;INC    DI               ; �ƶ�����һ����ȷ������
    LOOP   INNER_LOOP
    POP    CX
    INC    AX               ; �����к�
    LOOP   OUTER_LOOP

    ; ��ӡ�����ʾ��Ϣ
    LEA    DX, accMsg
    MOV    AH, 09H
    INT    21H

    MOV    AH, 4CH         ; ������������
    INT    21H

END MAIN
