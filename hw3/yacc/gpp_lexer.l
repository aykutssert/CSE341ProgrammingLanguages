%{
	

	#include "gpp.h"
	#include "gpp_interpreter.h"

	int newline = 1;
	
  
%}

%%
"and"      { return KW_AND; }                  //keyword return
"or"        { return KW_OR; }                  //keyword return
"not"       { return KW_NOT; }                 //keyword return
"equal"     { return KW_EQUAL; }               //keyword return
"less"    { return KW_LESS; }                //keyword return
"nil"       { return KW_NIL; }                 //keyword return
"list"      { return KW_LIST; }                //keyword return
"append"    { return KW_APPEND; }              //keyword return
"concat"    { return KW_CONCAT; }              //keyword return
"set"       { return KW_SET; }                 //keyword return
"def"       {  return KW_DEF; }                 //keyword return
"for"       { return KW_FOR; }                 //keyword return
"if"        { return KW_IF; }                  //keyword return
"exit"      { return KW_EXIT; }                   //keyword return
"load"      { return KW_LOAD; }                //keyword return
"display"   { return KW_DISPLAY; }             //keyword return
"true"      { return KW_TRUE; }                //keyword return
"false"     { return KW_FALSE; }               //keyword return
"+"        { return OP_PLUS;}                //operator return
"-"         { return OP_MINUS;}                  //operator return
"* "       { return OP_MULT;}                   //operator return
"("        { return OP_OP;}                     //operator return
")"         { return OP_CP;}                 //operator return
"/"         { return OP_DIV;}                //operator return
", "        { return OP_COMMA;}             //operator return

	

;;.* {return COMMENT;}
[a-zA-Z_][a-zA-Z0-9_]*     	 		{ strcpy(yylval.str, yytext); return ID; }
[0-9]+[b][0-9]+    { yylval.valueb = converting(yytext); return VALUEF; }

^\n							{ if (yyin == stdin) return 0; }
[ \t\r	]                   { ; }
\n						  	{ ++newline; }
<<EOF>>						{ return 0; }

[0]+[a-zA-Z][_a-zA-Z0-9]* 	{  return 0; }  //leading zero
. 							{  return 0; } 
%%

int yywrap() {
	
    return 1;
}