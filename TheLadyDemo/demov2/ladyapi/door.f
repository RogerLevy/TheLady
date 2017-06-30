%actor begets %door
   noop: ondoor
   \ 0.95 z !
endp

: use-door   { ondoor @ execute } ;

: ?door   doors ?collideany ;

: hide-doors   [[ @ { y @ 16384.0 or y ! } ]] doors each ;

: reveal-doors  [[ @ { y @ 16340.0 1 - and y ! } ]] doors each ;

%room reopen
   %door var: doortype
endp

100 bud !   \ make doors consistent

: door{  ( ondoor-xt -- )
   pen >x @ ground at doortype @ one { ondoor ! 400.0 600.0 between 0 +at  me doors push ;    \ }

: *doors   ( ondoor-xt n -- ) for dup door{ } next drop ;
