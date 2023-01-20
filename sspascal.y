%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 1

#define TIP_INT 1
#define TIP_REAL 2
#define TIP_CHAR 3

double stiva[20];
int sp;
extern int yylex();
extern void yyerror(char* s);
void push(double x)
{ stiva[sp++]=x; }

double pop()
{ return stiva[--sp]; }

%}

%union {
  	int l_val;
	char *p_val;
}

%token VAR
%token PROGRAM
%token RETURN
%token IF
%token WHILE
%token DISPLAYOUTPUT
%token GETINPUT
%token ELSE
%token ID
%token INT
%token FLOAT
%token STRING
%token <p_val> CONST_INT
%token <p_val> CONST_REAL
%token <p_val> CONST_CHAR
%token CONST_STR

%token CHAR

%token ATRIB
%token LE
%token GE
%token STRICT_LESS
%token STRICT_GREAT
%token SBRA_O
%token SBRA_C
%token BRA_O
%token BRA_C
%token BY

%left '+' '-'
%left OR
%left AND
%left NOT
%left EQUALITY

//%type <l_val> expr_stat factor_stat constantaF
%%
program:            PROGRAM BRA_O declaration_list statement_list RETURN CONST_INT ';' BRA_C 
		    ;
declaration_list:   declaration ';'
		    | declaration ';' declaration_list
		    ;
declaration:	   VAR ID BY type
		    | VAR ID BY type ',' ID BY type
		    ;
type:               INT
		    | FLOAT 
		    | CHAR 
		    | STRING
		    ;                    
statement_list:     statement ';'
                    | statement ';' statement_list
                    ;
statement:          simple_statement 
		    | compound_statement
		    ;
simple_statement:   assignment 
		    | input_output
		    ;
assignment:         ID ATRIB expression
		    ;
expression:         term '+' expression
		    | term
		    ;
term:               term '*' factor 
		    | factor
		    ;
factor:             SBRA_O expression SBRA_C
		    | ID
		    | constant
		    ;
input_output:       GETINPUT input 
		    | DISPLAYOUTPUT SBRA_O output SBRA_C
		    ;
input:              CONST_STR
		    | CONST_INT
		    | CONST_REAL
		    | CONST_CHAR
		    | ID
		    ;
output:             CONST_STR 
		    | CONST_INT
		    | CONST_REAL
		    | CONST_CHAR
		    | ID
		    ;
compound_statement: if_statement 
		    | while_statement
		    ;  
if_statement:       IF SBRA_O condition SBRA_C BRA_O statement_list BRA_C 
		    | IF SBRA_O condition SBRA_C BRA_O statement_list BRA_C ELSE BRA_O statement_list BRA_C
		    ;
condition:          expression relation expression 
                    ;
relation:	  LE
		    | GE
		    | STRICT_LESS
		    | STRICT_GREAT
		    | OR
		    | AND
		    | NOT
		    | EQUALITY
		    ;
constant:	    CONST_INT
		    | CONST_REAL
		    | CONST_CHAR
		    ;		                   
while_statement:    WHILE SBRA_O condition SBRA_C BRA_O statement_list BRA_C
		    ;
%%

void yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

int main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stdout,"\tO.K.\n");
}
