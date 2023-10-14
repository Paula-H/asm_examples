bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 500
    b dw 1500
    c dw 256
    d dw 371

; our code starts here
segment code use32 class=code
    start:
        
        mov ax, [b];AX=b
        sub ax, [a];AX=AX-a=b-a
        mov bx, [c];BX=c
        add bx, [c];BX=BX+c=c+c
        add bx, [d];BX=BX+d=c+c+d 
        sub ax,bx;AX-BX=(b-a)-(c+c+d)
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
