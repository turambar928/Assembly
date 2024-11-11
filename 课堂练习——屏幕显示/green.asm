assume cs:code

data segment
    db 'Tongji University!' ; �ַ���
    db 00000010b          ; ���� (ǰ����ɫ��������ɫ) 
    db 11,12,13,64       
data ends

stack segment
    dw 8 dup (0)         ; ջ�ռ�
stack ends

code segment
start:
    ; ��ʼ�����ݶκ�ջ��
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 16

    ; ��������
    jmp cls

; ��������
cls:
    mov bx, 0b800h        ; �Դ��ַ 0xb800
    mov es, bx            ; �� ES �Ĵ���ָ���Դ�
    mov bx, 0             ; ��ʼ�� BX �Ĵ���Ϊ 0
    mov cx, 4000          ; 4000 �ֽڣ���ʾ 25 �� * 80 �ַ� * 2 �ֽڣ��ַ� + ���ԣ�
clear_screen:
    mov dl, 0             ; �� NULL �ַ� (ASCII 0) �����λ
    mov dh, 0             ; ����ɫ��Ϊ��ɫ��������ɫǰ��ɫ��0x02��
    mov es:[bx], dx       ; ���ַ�����ɫд���Դ�
    add bx, 2             ; ÿ�β��� 2 �ֽڣ��ַ� + ���ԣ�
    loop clear_screen     ; ѭ��ֱ��������� 4000 �ֽ�

    ; ��ӡ�ַ���
    mov cx, 3             ; ��ӡ 3 ��
row:
    ; ����ÿ�е���ʼλ�ú���ɫ
    mov dx, cx
    mov si, 3
    sub si, cx
    mov ch, 0
    mov cl, 19[si]        ; ÿ���ַ�������ɫ
    mov bp, 0             ; �ַ�����ʼλ��

    ; ѭ����ӡÿ��
col:
    add bp, 1920          
    mov ah, 0
    mov al, ds:[22]     
    add bp, ax            
    mov si, 3
    sub si, dx
    mov ah, 16[si]
    mov bx, 0
    mov cx, 18            ; ��ӡÿ�е� 16 ���ַ�
fill:
    mov al, [bx]          ; ��ȡ�ַ�
    push ds
    mov si, 0b800h        ; �����Դ��ַ
    mov ds, si
    mov ds:[bp], ax       ; ���ַ�������д���Դ�
    pop ds
    inc bx
    add bp, 2             ; �ƶ�����һ���ַ�λ��
    loop fill

    mov cx, dx
    loop row

    ; �����˳�
    mov ax, 4C00h
    int 21h

code ends
end start
