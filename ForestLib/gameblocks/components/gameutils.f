\ ==============================================================================
\ ForestLib > GameBlocks
\ Misc. game related words
\ ========================= copyright 2014 Roger Levy ==========================



\ Matrix stuff

create mymatrix 8 16 * allot
: 2x  \ render everything following at 200% scale
   mymatrix al_identity_transform 
   mymatrix 2e 2e al_scale_transform 
   mymatrix al_use_transform ;

: translate
   mymatrix -rot 2p>f al_translate_transform 
   mymatrix al_use_transform ;


\ Fixed point stuff

aka s>p  1p   aka p>s  1i
aka 2s>p  2p  aka 2p>s  2i
aka 3s>p  3p  aka 3p>s  3i
aka p>s int
aka s>p fixp

: 2p.s   cr 2dup 2p. ;
: 3p.s   cr 3dup 3p. ;
: 4p.s   cr 2over 2p. 2dup 2p. ;

: 2rnd   rnd swap rnd swap ;

\ Sprite batching

: batch[   true al_hold_bitmap_drawing ;
: ]batch   false al_hold_bitmap_drawing ;


\ Bitwise store

: or!   dup @ rot or swap ! ;
: and!   dup @ rot and swap ! ;
: xor!   dup @ rot xor swap ! ;

: ?create   >in @    absent if >in ! create exit then   drop 0 parse 2drop  r> drop ;

: image   ?create 0 parse bl skip bitmap, ;

: 4dup 2over 2over ;

\ get entire bitmap region for blitting
create rgn   0 , 0 , 0 , 0 ,
: entire   dup bitmap-size 2s>p  rgn 2 cells + 2! rgn ;
: pentire   dup bitmap-size 2s>p rgn 2 cells + 2! rgn ;


: lowerupper   2dup > if swap then ;

: between   lowerupper over - 1 + rnd + ;

aka between ~

[[ ]] constant ..


: processpath
   bl skip -trailing   2dup [char] / [char] \ REPLACE-CHAR ;

: namespec  [char] | parse processpath ;

: 1clamp   0.0 1.0 clamp ;

aka area xyxy   \ this is a more logical name

: vary  ( n|. rnd|. -- n|. )
   dup 0.5 p* -rot rnd + swap - ;

: 2vary  rot swap vary >r vary r> ;

: either   2 rnd if drop else nip then ;


\ keyboard arrows
: left?   <left> kstate <pad_4> kstate or ;
: right?  <right> kstate <pad_6> kstate or ;
: up?     <up> kstate <pad_8> kstate or ;
: down?   <down> kstate <pad_2> kstate or ;


\ interpolation utilities
: interp   ( n1|. n2|. factor. -- n3|. )
   >r over - r> p* + ;

: rescale   ( n|. min1|. max1|. min2|. max2|. -- n|. )
   locals| max2 min2 max1 min1 n |
   n min1 - max1 min1 - p/ max2 min2 - p* min2 + ;
   
: smudge  defined if >name 1 erase else drop then ;

: do-:const  does> @ ;
: :xt   create do-:const here 0 , :noname swap ! ;



: around  ( x y w h xf. yf. -- x y )
   2p* 2+ ;

: middle   ( x y w h -- x y )
   0.5 0.5 around ;

: somewhere  ( x y w h -- x y )
   2rnd 2+ ;

: overlap? ( xyxy xyxy -- flag ) 2swap 2rot rot swap > -rot > or >r rot < -rot swap < or r> or not ;
