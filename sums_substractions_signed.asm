bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 123
    b dw -478
    c dd 3543
    d dq -2435

; our code starts here
segment code use32 class=code
    start:
        ;c+b-(a-d+b)
        mov AL,[a] ;punem valoarea lui a(byte) in AL, a=>AL
        cbw ;convertim cu semn AL in AX, a=>AX
        cwde ;convertim cu semn AX in EAX, a=>EAX
        cdq ;convertim cu semn EAX in EDX:EAX, a=> EDX:EAX
        sub EAX, [d] ;scadem din partea low a perechii EDX:EAX partea low a quadword-ului d, EAX=EAX-[d]
        sbb EDX, [d+4] ;scadem cu "borrow" din partea high a perechii EDX:EAX partea high a quadword-ului d, EDX=EDX-[d+4]-C
        mov ebx, eax ;mutam partea low a perechii EDX:EAX in EBX
        mov ecx, edx ;mutam partea high a perechii EDX:EAX in ECX, ECX:EBX=a-d
        mov ax, [b] ;mutam valoarea lui b(word) in registrul AX, b=>AX
        cwde ;convertim cu semn AX in EAX, b=>EAX
        cdq ;convertim cu semn EAX in EDX:EAX, b=> EDX:EAX
        add ebx, eax ;adunam partile low ale celor doi quadwords
        adc ecx, edx ;adunam cu "carry" partile high ale celor doi quadwords, ECX:EBX=(ECX+EDX+C):((EBX+EAX)=(a-d)+b=a-d+b 
        mov ax, [b]; mutam valoarea lui b(word) din nou in registrul AX, b=>AX
        cwde; convertim cu semn AX in EAX, b=>EAX
        add eax, dword[c] ;adunam registrului EAX doubleword-ul c, EAX=b+c
        cdq ;convertim cu semn registrul EAX in EDX:EAX, (b+c)=>EDX:EAX
        sub eax,ebx ;scadem partile low ale celor 2 noi quadwords
        sbb edx,ecx ;scadem cu "borrow" partile high ale celor 2 noi quadwords, EDX:EAX=(EDX-ECX-C):(EAX-EBX)=c+b-(a-d+b)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
