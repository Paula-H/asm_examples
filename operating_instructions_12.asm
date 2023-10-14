bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 db 'a', 'b', 'c', 'd', 'e', 'f';primul sir care are 6 elemente ASCII
    ls1 equ ($-s1);lungimea primului sir
    s2 db '1', '2', '3', '4', '5';al doilea sir care are 5 elemente ASCII
    ls2 equ ($-s2);lungimea celui de-al doilea sir 
    d resb (ls1+ls2)/2; rezervam in memorie media aritmetica a lungimilor celor doua siruri pentru noul sir d

; our code starts here
segment code use32 class=code
    start:
        mov ecx, ls2
        mov esi, 0
        mov edi, 0
        mov ax, 0; lucrez cu AX pentru a pastra contorul esi intact
        repeta_pentru_sir_2:
            ;punem in eax valoarea contorului, tinand cont ca acesta incepe de la 0
            add ax, 1; adunam 1 la contor ca sa vedem valoarea "reala", in timp ce esti ramane valoarea decrementata
            mov dx,ax; facem o copie a indexului "real" pentru a-l utiliza mai tarziu
            mov bl, 2; mutam in registrul BL valoarea 2 pentru a pregati parametrii pentru impartire
            div bl;in AH va fi restul impartirii indexului la 2
            cmp ah, 0; comparam AH cu 0(vedem daca numarul este par)
            jne indexul_este_impar 
            mov al,  byte[s2+esi]; mutam in AL valoarea byte-ului curent din sirul 2
            mov byte[d+edi], al; mutam valoarea registrului AL in memorie, in zona rezervata pentru sirul d
            inc edi; incrementam EDI, contorul pentru sirul d
            indexul_este_impar:
                inc esi; incrementam ESI, contorul pentru sirul 2
                mov ax,dx  ; mutam valoarea din DX in AX pentru a avea valoarea initiala a indexului "real", inainte de impartire 
        loop repeta_pentru_sir_2
        ;pentru sirul 1 se pastreaza aceeasi metoda, doar ca nu initializam EDI cu 0, deoarece doresc ca procesul de implementare a sirului sa ramana
        ;la stadiul lui curent
        mov ecx, ls1
        mov esi,0
        mov ax,0
        repeta_pentru_sir_1:
            add ax,1
            mov dx,ax
            mov bl, 2
            div bl;restul va fi in ah
            cmp ah, 1;acum, comparam AH cu 1(vedem daca indexul "real" este impar)
            jne indexul_este_par
            mov al, byte[s1+esi]
            mov byte[d+edi], al
            inc edi
            indexul_este_par:
                inc esi
                mov ax,dx
        loop repeta_pentru_sir_1
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

        
