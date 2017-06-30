

pstruct %fcmgr
   \ this is the default # of max entities that can be put in the grid.
   \ it determines the bulk of the RAM taken up by the manager.
   \ one big reason for having multiple managers: separate managers for characters, projectiles, particles, and environment.  
   
   max-entities var: maxboxes
   [i

\ these vars and constants aren't actually needed - bitshift and mask take care of it
\ grid size and "granularity" is fixed.  128x128 squares each 128x128 in size.
\ - the effective square size can be made smaller by left-bitshifting the 2 coordinates of all the cgridbox's
\   added to it.  dividing by 2 (bitshift left 1) would give a virtual square size of 64x64, useful for bullet hell or particles.
\ 
\   128 var: cols
\   128 var: rows
\   128 constant sectw
\   128 constant secth
   7 constant bitshift
   $ffffff80 constant mask

   0
      cell field x
      cell field y
      cell field a   \ right
      cell field b   \ bottom
      cell field s1   \ sector 1
      cell field s2   \ ...
      cell field s3
      cell field s4
   i]
   constant /cgridbox
   [i
   var sectors
   var links
   var i.link   \ points to structure in links:   link to next ( i.link , box , )
   var lastsector
   variable topleft
   variable topright
   variable btmleft
   
   \ create sectors cols rows * cells /allot
   \ create links   maxobj 4 * 2 cells * /allot

   : sector   ( x y -- addr )
      mask and swap bitshift >> + cells sectors @ + ;
      
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
   
   \ -------------------------------------------------------------------------

   \ really slow
   \ : 4@   a!> @+ @+ @+ @+ ;
   
   i]

   : box>box?   ( box1 box2 -- box1 box2 f )
      2dup = if false exit then \ boxes can't collide with themselves!
      2dup >r 4@ r> 4@ overlap? ;

   defer grid-collide  ' 2drop is grid-collide   ( box1 box2 -- )

   [i

   \ -------------------------------------------------------------------------
   
   : box>sector   ( box1 sector -- ) swap >r
      begin @ dup while
         dup cell+ @ r@ swap box>box? if grid-collide else 2drop then
      repeat
      r> drop drop ;
   
   : ?box>sector   ( box1 sector? -- ) dup if box>sector else drop drop then ;
   
   \ -------------------------------------------------------------------------
      
   CODE ifill ( c-addr u char -- )
      0 [EBP] ECX MOV   ECX ECX TEST       \ Get count, skip if 0
      0= NOT IF   4 [EBP] EDX MOV          \ Get string addr
         BEGIN   EBX 0 [EDX] MOV            \ Write char
         4 # EDX ADD   ECX DEC   0= UNTIL      \ Increment pointer, loop
      THEN   8 [EBP] EBX MOV               \ Drop parameters
      12 # EBP ADD  RET   END-CODE
   
   : ierase   0 ifill ;
   
   
   
   : ?topleft  sector dup topleft ! true ;
   : ?topright sector 
               topleft @ over = if drop 0 exit then dup topright ! true ;
   : ?btmleft  sector 
               topleft @ over = if drop 0 exit then dup btmleft ! true ;
   : ?btmright sector 
               topright @ over =
               over btmleft @ = or if drop 0 exit then true ;

   i]

   : reset-fcmgr ( struct=fcmgr;  -- )
      sectors @ cols 2@ * ierase
      links @ i.link ! ;   
   
   : add-box  ( struct=fcmgr; box -- )
      struct locals| fc |
      ( box ) =>
      x @ y @ fc -> ?corner if dup s1 ! struct swap link else s1 off then
      a @ y @ fc -> ?corner if dup s2 ! struct swap link else s2 off then
      x @ b @ fc -> ?corner if dup s4 ! struct swap link else s4 off then
      a @ b @ fc -> ?corner if dup s3 ! struct swap link else s3 off then
      ( topleft off topright off btmleft off ) fc >lastsector off ;

   \ note: box must be added before checking against the grid, as adding the box 
   \ determines which sector(s) it is in.   
   : check-grid   ( struct=fcmgr; box1 -- )
      dup dup >s1 @ ?box>sector
      dup dup >s2 @ ?box>sector
      dup dup >s3 @ ?box>sector
          dup >s4 @ ?box>sector ;

   : fcmgr,   ( maxboxes -- )
      %fcmgr build>  here sectors ! 128 128 * cells /allot
                     dup maxboxes ! here links ! 4 * 2 cells * /allot
                     
endp

