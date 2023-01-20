%{
#include "sspascal.tab.h"
%}

%option noyywrap
%option caseless

LETTER		[A-Za-z_]
DIGIT    	[0-9]
IDENTIFICATOR	{LETTER}({LETTER}|{DIGIT})*
BASE10_DIG	{DIGIT}+
EXPON		(E|e)("+"?|"-"){DIGIT}{1,2}
REAL_NO		{DIGIT}"."{DIGIT}{EXPON}?
DELIMIT_1	[;.,:]
OPERATOR_1	[+*/()<>='%']|"-"|"["|"]"
STRING		["][^\n"]*["]
CHARACTER	"'"[^\n]"'"

%%

[ \t\n]

var		{return VAR;}
program    	{return PROGRAM;}
return		{return RETURN;}
if		{return IF;}
while		{return WHILE;}
displayoutput		{return DISPLAYOUTPUT;}
getinput		{return GETINPUT;}
else		{return ELSE;}
int		{return INT;}
float		{return FLOAT;}
char		{return CHAR;}
"("		{return SBRA_O;}
")"		{return SBRA_C;}
"{"		{return BRA_O;}
"}"		{return BRA_C;}
"="		{return ATRIB;}
"<="		{return LE;}
">="		{return GE;}
"<"		{return STRICT_LESS;}
">"		{return STRICT_GREAT;}
"||"		{return OR;}
"&&"		{return AND;}
"!="		{return NOT;}
"=="		{return EQUALITY;}
":"		{return BY;}

{IDENTIFICATOR}	{return ID;}
{BASE10_DIG}	{
	yylval.p_val = yytext; 
	return CONST_INT;
		}
{REAL_NO}	{
	yylval.p_val = yytext; 
	return CONST_REAL;
		}
{CHARACTER}	{
	yylval.p_val = yytext;
	return CONST_CHAR;
		}
{STRING}	{return CONST_STR;}

{DELIMIT_1}	{return yytext[0];}
{OPERATOR_1}	{return yytext[0];}
. { printf("Eroare lexicala\n", yytext) ; }
%%
