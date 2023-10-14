bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 11010101011010101011101001110101b
    b dw 0111011101010111b
    c dw 0

; our code starts here
segment code use32 class=code
    start:
        ;bitii 0-4 ai lui C sunt invers fata de bitii 20-24 ai lui A
        mov bx, 0
        mov eax, [a]
        not eax 
        and eax, 00000001111100000000000000000000b
        mov cl, 20
        ror eax, cl; rotim cu 20 de pozitii la dreapta
        or bx, ax;intrucat in EAX este ocupata doar partea low(5 biti), putem folosi direct doar AX, punand rezultatul in BX
        
        ;bitii 5-8 ai lui C sunt 1
        or bx, 0000000111100000b; punem 1 in bitii 5-8 ai registrului BX
        
        ;bitii 9-12 ai lui C sunt identici cu bitii 12-15 ai lui B
        mov ax, [b];mutam in AX valoara lui b
        and ax, 1111000000000000b;izolam bitii 12-15 al lui b prin comanda AND
        mov cl, 3
        ror ax, cl; rotim AX cu 3 pozitii a.i. bitul cu index 12 sa ajunga bitul cu index 15
        or bx, ax; punem bitii 12-15 ai lui b(din AX) in BX
        
        ;bitii 13-15 ai lui C sunt bitii 7-9 ai lui A
        mov eax, [a];mutam in EAX valoarea lui a 
        and eax, 00000000000000000000001110000000b
        mov cl, 6
        rol eax, cl;rotim EAX spre stanga cu 6 pozitii
        or bx, ax; foloim doar partea low a lui EAX, astfel intruducand bitii necesari in rezultat
        
        mov [c], bx;punem rezultatul din registrul BX in variabila din memorie c
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
