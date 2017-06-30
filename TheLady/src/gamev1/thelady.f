
fload initwindow   \ just initiates the window, doesn't compile anything.
>ide

\ ---------------------------------------------------------------------------
\ Load engine

fload ..\engine\engine

!home 

\ ---------------------------------------------------------------------------
\ Game variables and constants

defer reset    ' noop is reset
defer /player  ' noop is /player
defer player/  ' noop is player/

0.5 value gravity

variable can-pause

variable lives   3 lives !
30 constant lady-maxhp
30 constant lady-startinghp


0 value bg          \ billboard
0 value fg           \ same
create bgchildren 30 stack,
create fgchildren 10 stack,
0 value player
0 value focus  \ what the camera should follow
: -focus   0 to focus ;
create doors 30 stack,

create bounds   0 , 0 , vres 2@ 2p 2,

variable camofs

variable invincibility

: bit   dup constant 2 * ;

1
bit C_SHOOTABLE  \ can be shot with souls
bit C_ILLUSION   \ seems to hurt you but really doesn't
bit C_HARMFUL    \ actually hurts you
bit C_PLAYERPROJECTILE
bit C_PLAYER
bit C_WEAK       \ is hurt just by touching the player (atk value)
bit C_REPEL      \ propels the player back with a lot of force
bit C_EXCITABLE
bit C_BLACKLADY
drop


\ stacking orders  - this could be automated by using the Forth dictionary.order
-100000 constant =bg
500 constant =redflash
500 constant =lightning
503 constant =bgbird
548 constant =stakehead 
549 constant =bgrain
550 constant =door
600 constant =barbwire
800 constant =boss
800 constant =blacklady
900 constant =darkness
999 constant =bloodrenderer
1000 constant =lady
2000 constant =shard
10000 constant =fg
10001 constant =fgrain
20000 constant =ui
30000 constant =solidoverlay
40000 constant =static


-2 constant =starrysky
1 constant =arcadelady
2 constant =arcadefire
3 constant =retroboss
4 constant =spinnylaser

\ Z values
0.8 value zbg

\ ---------------------------------------------------------------------------
\ Common assets

fload commonassets

\ ---------------------------------------------------------------------------
\ Load game specific API

fload ladyapi

\ Loading screen
fload loader

\ Lady's level based emotions
calm 1 +
   enum l1r1:|
   enum l1r2:|
   enum l1r3:|
   enum l1boss:|
   enum l4:|
   enum l4boss:|
   enum l4scared:|
   enum l4suck:|
   enum l5:|
   enum l2:|
   enum l3:|
drop

\ ---------------------------------------------------------------------------
\ Stuff just for testing

image l1bg.image data\l1misc\l1bg.jpg
: clear   clean l1bg.image setbg ;

\ ---------------------------------------------------------------------------
\ Lady stuff

fload lady

view 0.5 1.0 around at %lady one constant lady
%soul lady >weapon1 !

: /lady   lady control  lady restart  =lady lady >priority !  ; \ lady { be-rightside-up } ;
: lady/   0 control  lady disable ;

' lady/ is player/
' /lady is /player

/player
lady be

