=====[ Specifications ] =================================
IMPORTANT: Your code has to follow the specifications below:
1. Implement the "B.run" function in b.ml.
2. Do not modify the module type of B. 
3. You can freely change the implementation part (module B).
4. You code should be compiled.
5. Use the OCaml's "read_int" function for implementing the read expression:
http://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
6. When implementing expression "write e", print the value of e and then print a newline 
character ('\n') as well. Furthermore, when the value of e is not an integer, you have 
to raise the Error exception, instead of printing the value. 
7. During execution, you should raise the Error execption whenever the semantics is undefined.
Any strings are allowed to be accompanied with Error exceptions.

(In Korean)
+ b.ml 파일의 B.run 함수를 구현하시면 됩니다. module type들의 정의는 수정을 금지하며, 모듈의 구현 부분은 자유롭게 수정하셔도 됩니다. 최종적으로 제출할 때는 make에 의해 정상적으로 컴파일되는 상태로 제출해 주시기 바랍니다. 

+ read semantics 구현은 ocaml의 read_int 함수를 사용합니다.
http://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html

+ write 명령을 실행할 때, 정수를 출력 후 개행문자(newline, \n)를 출력하는 것을 잊지 말아주시기 바랍니다. 그리고 write 할 값이 정수일 경우에만 출력하고, 그 외의 경우에는 예외를 내야 합니다. 

+ B.run 의 최종 결과값은 출력 대상이 아닙니다. 입출력은 read/write 로만 이루어집니다.

+ 실행하는 도중 '정의되지 않은 의미'를 만나면 모두 Error 예외를 냅니다. 예를 들어, 함수 호출 시에 전달하는 인자의 개수가, 함수 정의 시의 인자 개수와 일치하지 않는다거나, 정수와 Bool 값을 더하는 연산을 하려 든다거나 하는 경우 Error 예외를 내시면 됩니다. Error 예외의 인자로 쓸 문자열은 자유롭게 정하시면 됩니다.

=====[ Lexical Specification ] =========================
Identifiers in B are specified by regular expression [a-zA-Z][a-zA-Z0-9_]*.
Identifiers are case sensitive: z and Z are different.
The reserved words are cannot be used as identifiers: unit, true, false, 
  not, if, then, else, let, in proc, while, do, read, write

Numerical integers optionally prefixed with -(for negative integer): -?[0-9]+.

A comment is any character sequence within the comment block (* *). 
Comments can be nested.

=====[ Precedence ]======================================
The precedence of B constructs in decreasing order is as follows:

   .      (right-associative)
   not    (right-associative)
   *, /   (left-associative)  
   +, -   (left-associative) 
   =, <   (left-associative)
   write  (right-associative)
   :=     (right-associative)
   else   
   then
   do
   ;      (left-associative)
   in     

Examples:

  x := e1 ; e2        =>    (x := e1) ; e2   ( := has higher precedence thatn ;)
  while e do e1;e2    =>    (while e do e1);e2 
  if e1 then e2 else e3;e4    =>    (if e1 then e2 else e3); e4
  let x := e1 in e2 ; e3      =>    let x :=e in (e2;e3) 
  x := y := 1    =>   x := (y := 1) 

If your test programs are hard to read (hence can be parsed not as you expected) then 
put parentheses around.


=====[ Compilation and Execution]=========================
Implement functions in b.ml. Then, compile and execute the interpreter as follows:

1. make
2. run examples/test1.k-


====[ How to submit ] ===================================
Submit the single file "b.ml" via Blackboard.
You should not modify any files other than b.ml.


=====[ pretty-printer ] =================================
A pretty-printer is provided. 
The following command 

run -pp test1.k-

will print the parse tree of the program test1.k-.
