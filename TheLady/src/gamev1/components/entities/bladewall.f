0 value bladewall

sample *scissors1* data/bladewall/scissors fast.ogg
sample *scissors2* data/bladewall/scissors medium.ogg
sample *scissors3* data/bladewall/scissors slow.ogg

animdata bladewall.scml   data\bladewall\blade wall.scml
bladewall.scml animation bladewall_1 slow
bladewall.scml animation bladewall_2 attacking violently
bladewall.scml animation bladewall_3 attacking smoother


%actor ~> %bladewall 
   var bladesnd
   editable on 
   1001 priority !
   bladewall_1
   hitbox: 0 vh negate 1p 380.0  vh 1p ;
   
   
   [i
   \ attack the player if they get close
   :: attack   bladewall_2 perform 8.0 vx ! 0.4 delay -8.0 vx ! 0.4 delay chase ;
   : ?attack   dup me 700.0 closeby? if attack else drop then ; 
   :: chase   bladewall_1 perform dup ?attack ;
   
   : creep-   cam @ over - x ! 3.0 - ;
   :: intro   1000.0 perform creep- dup 203.0 <= if player chase then ;
   
   : ?vol   bladesnd @ snd! me player xdist 2000.0 p/ 0 1.75 clamp 1.75 swap - sndvol! ;

   : got-er   report" GOT 'ER" bladewall_2 halt me player { bladewall-hurt } nod ;
   : ?player   me player colliding? if got-er then ;
   
   : snd/   bladesnd @ ?dup if stopsound bladesnd off then ;
   : /snd   snd/ snd bladesnd ! -0.7 sndpan! 0.0 sndvol! ;
   
   : (post)  post ?vol ?player ;
   
   :: idle   bladewall_1 looping *scissors3* /snd (post) 0 perform noop ; 
   
   start:   me to bladewall idle ;
   
   ondelete:   snd/ ;
   
   i]
endp


   
   \ : bladewall:post2 snd/ looping *scissors3* /snd post ?vol ?player ;
