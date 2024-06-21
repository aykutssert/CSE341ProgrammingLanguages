

%{
#include <stdio.h>
#include "definitions.h" 
%}
%option noyywrap

COMMENT ;;.*               
STRING [\"].*[\"]                
VALUEF [0-9]+[b][0-9]+
IDENTIFIER [a-zA-Z][a-zA-Z0-9]*
VALUEI [0-9]*


%%
and      { return KW_AND; }                  //keyword return
or        { return KW_OR; }                  //keyword return
not       { return KW_NOT; }                 //keyword return
equal     { return KW_EQUAL; }               //keyword return
less      { return KW_LESS; }                //keyword return
nil       { return KW_NIL; }                 //keyword return
list      { return KW_LIST; }                //keyword return
append    { return KW_APPEND; }              //keyword return
concat    { return KW_CONCAT; }              //keyword return
set       { return KW_SET; }                 //keyword return
def       { return KW_DEF; }                 //keyword return
for       { return KW_FOR; }                 //keyword return
if        { return KW_IF; }                  //keyword return
exit      { return KW_EXIT; }                   //keyword return
load      { return KW_LOAD; }                //keyword return
display   { return KW_DISPLAY; }             //keyword return
true      { return KW_TRUE; }                //keyword return
false     { return KW_FALSE; }               //keyword return
[+]        { return OP_PLUS;}                //operator return
[-]         { return OP_MINUS;}                  //operator return
[*]         { return OP_MULT;}                   //operator return
[(]        { return OP_OP;}                     //operator return
[)]         { return OP_CP;}                 //operator return
[/]         { return OP_DIV;}                //operator return
[,]         { return OP_COMMA;}             //operator return


		
{VALUEF}   { return VALUEF; }               //regular expression for VALUEF
{IDENTIFIER}  { return IDENTIFIER; }        //regular expression for IDENTIFIER
{COMMENT} { return COMMENT;}                //regular expression for COMMENT


{STRING} {return STRING;}		            //regular expression for STRING
{VALUEI} {return VALUEI;}                   //regular expression for VALUEI
[\n] {}                                     
[[:space:]]+                                
 
[0-9][0-9a-zA-Z]+ {printf("LEXICAL ERROR: %s identifier can not be start number\n", yytext);}
.	 {printf("SYNTAX_ERROR %s cannot be tokenized\n", yytext); }

%%


int main() {
   int token;
   //yylex => is a function used by many lexical analysis processors. This function is used to scan the given input text and perform lexical analysis.
   while ((token = yylex())) {
       switch (token) {
           case KW_AND:
               printf("KW_AND\n");
               break;
           case KW_OR:
               printf("KW_OR\n");
               break;
           case KW_NOT:
               printf("KW_NOT\n");
               break;
           case KW_EQUAL:
               printf("KW_EQUAL\n");
               break;
           case KW_LESS:
               printf("KW_LESS\n");
               break;
           case KW_NIL:
               printf("KW_NIL\n");
               break;
           case KW_LIST:
               printf("KW_LIST\n");
               break;
           case KW_APPEND:
               printf("KW_APPEND\n");
               break;
           case KW_CONCAT:
               printf("KW_CONCAT\n");
               break;
           case KW_SET:
               printf("KW_SET\n");
               break;
           case KW_DEF:
               printf("KW_DEF\n");
               break;
           case KW_FOR:
               printf("KW_FOR\n");
               break;
           case KW_IF:
               printf("KW_IF\n");
               break;
           case KW_EXIT:
               printf("KW_EXIT\n");
               break;
           case KW_LOAD:
               printf("KW_LOAD\n");
               break;
           case KW_DISPLAY:
               printf("KW_DISPLAY\n");
               break;
           case KW_TRUE:
               printf("KW_TRUE\n");
               break;
           case KW_FALSE:
               printf("KW_FALSE\n");
               break;
           case VALUEF:
               printf("VALUEF\n");
               break;
           case IDENTIFIER:
               printf("IDENTIFIER\n");
               break;
           case COMMENT:
               printf("COMMENT\n");
               break;
            case OP_PLUS:
               printf("OP_PLUS\n");
               break;
            case OP_MINUS:
               printf("OP_MINUS\n");
               break;
           case OP_OP:
               printf("OP_OP\n");
               break;
           case OP_CP:
               printf("OP_CP\n");
               break;
           case OP_COMMA:
               printf("OP_COMMA\n");
               break;
           case OP_DIV:
               printf("OP_DIV\n");
               break;
           case OP_MULT:
               printf("OP_MULT\n");
               break;
            case VALUEI:
                printf("VALUEI\n");
                break;
            case STRING:
                printf("STRING\n");
                break;
           default:
               printf("%s\n", yytext);
       }
   }
   return 0;
}
