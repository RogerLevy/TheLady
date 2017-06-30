\ Flow
\  Used to allow stringing-together of independent experiences

\ WIP

0 value part
: part! to part ;
: part-fields  [[ create over , + does> @ part + ]] is create-ifield   prototype part! ;


pstruct: %segment
   [[ part-fields ]] fields
   noop: (proceed)
   noop: (backout)
   noop: (branch)
endp

0 value flowpos
create flowstack 10 stack,

: proceed ;
: backout ;
\ Numbered branches (yes/no etc)
: branch ; 

: segment
   %segment { ;