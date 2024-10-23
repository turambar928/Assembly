DATA SEGMENT
    RES DB 3 DUP(0)                         ; Ԥ���ռ�
    PR  DB 00H, '*', 00H, '=', 2 DUP(2), ' ', '$'  ; �����ʽ��
    LINE DB 0DH, 0AH, '$'                   ; ���з�
    IPP  DW 0000H                           ; ���������ص�ַ
    TABLE_LABEL DB 'the 9 mul 9 table:', 0DH, 0AH, '$' ; ��ͷ��Ϣ
DATA ENDS

STACK SEGMENT
    DB 20 DUP(0)                            ; ��ջ��
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

START:
    MOV AX, DATA                            ; ��ʼ�����ݶ�
    MOV DS, AX

    CALL PRINT_TABLE_LABEL                  ; ���ù��̴�ӡ��ͷ

    MOV CX, 0009H                           ; ��ѭ������Ϊ9

    ; ��ѭ��
L1: 
    MOV DH, CL                              ; ��ǰ�кž����������
    MOV DL, 01H                             ; ��ѭ����1��ʼ

    ; ��ѭ��
L2: 
    CMP DL, DH                              ; �Ƚϵ�ǰ�к������
    JA NEXT                                 ; �����ǰ�д����кţ�������һ��

    PUSH DX                                 ; ��������
    PUSH CX                                 ; ��������
    XOR AX, AX                              ; ��� AX��ȷ�� AH Ϊ 0
    MOV AL, DH                              ; ����ǰ�кŴ��� AL ��Ϊ������
    PUSH AX                                 ; ���汻����
    PUSH DX                                 ; �������

    MOV AL, DH                              ; ����������ǰ�кţ�
    MUL DL                                  ; �˷����㣨�кų����кţ�

    PUSH AX                                 ; ����˷����
    CALL NUM                                ; ������ʾ�ӳ���

    POP CX                                  ; �ָ�����
    POP DX                                  ; �ָ�����
    INC DL                                  ; ������1
    JMP L2                                  ; ������ѭ��

NEXT:
    MOV DX, OFFSET LINE                     ; ������з�
    MOV AH, 09H
    INT 21H                                 ; DOS ����ж�

    LOOP L1                                 ; ��ѭ����������
    MOV AH, 4CH                             ; ��������
    INT 21H

; �ӳ��򣺴�ӡ�˷���ͷ
PRINT_TABLE_LABEL PROC
    MOV DX, OFFSET TABLE_LABEL              ; ָ���ͷ�ı�
    MOV AH, 09H
    INT 21H                                 ; DOS ����ж�
    RET
PRINT_TABLE_LABEL ENDP

; ��ʾ�˷�������ӳ���
NUM PROC
    POP IPP                                 ; ��������ַ
    POP DX                                  ; ���
    MOV AX, DX
    MOV BL, 0AH
    DIV BL                                  ; ת��Ϊʮ�����ַ�

    ADD AX, 3030H
    MOV PR+4, AL                            ; �������ĸ�λ
    MOV PR+5, AH                            ; ��������ʮλ

    POP AX                                  ; �ָ�����
    AND AL, 0FH
    ADD AL, 30H
    MOV PR+2, AL                            ; �������

    POP AX                                  ; �ָ�������
    AND AL, 0FH
    ADD AL, 30H
    MOV PR, AL                              ; ���汻����

    ; ����˷����
    MOV DX, OFFSET PR
    MOV AH, 09H
    INT 21H                                 ; DOS ����ж�

    PUSH IPP
    RET
NUM ENDP

CODE ENDS
END START
