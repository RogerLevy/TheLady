\ ==============================================================================
\ ForestLib
\ Fast collision manager object.  Does efficient AABB collision checks of massive
\ numbers of rectangles.
\ ========================= copyright 2014 Roger Levy ==========================

0 value fcmgr

pstruct %fcmgr

  [i   
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


  : fcmgr-fields  [[ create over , + does> @ fcmgr + ]] is create-ifield ;
  [[ fcmgr-fields ]] fields

  [i
    \ used by RESET-FCMGR
     128 var: cols
     128 var: rows
    
     128 constant sectw
     128 constant secth

    \ these vars and constants aren't needed for getting a sector from a coordinate - bitshift and mask take care of it
    \ grid size and "granularity" is fixed.  128x128 squares each 128x128 in size.
    \ - the effective square size can be made smaller by left-bitshifting the 2 coordinates of all the cgridbox's
    \   added to it.  dividing by 2 (bitshift left 1) would give a virtual square size of 64x64, useful for bullet hell or particles.
   i]
  
  [i
     var sectors
     var links
     var i.link   \ points to structure in links:   link to next ( i.link , box , )
     var lastsector
     variable topleft
     variable topright
     variable btmleft
  
    : sector   ( x y -- addr )
       mask and swap bitshift >> + cells sectors @ + ;
      
    : link   ( box sector -- )
      >r
       i.link @ cell+ !    \ 1. link box
       r@ @ i.link @ !    \ 2. link the i.link to address in sector
       i.link @ r> !      \ 3. store current link in sector
       2 cells i.link +! ;  \ 4. and increment current link
  
  
    \ not the best algorithm ....
    : ?corner   ( x y -- 0 | sector )
       sector dup lastsector @ = if drop 0 exit then dup lastsector ! ;
    
\    : ?topleft  sector dup topleft ! ;
\    : ?topright sector 
\             topleft @ over = if drop 0 exit then dup topright ! ;
\    : ?btmleft  sector 
\             topleft @ over = if drop 0 exit then dup btmleft ! ;
\    : ?btmright sector 
\             topright @ over =
\             over btmleft @ = or if drop 0 exit then ;
    
  
   i]


  : box>box?  ( box1 box2 -- box1 box2 flag )
     2dup = if false exit then \ boxes can't collide with themselves!
     2dup >r 4@ r> 4@ overlap? ;

   defer grid-collide  ' 2drop is grid-collide   ( box1 box2 -- ) \ box1 is the passed in box


  [i
    
    : box>sector   ( box1 sector -- )
       swap >r
       begin @ dup while
         dup cell+ @ r@ swap box>box? if grid-collide else 2drop then
       repeat
       r> drop drop ;
    
    : ?box>sector   ( box1 sector|0 -- ) ?dup if box>sector else drop then ;
    
    \ -------------------------------------------------------------------------
    
    : ?topleft  sector dup topleft !  ;
    : ?topright sector 
             topleft @ over = if drop 0 exit then dup topright !  ;
    : ?btmleft  sector 
             topleft @ over = if drop 0 exit then dup btmleft !  ;
    : ?btmright sector 
             topright @ over =
             over btmleft @ = or if drop 0 exit then ;

   i]

  : reset-fcmgr ( fcmgr=fcmgr;  -- )
     sectors @ cols 2@ * ierase
     links @ i.link ! ;  
  
  : add-box  ( fcmgr=fcmgr; box -- )
    ( box ) =>
     x @ y @ ?corner ?dup if dup s1 ! s@ swap link else s1 off then
     a @ y @ ?corner ?dup if dup s2 ! s@ swap link else s2 off then
     x @ b @ ?corner ?dup if dup s4 ! s@ swap link else s4 off then
     a @ b @ ?corner ?dup if dup s3 ! s@ swap link else s3 off then
    ( topleft off topright off btmleft off ) lastsector off ;

  \ note: box must be added before checking against the grid, as adding the box 
  \ determines which sector(s) it is in.  
  : check-grid   ( fcmgr=fcmgr; box1 -- )
     dup dup >s1 @ ?box>sector
     dup dup >s2 @ ?box>sector
     dup dup >s3 @ ?box>sector
       dup >s4 @ ?box>sector ;
    
  [i
    : corners
      =>
       x @ y @ ?corner
       a @ y @ ?corner 
       x @ b @ ?corner 
       a @ b @ ?corner lastsector off
      ;
   i]
  
  \ this version doesn't require the box to be added beforehand
  : check-box   ( fcmgr=fcmgr; box1 -- )
     dup >r corners r@ swap ?box>sector
               r@ swap ?box>sector
               r@ swap ?box>sector
               r> swap ?box>sector ;
    
    
  : fcmgr!  to fcmgr ;

  : fcmgr,  ( maxboxes -- )
    %fcmgr instantiate fcmgr!
       here sectors ! 128 128 * cells /allot
       here links ! 4 * 2 cells * /allot ;

  : cgridwidth   cols @ sectw * ;
  : cgridheight   rows @ secth * ;
endp

