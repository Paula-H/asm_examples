bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;avem 3 siruri definite pe byte, s1,s2, d
    s1 db 1, 3, 6, 2, 3, 7
    ls equ $-s1
    s2 db 6, 3, 8, 1, 2, 5
    ;it is a given ca sirurile s1 si s2 au aceeasi lungime
    d resb ls 

; our code starts here
segment code use32 class=code
    start:
        mov ecx, ls
        mov esi, 0;contorul pentru sirurile s1 si s2 
        mov edi, 0; contorul pentru sirul d care urmeaza sa fie format
        repeta:
            mov al, byte[s1+esi]
            mov ah, byte[s2+esi]
            cmp al,ah
            jbe s1_este_mai_mare
            ;daca s1[contor] nu este mai mare, atunci fac urmatoarea chestie:
            mov byte[d+edi],ah;punem valoarea din AH in sirul d
            inc esi;incrementam esi, deplasamentul pentru ambele siruri
            inc edi;incrementam edi, deplasamentul pentru sirul d
            jmp ending
            ;nu doresc ca sirul d sa mai treaca prin vreo interventie, asa ca folosesc functia JMP
            ;daca s1[esi] este mai mare decat s2[esi], trecem prin eticheta s1_este_mai_mare 
            s1_este_mai_mare:
                mov byte[d+edi], al;punem valoarea din AL in sirul d
                inc esi
                inc edi
            ending:
        loop repeta 
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
