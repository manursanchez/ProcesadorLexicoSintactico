//===========================================//

//  PRÁCTICA PROCESADORES DEL LENGUAJE I   
//	Alumno: Manuel Rodríguez Sánchez       
//  Email: mrodrigue212@alumno.uned.es     

//===========================================//

package compiler.lexical;

import compiler.syntax.sym;
import compiler.lexical.Token;
import es.uned.lsi.compiler.lexical.ScannerIF;
import es.uned.lsi.compiler.lexical.LexicalError;
import es.uned.lsi.compiler.lexical.LexicalErrorManager;

// incluir aqui, si es necesario otras importaciones

//======DIRECTIVAS======
%%
 
%public
%class Scanner
%char
%line
%column
%cup

%implements ScannerIF
%scanerror LexicalError

%ignorecase
%full

%state COMENTARIO


// incluir aquí, si es necesario otras directivas

//======MAS DECLARACIONES======

%{

///// Para contar delimitadores de comentarios //////

private int contadorComentario=0;

//Función de tipo token, para la creación de tokens, y con esto reducir el código.

Token nuevoToken(int nToken){
	Token token = new Token (nToken);
    token.setLine (yyline + 1);
    token.setColumn (yycolumn + 1);
    token.setLexema (yytext ());
    return token;
}

//Función de tipo token con el que creamos el token sin comillas.

Token cadenaToken (int nToken, String cadenaSinComillas) {
  	Token token = new Token(nToken);
  	token.setLine (yyline + 1);
    token.setColumn (yycolumn + 1);
    token.setLexema (cadenaSinComillas); 
    return token;
}

  LexicalErrorManager lexicalErrorManager = new LexicalErrorManager ();
  
%}

%eofval{
{
	if(contadorComentario > 0){
		lexicalErrorManager.lexicalFatalError ("ERROR - Delimitadores de comentarios mal balanceados. Existe/n: "+contadorComentario+" comentario/s no cerrado/s.");
		contadorComentario = 0;
		}
		else return nuevoToken(sym.EOF);
}
%eofval}


