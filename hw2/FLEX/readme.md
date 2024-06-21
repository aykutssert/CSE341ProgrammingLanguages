# Lexical Analysis Report

This report explains in detail the working principles of the lexical analysis code created using the Flex generator and how the code works. It also includes the steps used to compile and run the code.

## General Description of Lexical Analysis Code

Our Lexical analysis code was created with the Flex (Lex) generator. This code is used to scan input texts and separate them into tokens according to certain rules. Tokens represent words or symbols with specific semantic meanings.

## YYLEX Function

yylex is a function used by many lexical analysis processors. This function is used to scan the given input text and perform lexical analysis.

## Token Definitions

This code recognizes and processes the following tokens:

- `KW_AND`, `KW_OR`, `KW_NOT`, etc.: These tokens represent the keywords of the program. For example, the word "and" is treated as a `KW_AND` token.

- `OP_PLUS`, `OP_MINUS`, `OP_MULT`, etc.: These tokens represent mathematical operators. For example, the "+" sign is treated as an `OP_PLUS` token.

- `VALUEF`: This token represents a custom pattern. For example, a pattern like "42b17" is treated as a `VALUEF` token.

- `IDENTIFIER`: This token represents identifiers (variable names, function names). For example, "myVariable" is treated as an `IDENTIFIER` token.

## Lexical Errors

The code is sensitive to input that falls outside the defined rules. For example, if an identifier begins with a number, a "LEXICAL ERROR" message is displayed.

## Run Commands

make run1 command works by receiving input from the terminal.
make run2 command reads from the input.gpp file.

## Output Examples

To understand how the code works, below is a sample input and output:

**Entry:**
and or not 42b17 myVariable


**Output:**

KW_AND
KW_OR
KW_NOT
LEXICAL ERROR: 42b17 identifier cannot start with a number
IDENTIFIER

This example shows the tokens and errors generated as a result of processing the input.

## Conclusion

Lexical analysis is important to understand the language definition of the programs and to perform syntax analysis in later steps. This code recognizes and processes certain semantic structures based on certain rules when analyzing input. Successfully performing lexical analysis ensures that programs function properly.