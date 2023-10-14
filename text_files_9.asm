bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose,fread,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "fisier.txt",0
    mod_acces db "r",0
    descriptor_fis dd -1
    len equ 100
    sir_sursa times len db 0
    l_sir_sursa equ $-sir_sursa
    sir_caractere_speciale db "~!@#$%^&*?><"
    l_sir_caractere equ $-sir_caractere_speciale
    frecventa_caracter times l_sir_caractere db 0
    format db "Cel mai intalnit caracter special este %c,cu frecventa %d.",0
; our code starts here
segment code use32 class=code
    start:
        ;start
        
        push dword mod_acces     
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        mov [descriptor_fis], eax
         
        cmp eax, 0
        je final
        
        push dword [descriptor_fis]
        push dword len
        push dword 1
        push dword sir_sursa        
        call [fread]
        add esp, 4*4
        
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4*1
        
        final:
        ;comparam fiecare element din sirul sursa cu cel din sirul de caractere speciale
        mov ecx,l_sir_sursa
        mov esi,0
        cauta_element_special:
            mov al,byte[sir_sursa+esi];punem in acumulator un element din sir_sursa
            mov ebx,esi;salvam valoarea lui esi cand parcurge sirul sursa
            mov edx,ecx;salvam valoarea contorului in sirul sursa
            mov esi,0
            mov ecx, l_sir_caractere
            cauta_in_sir:
                mov ah,byte[sir_caractere_speciale+esi]
                cmp al,ah
                jne el_diferit
                mov ah,byte[frecventa_caracter+esi]
                add ah,1
                mov byte[frecventa_caracter+esi],ah
                el_diferit:
                inc esi
               loop cauta_in_sir
            mov esi,ebx
            inc esi
            mov ecx,edx
        loop cauta_element_special
        mov al,0
        mov ecx, l_sir_caractere
        mov esi,0
        mov edx,0
        cauta_cea_mai_mare_frecventa:
            mov ah, byte[frecventa_caracter+esi]
            cmp ah,al
            jbe nu_e_cel_mai_mare
            mov al,ah
            mov dl,ah;aici pun frecventa
            mov ah,byte[sir_caractere_speciale+esi]
            mov dh,ah;aici pun caracterul in sine
            nu_e_cel_mai_mare:
            inc esi
        loop cauta_cea_mai_mare_frecventa
        
        mov bl,dl
        mov bh,dh
        mov edx,0
        mov dl,bh
        mov ecx,0
        mov cl,bl
        
        push ecx
        push edx
        push dword format
        call [printf]
        add esp, 4*3
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
