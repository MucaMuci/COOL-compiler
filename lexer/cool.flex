/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%option noyywrap 
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
int CommentCounter = 0;

%}

/*
 * Define names for regular expressions here.
 */

%x COMMENT
%x LINECOMMENTAR
%x STRING

DARROW          =>
ELSE            [eE][lL][sS][eE]
FI              [fF][iI]
IF              [iI][fF]
CLASS           [cC][lL][aA][sS][sS]
IN              [iI][nN]
INHERITS        [iI][nN][hH][eE][rR][iI][tT][sS]
LET             [lL][eE][tT]
LOOP            [lL][oO][oO][pP]
POOL            [pP][oO][oO][lL]
THEN            [tT][hH][eE][nN]
WHILE           [wW][hH][iI][lL][eE]
CASE            [cC][aA][sS][eE]
ESAC            [eE][sS][aA][cC]
NEW             [nN][eE][wW]
OF              [oO][fF]
NOT             [nN][oO][tT]
ISVOID          [iI][sS][vV][oO][iI][dD]

TRUE            [t][rR][uU][eE]
FALSE           [f][aA][lL][sS][eE]

TIMES           "*"
DIVIDE          "/"
MINUS           "-"
PLUS            "+"
EQUAL           "="

INTCONST        [0-9]+

OBJECTID        [a-z][A-Za-z0-9_]*

TYPEID          [A-Z][a-zA-Z0-9_]*

COMMENTSTART    "(*"
COMMENTEND      "*)"
LINECOMMENT     "--"

LE              "<="

ASSIGN          "<-"

%%

 /*
  *  Nested comments
  */


<COMMENT>{
"*)"          { CommentCounter--;
                if(CommentCounter==0)
                  BEGIN(INITIAL);   
              }
"(*"          { CommentCounter++; }
"\n"          { curr_lineno++; }
.             {;} 
}

<LINECOMMENTAR>{
"\n"          {  BEGIN (INITIAL); }
.             {;} 
}

<STRING>{
\"           {
                BEGIN (INITIAL);
                *string_buf_ptr=0;
                if(strlen(string_buf)>1024){
                  cool_yylval.error_msg = "String constant too long";
                  return(ERROR);
                }
                cool_yylval.symbol = stringtable.add_string(string_buf);
                return (STR_CONST);
              }
"\n"            {
                BEGIN (INITIAL);
                *string_buf_ptr=0;
                curr_lineno++;
                cool_yylval.error_msg = "Unterminated string constant";
                return(ERROR);
              }
\\[^btnf]     { *string_buf_ptr++ = yytext[1]; }
"\\b"         { *string_buf_ptr++ = 8; }
"\\t"         { *string_buf_ptr++ = 9; }
"\\n"         { *string_buf_ptr++ = 10; }
"\\f"         { *string_buf_ptr++ = 12; }
.             { *string_buf_ptr++ = yytext[0]; }    
}
 /*
  *  The multiple-character operators.
  */
{NOT}       { return (NOT);}       /* 281 */
{CLASS}     { return (CLASS);}     /* 258 */ 
{ELSE}      { return (ELSE);}      /* 259 */
{FI}        { return (FI);}        /* 260 */
{IF}        { return (IF);}        /* 261 */
{IN}        { return (IN);}        /* 262 */
{INHERITS}  { return (INHERITS);}  /* 263 */
{LET}       { return (LET);}       /* 264 */
{LOOP}      { return (LOOP);}      /* 265 */
{POOL}      { return (POOL);}      /* 266 */
{THEN}      { return (THEN);}      /* 267 */
{WHILE}     { return (WHILE);}     /* 268 */
{CASE}      { return (CASE);}      /* 269 */
{ESAC}      { return (ESAC);}      /* 270 */
{OF}        { return (OF);}        /* 271 */
{DARROW}		{ return (DARROW); }   /* 272 */
{NEW}       { return (NEW);}       /* 273 */
{ISVOID}    { return (ISVOID);}    /* 274 */
{INTCONST}  {                      /* 276 */
              cool_yylval.symbol = inttable.add_string(yytext);
              return (INT_CONST);
            }
{TRUE}      {                      /* 277 */
              cool_yylval.boolean = 1;
              return (BOOL_CONST);
            }
{FALSE}     {                      /* 277 */
              cool_yylval.boolean = 0;
              return (BOOL_CONST);
            }
{TYPEID}    {                       
              cool_yylval.symbol = idtable.add_string(yytext);
              return (TYPEID);
            }
{OBJECTID}  {                      /* 279 */
              cool_yylval.symbol = stringtable.add_string(yytext);
              return (OBJECTID);
            }




{TIMES}     { return '*';}
{DIVIDE}    { return '/';}
{MINUS}     { return '-';}
{PLUS}      { return '+';}
{EQUAL}     { return '=';}
"("         { return '(';}
")"         { return ')';}
"{"         { return '{';}
"}"         { return '}';}
";"         { return ';';}
"@"         { return '@';}
"."         { return '.';}
"~"         { return '~';}
":"         { return ':';}
","         { return ',';}
"<"         { return '<';}

{ASSIGN}    { return (ASSIGN);}    /* 280 */
{LE}        { return (LE);}        /* 282 */

{COMMENTSTART} {
                CommentCounter++;
                BEGIN (COMMENT); 
              }
{COMMENTEND}  {
                cool_yylval.error_msg = "Unmatched *)";
                return(ERROR);
              }
{LINECOMMENT} { BEGIN LINECOMMENTAR;}
[\n]            { curr_lineno++;} 
[ \t\r\b\f\v]+          {;}
\"            {
                string_buf_ptr = string_buf;
                BEGIN STRING;
              }
.             { 
                cool_yylval.error_msg = yytext;
                return (ERROR);
              }



 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%
