bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 1010101001110011b
    b dw 0101011101010010b
    c dw 1101010110111000b
    d db 0
    f db 0
segment code use32 class=code
    start:
        ;biţii de pe poziţiile 0-4 ai lui A
        mov ax, [a]; punem in AX valoarea lui a
        and ax,0000000000011111b;izolam bitii 0-4
        
        ;biţii de pe poziţiile 5-9 ai lui B
        mov bx, [b]; punem in BX valoarea lui b
        and bx, 0000001111100000b; izolam bitii 5-9 ai lui b
        mov cl, 5
        ror bx,cl; rotim spre dreapta BX cu 5 pozitii
        add al,bl; adunam partile low ale celor doi registri
        mov [d], al; mutam valoarea registrului AL in variabila din memorie
        
        ;Octetul E este numarul reprezentat de bitii 10-14 ai lui C. Sa se obtina octetul F ca rezultatul scaderii D-E.
         mov bx, [c]; mutam in BX valoarea lui c
         and bx, 0111110000000000b; 
         mov cl, 10
         ror bx,cl; rotim spre dreapta bitii lui BX cu 10 pozitii, practic in BL se afla octetul E
         sub al,bl; octetul f este scaderea dintre al si bl(putem lua partea low a registrului bx)
         mov [f], al
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
