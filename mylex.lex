%{
#define NUM 300
#define COURSES 301
#define NAME 302
#define CREDITS 303
#define DEGREE 304
#define SCHOOL 305
#define ELECT 306

union {
  int ival;
  char str [80];
  float fval;
} yylval;

#include <string.h> 

extern int atoi (const char *);
%}

%option noyywrap

/* exclusive start condition -- deals with C++ style comments */ 
%x COMMENT

%%

\<courses\> { strcpy(yylval.str, yytext); return COURSES; }

[1-9][0-9][0-9][0-9][0-9]   { yylval.ival = atoi (yytext); return NUM; }

\"([^\\"\n]|.)*\"   { strcpy(yylval.str, yytext); return NAME; }

0\.[0-9]*|[1-5](\.[0-9]*)?|6  { yylval.fval = atof (yytext); return CREDITS; }

[BM].Sc.  { strcpy(yylval.str, yytext); return DEGREE; }

Software|Electrical|Mechanical|Management|Biomedical  { strcpy(yylval.str, yytext); return SCHOOL; }

[eE]lective { strcpy(yylval.str, yytext);return ELECT; }

[ \n\t\r]+   /* skip white space */

"//"       { BEGIN (COMMENT); }

<COMMENT>.+ /* skip comment */
<COMMENT>\n {  /* end of comment --> resume normal processing */
                BEGIN (0); }

.          { fprintf (stderr, "unrecognized token %c\n", yytext[0]); }

%%

int main (int argc, char **argv)
{
   int token;

   if (argc != 2) {
      fprintf(stderr, "Usage: %s <input file name>\n", argv [0]);
      exit (1);
   }

   yyin = fopen (argv[1], "r");

   while ((token = yylex ()) != 0)
     switch (token) {
	 case COURSES: printf("COURSES : %s\n", yylval.str);
	              break;
	 case NUM:     printf ("NUMBER  : %d\n", yylval.ival);
	              break;
	 case NAME: printf ("NAME: %s\n", yylval.str);
	              break;
	case CREDITS: printf ("CREDITS: %f\n", yylval.fval);
	              break;
	case DEGREE: printf ("DEGREE: %s\n", yylval.str);
	              break;
	case SCHOOL: printf ("SCHOOL: %s\n", yylval.str);
	              break;
	case ELECT: printf ("ELECT: %s\n", yylval.str);
	              break;
         default:     fprintf (stderr, "error ... \n"); exit (1);
     } 
   fclose (yyin);
   exit (0);
}

