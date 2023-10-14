bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf,printf            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0
    b dd 0
    format db "%d",0
    k equ 2
    mesaj_caz_1 db "Produsul (a+b)*k este %x.",0
    mesaj_caz_2 db "Produsul (a+b)*k este %x%x.",0

; our code starts here
segment code use32 class=code
    start:
        ;citim a de la tastatura
        push dword a;punem pe stiva adresa lui a
        push dword format;punem pe stiva adresa formatului
        call [scanf];chemam functia de citire din modulul msvcrt.dll 
        add esp, 4*2;reinitializam stiva
        
        ;citim b de la tastatura
        push dword b;punem pe stiva adresa lui b
        push dword format;punem pe stiva adresa formatului
        call [scanf];chemam functia de citire din modulul msvcrt.dll
        add esp, 4*2;reinitializam manual stiva
        
        ;incepem adunarea
        mov eax,[a];mutam in eax VALOAREA CONTINUTULUI de la adresa lui a
        add eax,[b];adunam la registrul EAX VALOAREA CONTINUTULUI de la adresa lui b
        mov edx,k;cum k este definit drept o constanta, mutam k in EDX pentru pregatirea operanzilor inmultirii
        imul edx;rezultatul va fi in perechea de doublewords(creand un quadword) edx:eax
        cmp edx,0;comparam partea high a quadword-ului EDX:EAX pentru a vedea cat de lung este rezultatul
        je caz_1;daca EDX este egal cu 0, atunci avem de a face cu numere ce incap pe un doubleword
        ;in caz contrar(adica in cazul 2),trebuie sa punem pe stiva, in aceasta ordine, urmatoarele dublucuvinte : EAX, EDX, mesaj_caz_2
        push eax;punem pe stiva EAX
        push edx;punem pe stiva EDX
        push dword mesaj_caz_2;punem pe stiva mesajul pentru cazul 2(cazul in care rezultatul nu incape pe un doubleword)
        call [printf];chemam functia de afisare din modulul msvcrt.dll
        add esp,4*3;reinitializam stiva
        jmp final;facem JMP la final pentru a nu trece prin cazul 1
        caz_1:
        push eax;punem pe stiva EAX,partea low a quadword-ului rezultat
        push dword mesaj_caz_1;punem pe stiva mesajul pentru cazul 1(cazul in care rezultatul incape pe un doubleword)
        call [printf];chemam functia de afisare din modulul msvcrt.dll
        add esp,4*2;reinitializam stiva
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
