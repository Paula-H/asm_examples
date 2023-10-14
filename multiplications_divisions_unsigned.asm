bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2 
    b db 65
    c db 4
    e dd 554
    x dq 345

; our code starts here
segment code use32 class=code
    start:
        ;a/2+b*b-a*b*c+e+x
        mov al, [a] ;mutam in registrul AL valoarea lui a(byte), AL=a
        mov ah, 0 ;extindem AL in AX, AX=a
        mov bl, 2 ;punem in BL valoarea 2, BL=2
        div bl ;impartim AX la BL, catul fiind in AL si restul in AH, AL=AX/BL=a/2 si AH=AX%BL=a%2
        mov bl, al ;mutam catul din AL in BL, BL=a/2
        mov bh, 0 ;extindem BL in BX, completand partea high, BX=a/2
        mov al, [b] ;mutam valoarea lui b(byte) in AL, AL=b
        mov cl, [b] ;mutam valoarea lui b si in CL, CL=b
        mul cl ;inmultim registrul AL cu registrul CL, rezultatul fiind in AX, AX=AL*CL=b*b
        add bx,ax ; adunam BX(a/2) si AX(b*b), BX=BX+AX=a/2+b*b
        mov al,[a] ;mutam valoarea lui a(byte) in AL, AL=a
        mov cl, [b] ;mutam in CL valoarea lui b(byte), CL=b 
        mul cl ;inmultim AL si CL, rezultatul fiind in AX, AX=AL*CL=a*b 
        mov cl, [c] ;mutam valoarea lui c(byte) in CL, CL=c 
        mov ch, 0 ;convertim fara semn regisgtrul CL in CX, CX=c 
        mul cx ;inmultim AX cu CX, rezultatul final aflandu-se in perechea DX:AX, DX:AX=AX*CX=a*b*c 
        mov cx, 0 ;punem 0 in cx ca sa formam doubleword-ul CX:BX
        sub bx, ax ;scadem partile low ale celor 2 doublewords
        sbb cx, dx ;scadem cu "borrow" partile high, CX:BX=CX:BX-DX:AX=(a/2+b*b)-a*b*c
        add bx, [e] ;adunam la partea low a perechii CX:BX partea low a doubleword-ul e
        adc cx, [e+2] ;adunam cu "carry" la partea high a perechii CX:BX partea high a doubleword-ul e
        push cx
        push bx
        pop ebx ;folosim stiva pentru a transforma CX:DX in EBX
        mov ecx, 0; punem in registrul ECX 0 pentru a forma perechea ECX:EBX, ECX:EBX=a/2+b*b-a*b*c+e
        add ebx, [x] ;adunam la partea low a perechii ECX:EBX partea low a quadword-ul x
        adc ecx, [x+4] ;adunam cu "carry" la partea high a perechii ECX:EBX partea high a quadword-ul x, ECX:EBX=a/2+b*b-a*b*c+e+x
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
