hello代码分析：
1. 段声明
STKSEG SEGMENT STACK: 定义了一个堆栈段，声明了32个字的空间 DW 32 DUP(0)，即堆栈区初始化为32个双字全为0。
DATASEG SEGMENT: 定义了一个数据段，包含一条消息 MSG DB "Hello Assembly$"，其中 $ 是字符串结束符，DOS中断会读取到这个符号停止显示。
CODESEG SEGMENT: 定义了代码段，其中包含程序的主逻辑。
2. ASSUME 指令
ASSUME CS:CODESEG, DS:DATASEG: 告诉汇编器 CS 寄存器将指向代码段 CODESEG，DS 寄存器将指向数据段 DATASEG。这使得段寄存器的设置更加明确。
3. 主程序 MAIN
MOV AX,DATASEG 和 MOV DS,AX: 将数据段 DATASEG 的段地址加载到 AX 寄存器中，然后将 AX 的值传递给 DS，这样程序可以正确访问 DATASEG 段中的数据。
MOV AH,9 和 MOV DX,OFFSET MSG: 设置 AH 为9，表明调用DOS中断 INT 21H 来显示字符串。同时将 MSG 的偏移地址放入 DX，表示要显示的数据的起始地址。
INT 21H: 执行DOS中断服务，将 DX 指向的字符串输出到屏幕。
MOV AX,4C00H 和 INT 21H: 这两条指令用于正常终止程序。AX 设置为 4C00H 是DOS的结束程序命令，通过 INT 21H 执行程序终止。