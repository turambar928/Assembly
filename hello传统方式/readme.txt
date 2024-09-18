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

运行截图2反汇编分析
0721:0000 B80770
指令: MOV AX,0770
解释: 将数值 0770 装入 AX 寄存器，通常是为了设置数据段的段地址。

0721:0003 8ED8
指令: MOV DS,AX
解释: 将 AX 中的数据段地址（0770）装入数据段寄存器 DS，使程序可以访问正确的数据段。

0721:0005 B409
指令: MOV AH,09
解释: 将 09 装入 AH，这是 DOS 中断 21h 的功能号，用于显示字符串。

0721:0007 BA0000
指令: MOV DX,0000
解释: 将字符串地址 0000 装入 DX，DX 寄存器指向要显示的字符串在内存中的偏移地址。

0721:000A CD21
指令: INT 21
解释: 调用 DOS 中断 21h，显示 DX 指向的字符串。

0721:000C B8004C
指令: MOV AX,4C00
解释: 将 4C00h 装入 AX，这是 DOS 的程序退出功能号，4Ch 终止程序，00 表示正常结束。

0721:000F CD21
指令: INT 21
解释: 调用 DOS 中断 21h，终止程序并返回控制权给操作系统。

36 SS:
FA CLI: 禁用中断
PUSH 和 CALL: 这些指令是系统或编译器的自动添加，用于程序的进一步调度或者退出后的处理。
