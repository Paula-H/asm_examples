bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 2
    b dw 20
    c dw 10
    

; our code starts here
segment code use32 class=code
    start:
        mov ax, [b];punem valoarea lui b in registrul AX, AX=b
        mov bx, [c];punem valoarea lui c in registrul BX, BX=c
        sub ax,bx; scadem valoarea BX din AX, AX=AX-BX=b-c
        mov bx, [a];punem in registrul BX valoarea lui a, BX=a
        add ax,bx; adunam registrului AX valoarea din registrul BX, AX=AX+BX=a+(b-c)
        mov bx, 3; mutam constanta 3 in registrul BX, BX=3
        mul bx; inmultim AX cu BX, rezultatul aflandu-se in DX:AX, AX=AX*BX=(a+(b-c))*3
     
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
