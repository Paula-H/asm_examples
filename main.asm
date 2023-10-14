bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit
extern gets, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import gets msvcrt.dll
import printf msvcrt.dll
extern calculcifrasutelor       ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db "%d",0
    sir db 0
    sir_nou db 0

; our code starts here
segment code use32 class=code
    start:
        push dword sir
        call[gets]
        add esp, 4
        
        mov esi, sir+1
        mov edi, sir+1
        mov eax,0
        mov al, [sir]
        sub al, 30h
        mov cl, 2
        mul cl
        mov byte[sir],al
        mov ecx, eax
        repeta:
            lodsb
            cmp al,20h
            jne nr_diferit_de_spatiu
            mov al,0
            jmp final
            nr_diferit_de_spatiu:
            sub al, 30h
            final:
            stosb
        loop repeta
        
        mov esi,sir+1
        mov ecx,0
        mov cl, [sir]
        mov edi,sir+1
        calcul:
            lodsw
            push ax
            call calculcifrasutelor
            stosw
            inc esi
        loop calcul
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
