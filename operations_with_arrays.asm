bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    input db 2,4,6,8,10,12,14
    l_input equ $-input
    output resb l_input
    src db 1,3,5,10,8, 1,9
    dst db 2,4,6,11,9, 2,8
    N equ $-dst
    

; our code starts here
segment code use32 class=code
    start:
        mov esi, input
        mov ecx, l_input
        mov edi, output
        repeta_pentru_sir_input:
            lodsb;am pus in AL byte-ul curent din INPUT
            ;stosb
            mov ebx,ecx;stocam in EBX indexul curent la care se afla ECX in sirul input
            mov ecx,N;punem in ECX valoarea N pentru a-l pregati de contorizarea sirurilor src&dst
            mov edx,esi;mutam in EDX elementul curent din sirul input
            mov esi,0;in esi punem 0 pentru a-l pregati de loop
            scaneaza_pentru_elemente_asemanatoare:
                mov ah, byte[src+esi];mutam in AH elementul src+esi
                cmp al,ah;comparam AL si AH
                jne byte_din_input_inegal_cu_byte_din_src;daca cele 2 nu sunt egale, NU stocam acumulatorul in EDI
                ;daca cele doua sunt totusi egale:
                mov ebp,1;imi creez propriul Flag care imi va spune daca s-a stocat ceva in byte-ul curent din OUTPUT
                mov ah,al;copiem valoarea curenta din INPUT intr-un registru auxiliar
                mov al, byte[dst+esi];in acumulator mutam elementul dst+esi(elementul din dst cu acelasi index al elementului din src comparat)
                stosb
                mov al,ah;readucem in acumulator valoarea potrivita
                byte_din_input_inegal_cu_byte_din_src:
                inc esi;incrementam ESI pentru loop-ul scaneaza_pentru_elemente_asemanatoare 
            loop scaneaza_pentru_elemente_asemanatoare
            cmp ebp,1;comparam cu 1 Flagul creat de noi
            je in_byte_output_e_ce_trebuie;daca Flagul este 1, in byte-ul curent aratat de EDI este deja ceva, deci nu mai trebuie pus nimic
            stosb;daca Flagul este diferit de 1, inseamna ca byte-ul curent aratat de EDI este neocupat,asa ca punem valoarea din AL
            in_byte_output_e_ce_trebuie:
            mov ebp,0;schimbam valoarea pseudo-Flagului pentru a-l initializa pentru urmatorul ESI din INPUT
            mov ecx, ebx
            mov esi,edx    
        loop repeta_pentru_sir_input
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
