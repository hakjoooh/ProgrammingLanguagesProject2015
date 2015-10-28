/*
 * B Interpreter
 */
  

%{       
type declLet = Val of string * B.B.exp
             | Fun of string * string list * B.B.exp

exception EmptyBinding
exception ParsingError
let rec desugarLet: declLet * B.B.exp -> B.B.exp  =
  fun (l, e) -> 
  	match l with
		Val(x, e') -> B.B.LETV(x,e',e)
		| Fun(f,x,e') -> B.B.LETF(f,x,e',e)
let rec desugarVars: declLet list -> (B.B.id * B.B.exp) list =
  fun l ->
  	match l with
	  [] -> []
   | a::r -> 
     (match a with
        Val(x, e') -> (x,e')::(desugarVars r)
      | Fun(f,x,e') -> raise ParsingError)

%}

%token UNIT
%token <int> NUM
%token TRUE FALSE
%token <string> ID
%token PLUS MINUS STAR SLASH EQUAL LB RB LBLOCK RBLOCK NOT COLONEQ SEMICOLON COMMA PERIOD IF THEN ELSE END
%token WHILE DO LET IN READ WRITE PROC
%token LP RP LC RC
%token EOF

%nonassoc IN
%left SEMICOLON
%nonassoc DO
%nonassoc THEN
%nonassoc ELSE
%right COLONEQ
%right WRITE         
%left EQUAL LB  
%left PLUS MINUS
%left STAR SLASH
%right NOT
%left PERIOD

%start program
%type <B.B.exp> program

%%

program:
       expr EOF { $1 }
    ;

expr: 
      LP expr RP { $2 }
	| UNIT {B.B.UNIT}
    | MINUS NUM { B.B.NUM (-$2) }
    | NUM { B.B.NUM ($1) }
    | TRUE { B.B.TRUE }
    | FALSE { B.B.FALSE }
    | LP RP { B.B.UNIT }
    | ID { B.B.VAR ($1) }
    | ID LP exprs RP { B.B.CALLV ($1, $3) }
    | expr PLUS expr { B.B.ADD ($1, $3) }
    | expr MINUS expr  {B.B.SUB ($1,$3) }
    | expr STAR expr { B.B.MUL ($1,$3) }
    | expr SLASH expr { B.B.DIV ($1,$3) }
    | expr EQUAL expr { B.B.EQUAL ($1,$3) }
    | expr LB vars RB { match $1 with B.B.VAR(x) -> B.B.CALLR (x, $3) | _ -> raise ParsingError }
	| expr LB ID RB { match $1 with B.B.VAR(x) -> B.B.CALLR (x, [$3]) | _ -> raise ParsingError }
    | expr LB expr { B.B.LESS ($1,$3) }
    | NOT expr { B.B.NOT ($2) }
    | ID COLONEQ expr { B.B.ASSIGN ($1,$3) }
    | expr SEMICOLON expr { B.B.SEQ ($1,$3) }
    | IF expr THEN expr ELSE expr { B.B.IF ($2, $4, $6) }
    | WHILE expr DO expr { B.B.WHILE ($2, $4) }
    | LET decl IN expr { desugarLet($2, $4) }
    | READ ID { B.B.READ ($2) }
    | WRITE expr { B.B.WRITE ($2) }
	| LC RC { B.B.RECORD [] }
	| LC vardecls RC { B.B.RECORD (desugarVars $2) }
	| expr PERIOD ID COLONEQ expr { B.B.ASSIGNF ($1,$3,$5) } 
	| expr PERIOD ID { B.B.FIELD ($1,$3) }
    ;
vardecl: ID COLONEQ expr { Val ($1, $3) }
	;
vardecls: vardecl { [$1] }
    | vardecl COMMA vardecls { $1::$3 }
    ;
decl: vardecl { $1 }
    | PROC ID LP ID RP EQUAL expr {Fun ($2, [$4], $7)}
    | PROC ID LP vars RP EQUAL expr {Fun ($2, $4, $7)}
    ;
exprs: expr { [$1] }
	| expr COMMA exprs { $1::$3 }
	;
vars : ID COMMA ID { [$1; $3] }
	| ID COMMA vars { $1::$3 }
	;
%%
