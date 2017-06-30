[defined] collisions_new~ [if] \\ [then] 

plugin exposed


protected
5000 constant maxobj

\ note, if you change any of the below, bitshift and mask need to be changed
128 constant gridw
128 constant gridh
128 constant sectw
128 constant secth
7 constant bitshift       \ for the x
$ffffff80 constant mask   \ for the y
\ -----------------------

\ Expected to be INTEGER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
0
   cell field x
   cell field y
   cell field a   \ right
   cell field b   \ bottom
   cell field s1   \ sector 1
   cell field s2   \ ...
   cell field s3
   cell field s4
exposed constant /cgridbox

protected
create sectors gridw gridh * cells /allot
create links   maxobj 4 * 2 cells * /allot
variable i.link   \ points to structure in links:   link to next i.link, box
variable topleft
variable topright
variable btmleft
variable lastsector

: sector   ( x y -- addr )
   ( log2 >> gridw * ) mask and swap bitshift >> + cells sectors + ;

protected

: link   ( box sector -- )
   >r
   i.link @ cell+ !     \ 1. link box
   r@ @ i.link @ !      \ 2. link the i.link to address in sector
   i.link @ r> !        \ 3. store current link in sector
   2 cells i.link +! ;  \ 4. and increment current link

\ not the best algorithm ....
: ?corner   ( x y -- 0 | sector 1 )
   sector dup lastsector @ = if drop 0 exit then dup lastsector ! true ;

: ?topleft  sector dup topleft ! true ;
: ?topright sector 
            topleft @ over = if drop 0 exit then dup topright ! true ;
: ?btmleft  sector 
            topleft @ over = if drop 0 exit then dup btmleft ! true ;
: ?btmright sector 
            topright @ over =
            over btmleft @ = or if drop 0 exit then true ;

\ really slow
\ : 4@   a!> @+ @+ @+ @+ ;

exposed

: box>box?   ( box1 box2 -- box1 box2 f )
   2dup = if false exit then \ boxes can't collide with themselves!
   2dup >r 4@ r> 4@ overlap? ;

\ -------------------------------------------------------------------------
exposed

defer grid-collide  ' 2drop is grid-collide   ( box1 box2 -- )

\ -------------------------------------------------------------------------
protected

: box>sector   ( box1 sector -- ) swap >r
   begin @ dup while
      dup cell+ @ r@ swap box>box? if grid-collide else 2drop then
   repeat
   r> drop drop ;

: ?box>sector   ( box1 sector? -- ) dup if box>sector else drop drop then ;

\ -------------------------------------------------------------------------
exposed

\ box must be added before checking against the grid, as adding the box 
\ determines which sector(s) it is in.

: check-grid   ( box1 -- )
   dup dup >s1 @ ?box>sector
   dup dup >s2 @ ?box>sector
   dup dup >s3 @ ?box>sector
       dup >s4 @ ?box>sector ;


\ : ierase for dup off cell+ next drop ;

CODE ifill ( c-addr u char -- )
   0 [EBP] ECX MOV   ECX ECX TEST       \ Get count, skip if 0
   0= NOT IF   4 [EBP] EDX MOV          \ Get string addr
      BEGIN   EBX 0 [EDX] MOV            \ Write char
      4 # EDX ADD   ECX DEC   0= UNTIL      \ Increment pointer, loop
   THEN   8 [EBP] EBX MOV               \ Drop parameters
   12 # EBP ADD  RET   END-CODE

: ierase   0 ifill ;

: reset-collisiongrid ( -- )
   sectors gridw gridh * ierase
\   links   maxobj 4 * 2 cells *  erase
   links i.link ! ;



: ?topleft  sector dup topleft ! true ;
: ?topright sector 
            topleft @ over = if drop 0 exit then dup topright ! true ;
: ?btmleft  sector 
            topleft @ over = if drop 0 exit then dup btmleft ! true ;
: ?btmright sector 
            topright @ over =
            over btmleft @ = or if drop 0 exit then true ;

: add-box  ( box -- ) 
   =>
   x @ y @ ?corner if dup s1 ! struct swap link else s1 off then
   a @ y @ ?corner if dup s2 ! struct swap link else s2 off then
   x @ b @ ?corner if dup s4 ! struct swap link else s4 off then
   a @ b @ ?corner if dup s3 ! struct swap link else s3 off then
   ( topleft off topright off btmleft off ) lastsector off ;

