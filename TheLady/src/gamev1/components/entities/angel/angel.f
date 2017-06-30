\ relies on:
\  bladewall  ( the value )
\  bladewall:startboss 

0 value angel

\ image light1.image data/angel/light1.png
image light2.image data/angel/light2.png
image light3.image data/angel/light3.png
image light4.image data/angel/light4.png

create lightimages cell [array light3.image , light2.image , light3.image , light4.image , array]

animdata angel.scml data/angel/animdata/lvl 4 boss.scml
angel.scml animation angel_spinning1 spinning head fast
angel.scml animation angel_spinning2 spinning head slower
angel.scml animation angel_idle idle

: draw-aura
   dspt s!
   0.5 0.85 pivot 2!   5.0 uscale!
   x 3@ scrolled -500.0 0 2+ at
   FX_SCREEN colorfx
   lifetime @ 6 / 3 and lightimages [] @ entire dspt blitrgnexp ;


%boss ~> %angel
   hitbox: -200.0 -1000.0 400.0 1000.0 ;
   [[ draw-aura 1.0 uscale! actor:spriter ]] ondraw !
   editable on
   =boss priority !
   angel_idle
   start:    me to angel idle ;
   
endp


\ once awoken...
%angel ~> %angelboss

  
   :: idle
      angel_idle 
      0 perform
      player 1200 close? when angel_spinning2
      act player 600 close? when angel_spinning1
      nod ;

   start:  idle ;
         
endp