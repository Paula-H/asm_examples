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
    b db 1
    c db 10
    d db 12

; our code starts here
segment code use32 class=code
    start:
        mov al, [d];punem valoarea d in AL ~ AL=d
        add al, 10;adunam 10 la AL ~ AL= AL+10 = d+10 =1 0+d
        mov ah,0;convertim AL in AX 
        mov BX,AX;mutam valoarea curenta a lui AX in BX ~ BX= AX = 10+d
        mov al, [a];inseram in registrul AL valoarea lui a ~ AL= a
        mul byte[a];inmultim valoarea din registrul AL cu a ~ AL= AL*a = a*a
        mov cx,ax;mutam valoarea curenta a registrului AX in CX ~ CX= AX = a*a
        mov al,2; inseram in registrul AL valoarea 2 ~ AL= 2
        mov ah, [b]; inseram in registrul AH valoarea lui b ~ AL= b
        mul ah; inmultim valoarea din registrul AL cu cea din registrul AH ~ AX= AL*AH =2*b
        sub cx,ax;scadem din CX valoarea registrului AX ~ CX= CX-AX= (a*a)-(2*b)
        sub bx,cx; scadem din BX valoarea registrului CX ~ BX = BX-CX = (10+d)-[(a*a)-(2*b)]
        mov ax,bx; mutam in AX valoarea curenta a registrului BX ~ AX= BX = (10+d)-[(a*a)-(2*b)]
        div byte[c]; impartim valoarea curenta a registrului AX la valoarea lui c ~ AL = AX/c & AH= AX%c
        
     
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
