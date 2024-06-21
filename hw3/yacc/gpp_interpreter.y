%{
#include <stdio.h>
#include <stdlib.h>
#include "gpp.h"
#include "gpp.c"

extern FILE * yyin;     /* defined by lex, reads from this file */
extern FILE * yyout;    /* defined by lex, writes to this file */
extern char * yytext;   /* defined by lex current token */

int yylex();
int yyerror(char* str) {
    fprintf(yyout, "syntax error");
    return 0;
}



Function f[16];

int i=0;

char whichExpression='0';

Valueb function_result;

Valueb temp2;

Valueb temp;

%}

%union {
    Valueb valueb;
    char str[16];
}



%start START
%token KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS KW_NIL KW_LIST KW_APPEND 
%token KW_CONCAT KW_SET KW_DEF KW_FOR KW_IF KW_EXIT KW_LOAD KW_DISPLAY KW_TRUE KW_FALSE
%token OP_PLUS OP_MINUS OP_DIV OP_MULT OP_OP OP_CP OP_COMMA 
%token COMMENT
%token <valueb> VALUEF
%token <str> ID


%type <valueb> INPUT
%type <valueb> EXP
%type <valueb> FUNCTION

%%

START   : START INPUT 
        | INPUT 
        ;

INPUT   : FUNCTION      { fprintf(yyout,"#function\n"); }
        | EXP           { fprintf(yyout, "Result: %db%d\n", $1.num, $1.denom);  }
        | OP_OP KW_EXIT OP_CP   { return 0;  } 
        |COMMENT        { fprintf(yyout,"Result: COMMENT\n"); }
        ;

EXP     : OP_OP OP_PLUS EXP EXP OP_CP                   { $$ = adding($3, $4); whichExpression='+'; }
        | OP_OP OP_MINUS EXP EXP OP_CP                  { $$ = substracting($3, $4); whichExpression='-'; }
        | OP_OP OP_MULT EXP EXP OP_CP                   { $$ = multiplying($3, $4); whichExpression='*'; }
        | OP_OP OP_DIV EXP EXP OP_CP                    { $$ = diving($3, $4); whichExpression='/'; } 

        | OP_OP ID OP_CP{
            $$ = function_result;
        }

        | OP_OP ID EXP OP_CP{

            Function *f1=function_get(&f,$2);
            if(f1 !=NULL){
            if(f1->operation=='+'){
                $$ = adding($3, temp2);
            }
            else if(f1->operation=='-'){
                $$ = substracting($3, temp2);
            }
            else if(f1->operation=='/'){
                $$ = diving($3, temp2);
            }
            else if(f1->operation=='*'){
                $$ = multiplying($3, temp2);
            }
            }
        }

        | OP_OP ID EXP EXP OP_CP{
            
            Function *f1=function_get(&f,$2);
            if(f1 !=NULL){
            if(f1->operation=='+'){
                $$ = adding($3, $4);
            }
            else if(f1->operation=='-'){
                $$ = substracting($3, $4);
            }
            else if(f1->operation=='/'){
                $$ = diving($3, $4);
            }
            else if(f1->operation=='*'){
                $$ = multiplying($3, $4);
            }
            }
        }
        
        | ID                                            { $$ = creating(0, 1); }                                      
        | VALUEF                                        { $$ = temp = $1; }
        ;

FUNCTION: 
     OP_OP KW_DEF ID ID ID EXP OP_CP              {$$ = creating(0, 1); function_set(&f[i],whichExpression,$3); i++; }
   | OP_OP KW_DEF ID ID  EXP OP_CP              {$$ = creating(0, 1); temp2.num=temp.num; temp2.denom=temp.denom; function_set(&f[i],whichExpression,$3); i++; }
   | OP_OP KW_DEF ID  EXP OP_CP                 {$$ = function_result = $4; function_set(&f[i],whichExpression,$3); i++;}
                                       
%%

int main(int argc, char * argv[]) {
     
    if (argc == 1)
    {   
        printf("(exit) for exit\n");
        printf("input:\n"); 
    }
    else if (argc == 2)
    {      
        
        yyin = fopen(argv[1], "r");
        if (yyin == NULL)
        {
            printf("File not found\n");
            return 0;
        }
    }
    yyparse();   
}
