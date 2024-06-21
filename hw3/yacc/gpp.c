#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gpp.h"



void function_set(Function *f,char exp,char *id){ //When defining a function, the function name and which operator it uses are determined.
    strcpy(f->identifier, id);
f->operation=exp;
}



Function* function_get(Function *f,char *id){ //When the function is called, it is searched and returned if found.
    for(int i=0;i<16;i++){
        if(strcmp(id,f[i].identifier)==0){
            return &f[i];
        }
    }
    return NULL;
}



Valueb adding(Valueb v1, Valueb v2) { //adds two valueb numbers. In the form of num and denom.
     

    Valueb r;
    r.num = v1.num * v2.denom + v2.num * v1.denom;
    r.denom = v1.denom * v2.denom;


    simplify(&r);

    return r;
}


Valueb substracting(Valueb v1, Valueb v2) { //subs two valueb numbers. In the form of num and denom.
    Valueb r;
    r.num = v1.num * v2.denom - v2.num * v1.denom;
    r.denom = v1.denom * v2.denom;
    simplify(&r);
    return r;
}

Valueb multiplying(Valueb v1, Valueb v2) { //mult two valueb numbers. In the form of num and denom.
    Valueb r;
    r.num = v1.num * v2.num;
    r.denom = v1.denom * v2.denom;
    simplify(&r);
    return r;
}

Valueb diving(Valueb v1, Valueb v2) { //div two valueb numbers. In the form of num and denom.
    Valueb r;
    r.num = v1.num * v2.denom;
    r.denom = v1.denom * v2.num;
    simplify(&r);
    return r;
}

Valueb converting(char * str) { //We convert the string like 1b2, 3b5 to valueb number.
    Valueb v;
    char * next = str;
    while (*next != 'b') ++next;// goes until the next pointer sees the b character.
    *next = '\0'; ++next;  //b character is replaced with /0. and the string is split into two parts.

    v.num = atoi(str); //The first part of the string is assigned the num value.
    v.denom = atoi(next); //The second part is assigned to the value of denom.

    --next; *(next) = 'b'; // The letter b is placed again where we put /0, and the string returns to its previous state.
    return v;
}

Valueb creating(int num, int denom) { //A valueb number is created according to the incoming parameter value.
    
    Valueb v;
    v.num = num;
    v.denom = denom;
    return v;
}


int gcd(int a, int b) { //greatest common divisor
    return a == 0 ? b : gcd(b % a, a); 
}

void simplify(Valueb * v) { //we simplify the valueb number.
    int div = gcd(v->num, v->denom);
    v->num = v->num / div;
    v->denom = v->denom / div;
}

