all: run

run: lexer.cmo parser.cmo b.cmo pp.cmo main.cmo
	ocamlc -o run lexer.cmo pp.cmo parser.cmo b.cmo main.cmo

b.cmo : b.ml
	ocamlc -c b.ml

pp.cmo : pp.ml b.cmo
	ocamlc -c pp.ml

parser.ml: parser.mly b.cmo
	ocamlyacc parser.mly

parser.mli: parser.mly
	ocamlyacc parser.mly

parser.cmi: parser.mli
	ocamlc -c parser.mli

parser.cmo: parser.ml parser.cmi
	ocamlc -c parser.ml

main.cmo : b.cmo main.ml
	ocamlc -c main.ml

lexer.cmo: lexer.ml
	ocamlc -c lexer.ml

lexer.ml: lexer.mll parser.cmo
	ocamllex lexer.mll

clean:
	rm -f *.cmx *.cmi parser.mli parser.ml lexer.ml run *.o *.cmo
