bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 3
    b dw 78
    c dd 3543
    d dq 2435

; our code starts here
segment code use32 class=code
    start:
        ;(d+c) - (c+b) - (b+a)
        mov eax, [c];punem intr-un registru de 4 octeti valoarea lui c, c=>EAX
        mov edx, 0; convertim in quadword EAX, astfel c => EDX:EAX
        mov ebx, [d]; punem in EBX partea "low" a quadword-ului d, d=> ?:EBX
        mov ecx, [d+4]; punem in ECX partea "high" a quadword-ului d, d=> ECX:EBX
        add ebx, eax; adunam partea low a celor 2 quadwords d si c, EBX=EBX+EAX
        adc ecx, edx; adunam cu carry partea high a celor 2 quadwords d si c, ECX=ECX+EDX+C
        mov ax, [c]; punem in AX partea low a doubleword-ului c 
        mov dx, [c+2];punem in DX partea high a doubleword-ului c, c=>DX:AX
        add ax, word[b]; adunam in partea low a lui c pe b, stiind ca este word, AX= low c + b
        adc dx, 0; adunam 0 si eventualul Carry in partea high a lui c, stiind ca b este word, DX=DX+0+C
        push dx
        push ax
        pop eax; folosim stiva ca sa transformam DX:AX in EAX
        mov edx, 0; acum (c+b)=> EDX:EAX
        sub ebx, eax; scadem din partea low a (d+c) partea low a (c+b)
        sbb ecx, edx; scadem din partea high a (d+c) partea high a (c+b)
        mov al, [a];punem in AL valoarea lui a
        mov ah, 0;convertim in word
        mov dx, [b]; punem in DX valoarea lui b
        add ax, dx; adunam a si b, rezultatul aflandu-se in AX, AX=AX+DX=b+a
        mov dx, 0; pregatim DX pentru conversia word to doubleword 
        push dx
        push ax
        pop eax; folosim stiva ca sa transformam DX:AX in EAX
        mov edx, 0; extindem EAX in quadword-ul EDX:EAX
        sub ebx, eax;scadem partea low a (a+b) din ((d+c)-(c+b))
        sbb ecx, edx;scadem partea low a (a+b) din ((d+c)-(c+b))
    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
