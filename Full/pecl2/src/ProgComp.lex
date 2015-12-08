package pecl2;
import java.io.*;
import java.util.Hashtable;

import java_cup.runtime.*;
import pecl2.ProgCompSym;
import static pecl2.ProgCompSym.*;

%%
%{

public static class ProgClass {
    private Hashtable Ident = new Hashtable();
    private Hashtable Funcs = new Hashtable();
    private int numIdent;
    private int numReser;
    private int numNum;
    private int numBools;
    private int numFuncs;
    private int ErrorsScan;
    private String error;
    private String key;


    //construtor
    public ProgClass() {
        this.numIdent = 0;
        this.numReser = 0;
        this.numNum = 0;
        this.numBools = 0;
        this.numFuncs = 0;
        this.ErrorsScan = 0;
        this.error = new String();
        this.key = new String();
        
    }

    public boolean putIdent(String k, String v){
        if (Ident.containsKey(k)) {
            return false;
        } else {
            Ident.put(k,v);
            return true;
        }
    }
    
	public boolean putFuncs(String k, String v){
        if (Funcs.containsKey(k)) {
            return false;
        } else {
            Funcs.put(k,v);
            return true;
        }
    }
        
    public boolean remIdent(String k){
        if (Ident.containsKey(k)) {
            Ident.remove(k);
            return true;
        } else {
            return false;
        }
    }

	public boolean remFuncs(String k){
        if (Funcs.containsKey(k)) {
            Funcs.remove(k);
            return true;
        } else {
            return false;
        }
    }
    
    //getters
    public int getNumErrorsScan() {
        return ErrorsScan;
    }

    //metodos add
    public void incIdent() {
        numIdent += 1;
    }
    public void decIdent() {
        numIdent = numIdent - 1;
    }
    public void incReser() {
        numReser += 1;
    }
    public void decReser() {
        numReser = numReser - 1;
    }
    public void incNum() {
        numNum += 1;
    }
    public void decNum() {
        numNum = numNum - 1;
    }
    public void incBools() {
        numBools += 1;
    }
    public void decBools() {
        numBools = numBools - 1;
    }
    public void incFuncs() {
        numFuncs += 1;
    }
    public void decFuncs() {
        numFuncs = numFuncs - 1;
    }   
    public void incScanErrors() {
        ErrorsScan += 1;
    }
	
	public String sugerirPalabra(String s){
		String palabra = new String();
		int coincidenciasAux=0;
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("diccionario.dic"));
		    String linea = br.readLine();
		    while (linea != null) {
		    	int coincidencias = 0;
		        linea = br.readLine();
		        for (int i = 0; i < s.length(); i++){
					if (linea.contains(s.charAt(i)+"")){coincidencias++;}
				}
		        if (coincidencias > coincidenciasAux)
		        {
		        	coincidenciasAux = coincidencias;
		        	palabra = linea;
		        }
		    
		    }
		}catch(Exception e){
		} finally {
		    try {
				br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(palabra.isEmpty()){
			palabra = "no se encontraron coincidencias";
		}
		return palabra;
	}

    //toString
    public String toString() {
        return 
        "\n -------------ANÁLISIS LÉXICO-------------"+
        "\nIdentificadores: " + Ident.keySet().toString() +
        "\n\t Número de identificadores encontrados: " + numIdent +
        "\n Número de palabras reservadas: " + numReser +
        "\n Número de integers: " + numNum +
        "\n Número de booleanos: " + numBools +
        "\n Funciones: " + Funcs.keySet().toString() +
        "\n\t Número de funciones encontradas: " + numFuncs +
        "\n Numero de errores ........: " + this.getNumErrorsScan()+
        "\n -------------FIN ANÁLISIS LÉXICO-------------";
    }
}
ProgClass prog = new ProgClass();
%}