//ESPACIO_BLANCO=[ \t\r\n\f]
LETRA= [a-zA-Z]  								
NUMERO= [0-9]
NATURALES=[1-9]
ESPACIO_BLANCO=([\ \t\b\r\n\f])+									
SALTO_LINEA = [\n\r]+				
ENTERO_TAL_CUAL = 0|{NATURALES}({NUMERO})*	// Siempre tiene que ser >=0												
IDENTIFICADOR = ({LETRA}({LETRA}|{NUMERO})*)     		
fin = "fin"{ESPACIO_BLANCO}
CADENA=[\"](.)*[\"]
ID_ERRONEO={ENTERO_TAL_CUAL}{IDENTIFICADOR}  
CERO_IZQ = 0+{NATURALES}({ENTERO_TAL_CUAL})*

%%

<YYINITIAL> 
{
           			       
    // Operadores aritméticos
    "+"                {return nuevoToken(sym.PLUS);}
    "-"                {return nuevoToken(sym.MINUS);}
    "*"                {return nuevoToken(sym.PRODUCTO);}
    
    // Operadores lógicos
    "NOT"				{return nuevoToken(sym.NOT);}
    "OR"				{return nuevoToken(sym.OR);}
    
    //Operadores relacionales
    
    ">"					{return nuevoToken(sym.MAYORQUE);}
    "="					{return nuevoToken(sym.IGUAL);}
    
    //Operador de asignación
    
    ":="				{return nuevoToken(sym.ASIGNACION);}                 
    
    //Operadores de acceso
    
    "."					{return nuevoToken(sym.PUNTO);}
    
    // Delimitadores
    ";"                 {return nuevoToken(sym.PUNTOCOMA);}
    "["					{return nuevoToken(sym.CORCHETEABIERTO);}
    "]"					{return nuevoToken(sym.CORCHETECERRADO);}
    "("					{return nuevoToken(sym.PARENTESISABIERTO);}
    ")"					{return nuevoToken(sym.PARENTESISCERRADO);}    					
    ","					{return nuevoToken(sym.COMA);}
    ":"					{return nuevoToken(sym.DOSPUNTOS);}
    "*)"				{lexicalErrorManager.lexicalError ("ERROR - ¡Se intenta cerrar un comentario no abierto!");}


    // Palabras reservadas del lenguaje
    "ARRAY"				{return nuevoToken(sym.ARRAY);}
    "BEGIN"            	{return nuevoToken(sym.BEGIN);}
    "BOOLEAN"           {return nuevoToken(sym.BOOLEAN);}
    "CONST"				{return nuevoToken(sym.CONST);}
    "DO"				{return nuevoToken(sym.DO);}
    "ELSE"				{return nuevoToken(sym.ELSE);}
    "END"              	{return nuevoToken(sym.END);}
    "FALSE"				{return nuevoToken(sym.FALSE);}
    "FOR"				{return nuevoToken(sym.FOR);}
    "IF"				{return nuevoToken(sym.IF);}
    "INTEGER"			{return nuevoToken(sym.INTEGER);} // Puede ser >=0 o <=0
    "MODULE"			{return nuevoToken(sym.MODULE);}
    "OF"				{return nuevoToken(sym.OF);}
    "PROCEDURE"			{return nuevoToken(sym.PROCEDURE);}
    "RETURN"			{return nuevoToken(sym.RETURN);}
    "THEN"				{return nuevoToken(sym.THEN);}
    "TO"				{return nuevoToken(sym.TO);}
    "TRUE"				{return nuevoToken(sym.TRUE);}
    "TYPE"				{return nuevoToken(sym.TYPE);}
    "VAR"				{return nuevoToken(sym.VAR);}
    "WHILE"				{return nuevoToken(sym.WHILE);}
    "WRITESTRING"		{return nuevoToken(sym.WRITESTRING);}
    "WRITEINT"			{return nuevoToken(sym.WRITEINT);}
    "WRITELN"			{return nuevoToken(sym.WRITELN);}
    
<COMENTARIO>	\r\n|\r|\n	{}
<COMENTARIO>    "(*"				{ lexicalErrorManager.lexicalInfo  ("Comentario detectado.");
											yybegin(COMENTARIO);
											contadorComentario++;}		
    
// incluir aquí el resto de las reglas patrón - acción
    
			
// Número entero tal cual.

{ENTERO_TAL_CUAL}   { return nuevoToken (sym.ENTERO_TAL_CUAL); }             

// Identificador definido por el usuario/programador. Variables o nombres de funciones

{IDENTIFICADOR}     {return nuevoToken (sym.IDENTIFICADOR); } 
							
// Cuando detecta que un identificador empieza por un número.

{ID_ERRONEO}		{lexicalErrorManager.lexicalFatalError ("Identificador '"+yytext()+"' no válido. Contiene un número al principio.");}

// Cuando detecta que un número tiene ceros a su izquierda

{CERO_IZQ}			{lexicalErrorManager.lexicalFatalError("Número:' "+yytext()+"' no admitido. No puede haber ceros a la izquierda");}

{ESPACIO_BLANCO}	{}
{SALTO_LINEA}		{}

{CADENA}			{
						lexicalErrorManager.lexicalInfo("Cadena entrecomillada detectada: " + yytext());
						String cadena=yytext(); 
						
						//Eliminamos el primer y último carácter de la cadena, que son las comillas.
						
						cadena=cadena.substring(1,cadena.length()-1);  
						lexicalErrorManager.lexicalInfo("Cadena sin comillas: " + cadena);
						return cadenaToken(sym.CADENA,cadena);}
                 
{fin} {}
    
    // Error en caso de no coincidir con un patrón definido anteriormente. Caracteres extraños.
	[^]     
                        {                                               
                           LexicalError error = new LexicalError ();
                           error.setLine (yyline + 1);
                           error.setColumn (yycolumn + 1);
                           error.setLexema (yytext ());
                           lexicalErrorManager.lexicalFatalError (error + " Carácter o token no reconocido: " +yytext());
                        }
}

// Estado Comentario
		
<COMENTARIO>	"*)"	{contadorComentario--;
						lexicalErrorManager.lexicalInfo("Cerrando comentario.");
						if (contadorComentario==0)
								yybegin(YYINITIAL);}
<COMENTARIO>	[^(*]	{}
<COMENTARIO>	[(*]	{}
						



                    