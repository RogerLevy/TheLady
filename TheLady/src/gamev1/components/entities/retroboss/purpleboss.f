image purplehead.image data/retroboss/heads/l2boss64.png


create sightzone   -50.0 , 0 , 50.0 , 2000.0 ,

: in-sight?    ( actor -- f ) >r sightzone box/actor r> { hitbox> } overlap? ;
: proximity    ( actor -- n ) >x 2@ x 2@ 2- 2length 1i ;
: approaching? ( actor -- f ) dup proximity >r { x 2@ vx 2@ 2+ } x 2@ 2- 2length r> < ;
: danger       ( prototype -- n ) allof avgpos x 2@ 2- 2length 1i ;
\ : -1?1         if 1 else -1 then ;
: ?+!   swap if ++ else off then ;



create tempa 1000 stack,

: sorted   >r tempa vacate tempa pushes r> tempa sort tempa ;

: highest      ( ... n -- val )
   ['] < sorted pop ;

: highestvar      ( ... n -- var )
   [[ 2@ < ]] sorted pop ;

\ [[ n ['] action ]] [[ n ['] action ]] n
: decision ( ... n -- )
   [[ execute drop swap execute drop > ]] sorted pop execute execute ;

: ?leftright   2 rnd if left else right then direction ! ;
: switchdir  direction @ left = if right else left then direction ! ;



%retroboss ~> %purpleboss
   30 hp !
   purplehead.image bitmap!
   hitbox: purplehead.image 0.66 scale @ p* center-bitmap-box ;

   [i

   :: die
      once *laser1* 0.5 sndspd!
      cflags off
      0 perform
      5 for
      r>
      1.0 alpha !
      5.0 uscale!
      SINE EASE-IN-OUT alpha 0 30 tween
      SINE EASE-IN-OUT scale >x 10.0 30 tween
      SINE EASE-IN-OUT scale >y 10.0 30 tween
      SINE EASE-IN-OUT angle 360.0 rnd 30 tween
      0.5 delay
      >r next
      end complete ;

   : fire  \ 0 10.0 %bossfire shoot ;
      me -70 70 from %bossfire one { 0 10.0 vx 2! }
      me 60 70 from %bossfire one { 0 10.0 vx 2! } ;

   : fire-and   fire 0 perform 0.3 delay decide ;

   : pigtails
      me -300.0 -150.0 from %spinnyfire one { -7.0 -7.0 vel 2! }
      me 300.0 -150.0 from %spinnyfire one {  7.0 -7.0 vel 2! }
   ;

   :: special
      0 perform
      \ 0.3 delay
      halt -5 0 +put 1 pauses 10 for r> 10 0 +put 1 pauses -10 0 +put 1 pauses >r next
      down direction !
      15.0 forward 0 perform y @ 900.0 >= when
      halt
      \ pigtail shots
      pigtails player >hp @ 5 <= if 0.4 delay pigtails 0.4 delay pigtails then 0.4 delay

      15.0 backward 0 perform y @ 250.0 <= if 250.0 y ! ?leftright walk then ;

   : ?special   hp @ 6 < 2 rnd and dup if special then ;

   :: decide
      report" decide"
      ?special ?exit
      2 rnd if switchdir then  3 rnd case 0 of idle endof 1 of walk endof 2 of fire-and endof endcase ;

   :: hurt   retroboss:hurt   hp @ 6 < hp @ 0 > and if special then ;

   :: walk   hp @ 20 < if fire then report" walk" 10.0 forward 0 perform 0.5 2.0 ~ delay decide ;

   : ?burst   3 rnd if 0 perform fire 0.3 delay fire 0.3 delay fire 0.3 0.6 ~ delay ?leftright walk
              else fire then ;

   :: idle   report" idle"  halt  0 perform
      hp @ 20 < if  0.3 0.4 ~ delay  ?burst  then
      0.3 0.66 ~ delay  ?leftright  walk ;


   i]

   : purpleboss bossbattle setup 1024.0 250.0 at %purpleboss one drop
      0 [[ boss >hp @ 5 = if bgm to snd 0.3 sndspd! then ]] parallel
      ;

endp