identificador = [A-Za-z]+([A-Za-z0-9_])*
mas = "+"
menos = "-"
igual = "="
flecha = "->"
operadores = {mas}|{menos}|{igual}|{flecha}
coma = ","
puntocoma = ";"
abparentesis = "("
cerparentesis = ")"
signos = {coma}|{puntocoma}|{abparentesis}|{cerparentesis}
integer = [+-]?[0-9]+
booleans = {TRUE}|{FALSE}
funcion = "$"{identificador}
PROGRAM = [Pp][Rr][Oo][Gg][Rr][Aa][Mm]
VARDECL = [Vv][Aa][Rr][Dd][Ee][Cc][Ll]
INTEGER = [Ii][Nn][Tt][Ee][Gg][Ee][Rr]
BOOLEAN = [Bb][Oo][Oo][Ll][Ee][Aa][Nn]
FUNCTION = [Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
RETURN = [Rr][Ee][Tt][Uu][Rr][Nn]
TRUE = [Tt][Rr][Uu][Ee]
FALSE = [Ff][Aa][Ll][Ss][Ee]
BEGIN = [Bb][Ee][Gg][Ii][Nn]
END = [Ee][Nn][Dd]

%ignorecase
%line
%unicode
%char
%column
%state estadoComentario, estadoError, estadoToken
%class ProgCompLex
%cupsym pecl2.ProgCompSym
%cup





%eof{
	System.out.println(prog.toString());
%eof}

%integer
%%

<YYINITIAL>					"//"               {yybegin(estadoComentario);}
<estadoComentario>			.                         {/* NADA */}
<estadoComentario>			[ \t\r\f]               {/* NADA */}
<estadoComentario>			[\n]              {yybegin(YYINITIAL);}

<YYINITIAL>					{PROGRAM}             {yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
													prog.incReser();
													return new Symbol (TK_PROGRAM, yyline + 1, yychar, yytext());}
														
<YYINITIAL>                 {VARDECL}                 {prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_VARDECL, yyline + 1, yychar, yytext());}
															
<YYINITIAL>          		{INTEGER}           	  	{prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_TIPOINTEGER, yyline + 1, yychar, yytext());}
															
<YYINITIAL>          		{BOOLEAN}             		{prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_TIPOBOOLEAN, yyline + 1, yychar, yytext());}
															
<YYINITIAL>                 {BEGIN}             		{prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_BEGIN, yyline + 1, yychar, yytext());}
														
<YYINITIAL>          		{END}              			{prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_END, yyline + 1, yychar, yytext());}
														
<YYINITIAL>                 {FUNCTION}                   {prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_FUNCION, yyline + 1, yychar, yytext());}
															
<YYINITIAL>					{RETURN} 					{prog.incReser();
														yybegin(estadoToken);
														prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         return new Symbol (TK_RETURN, yyline + 1, yychar, yytext());}

<YYINITIAL>                {funcion}                     {prog.incFuncs();
															prog.key = "";
                                                         	prog.key = yytext();
															prog.error = "";
                                                         	prog.error = prog.error + yytext();
															yybegin(estadoToken);
                                                        	if(!prog.putFuncs(yytext(),yytext())){prog.decFuncs();}
                                                        	return new Symbol (TK_NOMBRE, yyline + 1, yychar, yytext());}
<YYINITIAL>					{integer}					{prog.incNum();
														prog.error = "";
                                                         prog.error = prog.error + yytext();
														yybegin(estadoToken);
														return new Symbol (TK_INTEGER, yyline + 1, yychar, yytext());}
<YYINITIAL>					{booleans}					{prog.incBools();
														prog.error = "";
                                                         prog.error = prog.error + yytext();
														yybegin(estadoToken);
														return new Symbol (TK_BOOLEAN, yyline + 1, yychar, yytext());}
														
<YYINITIAL>					{mas}						{return new Symbol (TK_SUMA, yyline + 1, yychar, yytext());}
<YYINITIAL>					{menos}						{return new Symbol (TK_RESTA, yyline + 1, yychar, yytext());}
<YYINITIAL>					{igual}						{return new Symbol (TK_IGUAL, yyline + 1, yychar, yytext());}
<YYINITIAL>					{flecha}					{return new Symbol (TK_FLECHA, yyline + 1, yychar, yytext());}

<YYINITIAL>					{coma}						{return new Symbol (TK_COMA, yyline + 1, yychar, yytext());}
<YYINITIAL>					{puntocoma}					{return new Symbol (TK_PUNTOCOMA, yyline + 1, yychar, yytext());}
<YYINITIAL>					{abparentesis}				{return new Symbol (TK_PARENTESIS1, yyline + 1, yychar, yytext());}
<YYINITIAL>					{cerparentesis}				{return new Symbol (TK_PARENTESIS2, yyline + 1, yychar, yytext());}

