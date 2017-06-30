\ 11/19/13
\ relies on:
\ z

\ module ~parallax

create vres 2048 , 1152 ,

create cam 0 , 0 ,   \ represents center focal point of viewport (which is vres size)

create viewm 16 cells allot

variable viewfactor    1.0 viewfactor !   \ default

: vw   vres @ ;
: vh   vres cell+ @ ;

: svh  vh 1p viewfactor @ p*  ;  \ scaled vh

variable topoffset

: calc-viewport
   displaywh 2p locals| h w |
   w 2 +  vw 1p   p/  dup viewfactor !

   ( scale ) p>f fdup viewm al_scale_transform

   h 2 /   svh 2 /  -   dup topoffset !
      dup  -1e p>f viewm al_translate_transform

   viewm al_use_transform

   ( y ) 2 swap 1i 2 +  w svh 2i 4 4 2- al_set_clipping_rectangle
;

: update-viewport
   \ viewm al_identity_transform 
   \ viewm al_use_transform
   viewm al_identity_transform calc-viewport ;

: clear-viewport
   viewm dup al_identity_transform al_use_transform
   0 0 displaywh al_set_clipping_rectangle ;

\ note that x and y are don't behave like they would in 3D and always map to virtual pixels
: scrolled ( x. y. factor. -- x. y. )
   1.0 cam 2@ 2p* 2- ;

: unscrolled ( x. y. factor. -- x. y. )
   1.0 cam 2@ 2p* 2+ ;


: view     ( -- xywh ) cam 2@ vres 2@ 2p ;
: screen   ( -- xywh ) 0 0 vres 2@ 2p ;

: letterbox!   1i vres >y ! ;   
