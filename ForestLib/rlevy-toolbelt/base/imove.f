[defined] x86 [if]
  CODE imove ( from to count -- )
    EBX EBX TEST   0= NOT IF
      0 [EBP] EDX MOV   4 [EBP] ECX MOV
      BEGIN   0 [ECX] EAX MOV   EAX 0 [EDX] MOV
      4 # ECX ADD  4 # EDX ADD   EBX DEC   0= UNTIL
    THEN   8 [EBP] EBX MOV   12 # EBP ADD
  RET   END-CODE

  CODE ifill ( c-addr count val -- )
    0 [EBP] ECX MOV   ECX ECX TEST     \ Get count, skip if 0
    0= NOT IF   4 [EBP] EDX MOV       \ Get string addr
      BEGIN   EBX 0 [EDX] MOV         \ Write char
      4 # EDX ADD   ECX DEC   0= UNTIL     \ Increment pointer, loop
    THEN   8 [EBP] EBX MOV           \ Drop parameters
    12 # EBP ADD  RET   end-code
[else]
  : imove  cells move ;
  : ifill  -rot swap a!> 0 ?do dup !+ loop drop ;
[then]

: ierase   0 ifill ;
