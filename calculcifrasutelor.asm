;cod pentru main.asm
bits 32
segment code use32 public code
global calculcifrasutelor ; eticheta

calculcifrasutelor:
mov ax,[esp+4]
mov bl,100
div bl; in ah va fi restul si in al catul
mov ah,0
mov bl,10
div bl; acum in ah va fi restul pe care il cautam
mov al,ah
mov ah,0
ret 4
