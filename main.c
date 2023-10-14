#include <stdio.h>

int suma_numerelor(int a, int b, int c);

int main()
{
    int a=0, b=0, c=0, suma=0;
    printf("Introduceti a:");
    scanf("%d",&a);

    printf("Introduceti b:");
    scanf("%d",&b);

    printf("Introduceti c:");
    scanf("%d",&c);

    suma = suma_numerelor(a,b,c);

    printf("Rezultatul calculului cerut este %d.",suma);
    return 0;

}
