
\ test
" main.scml" spriter-schema value mainscml

mainscml use-scml
gfx-prompt
400.0 100.0 at
0 0 0 draw-scml-animation

variable e
variable a

1e 100e f/ fvalue speed


: testywesty-frame
   0 cls  vres 2@ 2s>p 0.5 0.5 2p* at
   e @ a @ fdup f>s draw-scml-animation
   show-frame poll-keyboard ;

: testywesty
   res 2@ set-viewport
   >gfx 0e
   begin
      ['] testywesty-frame exectime s>f 0.001e f* speed f* f+
   <escape> kpressed until
   >ide ;

cr
report( === SPRITER TESTING PROGRAM === )
report( Use the following command to view other animations: )
report( <entity#> <animation#> anim )
cr
report( Animations: [To see the list of animations again type "list".] )

also ~spriter
: list
   0 0 locals| e a |
   [[ @
      0 to a
      [[ @ => report" '" e . a . ." anim' -> " name count type space  1 +to a ]] swap >animations each
      1 +to e
   ]] scml >entities each ;
previous

list

: anim   a ! e ! testywesty ;
: rld   " main.scml" spriter-schema dup to mainscml use-scml ; 

pushpath
500 ms
testywesty