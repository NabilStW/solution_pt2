import java.util.regex.PatternSyntaxException;

%%// Options of the scanner

%class LexicalAnalyzer // Name
%unicode               // Use unicode
%line                  // Use line counter (yyline variable)
%column                // Use character counter by line (yycolumn variable)
%function nextToken
%type Token
%yylexthrow PatternSyntaxException

%eofval{
	return new Token(Terminal.EOS, yyline, yycolumn);
%eofval}

//Extended Regular Expressions

AlphaUpperCase    = [A-Z]
AlphaLowerCase    = [a-z]
Alpha             = {AlphaUpperCase}|{AlphaLowerCase}
Numeric           = [0-9]
AlphaNumeric      = {Alpha}|{Numeric}
LowerAlphaNumeric	= {AlphaLowerCase}|{Numeric}

BadInteger     = (0[0-9]+)
Integer        = ([1-9][0-9]*)|0
VarName        = ({AlphaLowerCase})({LowerAlphaNumeric})*
ProgName       = ({AlphaUpperCase})(({AlphaNumeric})*({AlphaLowerCase})({AlphaNumeric})* | {Numeric}*)
BadProgName    = ({AlphaUpperCase})+
LineFeed       = "\n"
CarriageReturn = "\r"
EndLine        = ({LineFeed}{CarriageReturn}?) | ({CarriageReturn}{LineFeed}?)
Space          = (\t | \f | " ")
Spaces         = {Space}+

//Declare exclusive states
%xstate YYINITIAL, SHORTCOMMENTS, LONGCOMMENTS

%%// Identification of tokens

<SHORTCOMMENTS> {
// End of comment
{EndLine}        {yybegin(YYINITIAL); return new Token(Terminal.ENDLINE, yyline, yycolumn, "\\n");} // go back to analysis
.	   				     {} //ignore any character
}

<LONGCOMMENTS> {
// End of comment
	"*/"             {yybegin(YYINITIAL);} // go back to analysis
  <<EOF>>          {throw new PatternSyntaxException("A comment is never closed.",yytext(),yyline);}
	[^]					     {} //ignore any character
}

<YYINITIAL> {
// Comments
    "//"              {yybegin(SHORTCOMMENTS);} // go to ignore mode
    "/*"              {yybegin(LONGCOMMENTS);} // go to ignore mode
// Code delimiters
  "BEGINPROG"         {return new Token(Terminal.BEGINPROG, yyline, yycolumn, yytext());}
  "ENDPROG"           {return new Token(Terminal.ENDPROG, yyline, yycolumn, yytext());}
// Assignation
  ":="                {return new Token(Terminal.ASSIGN, yyline, yycolumn, yytext());}
// Parenthesis
  "("                 {return new Token(Terminal.LPAREN, yyline, yycolumn, yytext());}
  ")"                 {return new Token(Terminal.RPAREN, yyline, yycolumn, yytext());}
// Arithmetic signs
  "+"                 {return new Token(Terminal.PLUS, yyline, yycolumn, yytext());}
  "-"                 {return new Token(Terminal.MINUS, yyline, yycolumn, yytext());}
  "*"                 {return new Token(Terminal.TIMES, yyline, yycolumn, yytext());}
  "/"                 {return new Token(Terminal.DIVIDE, yyline, yycolumn, yytext());}
// Conditional keywords
  "IF"                {return new Token(Terminal.IF, yyline, yycolumn, yytext());}
  "THEN"              {return new Token(Terminal.THEN, yyline, yycolumn, yytext());}
  "ELSE"              {return new Token(Terminal.ELSE, yyline, yycolumn, yytext());}
  "ENDIF"             {return new Token(Terminal.ENDIF, yyline, yycolumn, yytext());}
// Loop keywords
  "WHILE"             {return new Token(Terminal.WHILE, yyline, yycolumn, yytext());}
  "DO"                {return new Token(Terminal.DO, yyline, yycolumn, yytext());}
  "ENDWHILE"          {return new Token(Terminal.ENDWHILE, yyline, yycolumn, yytext());}
// Comparison operators
  "="                 {return new Token(Terminal.EQ, yyline, yycolumn, yytext());}
  ">"                 {return new Token(Terminal.GT, yyline, yycolumn, yytext());}
// IO keywords
  "PRINT"             {return new Token(Terminal.PRINT, yyline, yycolumn, yytext());}
  "READ"              {return new Token(Terminal.READ, yyline, yycolumn, yytext());}
// Numbers
  {BadInteger}        {System.err.println("Warning! Numbers with leading zeros are deprecated: " + yytext()); return new Token(Terminal.NUMBER, yyline, yycolumn, Integer.valueOf(yytext()));}
  {Integer}           {return new Token(Terminal.NUMBER, yyline, yycolumn, Integer.valueOf(yytext()));}
// Variable Names
  {VarName}           {return new Token(Terminal.VARNAME, yyline, yycolumn, yytext());}
  {ProgName}          {return new Token(Terminal.PROGNAME, yyline, yycolumn, yytext());}
  {BadProgName}       {System.err.println("Warning! Program names in uppercase are deprecated: " + yytext()); return new Token(Terminal.PROGNAME, yyline, yycolumn, yytext());}
  {EndLine}           {return new Token(Terminal.ENDLINE, yyline, yycolumn, "\\n");}
  {Spaces}	          {} // ignore spaces
 "*/"                 {throw new PatternSyntaxException("A comment is closed, but never opened.",yytext(),yyline);}
  [^]                 {throw new PatternSyntaxException("Unmatched token, out of symbols",yytext(),yyline);} // unmatched token gives an error
}
