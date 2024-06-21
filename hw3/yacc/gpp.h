#ifndef GPP_H
#define GPP_H

typedef struct Valueb {
    int num;    /* numerator */
    int denom;  /* denominator */
} Valueb;

typedef struct Function
{
    char identifier[16];
    char operation;

}   Function;


void function_set(Function *f,char exp,char *id);

Function* function_get(Function *f,char *id);

Valueb adding(Valueb v1, Valueb v2);

Valueb substracting(Valueb v1, Valueb v2);

Valueb multiplying(Valueb v1, Valueb v2);

Valueb diving(Valueb v1, Valueb v2);

Valueb converting(char * str);

Valueb creating(int num, int denom);



#endif