<YYINITIAL>               	[ \t\r\n\f]  	            {/* NADA */}

<YYINITIAL>          		{identificador}		      	{prog.incIdent();
															if(!prog.putIdent(yytext(),yytext())){};
															prog.key = "";
                                                         	prog.key = yytext();
															prog.error = "";
                                                         	prog.error = prog.error + yytext();
															yybegin(estadoToken);
															return new Symbol (TK_IDENT, yyline + 1, yychar, yytext());}

<YYINITIAL>                 .                          {System.err.print("-> Error léxico en la línea "+(yyline+1)+" en el elemento: ");
                                                         prog.error = "";
                                                         prog.error = prog.error + yytext();
                                                         yybegin(estadoError);}
                                                         
<estadoToken>               	[ \t\r\n\f]  	    	{yybegin(YYINITIAL);}

<estadoToken>					{mas}						{yybegin(YYINITIAL);
															return new Symbol (TK_SUMA, yyline + 1, yychar, yytext());}
<estadoToken>					{menos}						{yybegin(YYINITIAL);
															return new Symbol (TK_RESTA, yyline + 1, yychar, yytext());}
<estadoToken>					{igual}						{yybegin(YYINITIAL);
															return new Symbol (TK_IGUAL, yyline + 1, yychar, yytext());}
<estadoToken>					{flecha}					{yybegin(YYINITIAL);
															return new Symbol (TK_FLECHA, yyline + 1, yychar, yytext());}

<estadoToken>					{coma}						{yybegin(YYINITIAL);
															return new Symbol (TK_COMA, yyline + 1, yychar, yytext());}
<estadoToken>					{puntocoma}					{yybegin(YYINITIAL);
															return new Symbol (TK_PUNTOCOMA, yyline + 1, yychar, yytext());}
<estadoToken>					{abparentesis}				{yybegin(YYINITIAL);
															return new Symbol (TK_PARENTESIS1, yyline + 1, yychar, yytext());}
<estadoToken>					{cerparentesis}				{yybegin(YYINITIAL);
															return new Symbol (TK_PARENTESIS2, yyline + 1, yychar, yytext());}

<estadoToken>               	{funcion}  	       		{System.err.print("-> Error léxico en la línea "+(yyline+1)+" en el elemento: ");
                                                         prog.error = prog.error + yytext();
                                                         yybegin(estadoError);}
<estadoToken>               	{integer}  	           	{System.err.print("-> Error léxico en la línea "+(yyline+1)+" en el elemento: ");
                                                         prog.error = prog.error + yytext();
                                                         yybegin(estadoError);}
<estadoToken>               	{identificador}  	    {System.err.print("-> Error léxico en la línea "+(yyline+1)+" en el elemento: ");
                                                         prog.error = prog.error + yytext();
                                                         yybegin(estadoError);
                                                         } 
<estadoToken>               	{booleans}  	         {System.err.print("-> Error léxico en la línea "+(yyline+1)+" en el elemento: ");
                                                         prog.error = prog.error + yytext();
                                                         yybegin(estadoError);}                                                        
<estadoToken>               	.  	            		{System.err.print("-> Error léxico en la línea "+(yyline+1)+" en el elemento: ");
                                                         prog.error = prog.error + yytext();
                                                         yybegin(estadoError);}


<estadoError>               [ ,;\t\r\n\f]               {System.err.print(prog.error);
														System.err.print(" quizá quiso decir: "+ prog.sugerirPalabra(prog.error)+"\n");
															prog.incScanErrors();
                                                         	yybegin(YYINITIAL);
                                                         	if(!prog.key.isEmpty()){if(prog.Ident.containsKey(prog.key)){prog.remIdent(prog.key);prog.decIdent();}
                                                         	if(prog.Ident.containsKey(prog.key)){prog.remFuncs(prog.key);prog.decFuncs();}}}
                                                         	
<estadoError>               [^ ;\t\r\n\f]               {prog.error = prog.error + yytext();}