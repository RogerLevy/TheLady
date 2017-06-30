
fload initwindow   \ just initiates the window, doesn't compile anything.
>ide

\ ---------------------------------------------------------------------------
\ Load engine 

fload engine

\ ---------------------------------------------------------------------------
\ Game variables and constants

0.5 value gravity

0 value bg          \ billboard
0 value fg           \ same
create bgchildren 10 stack,
create fgchildren 10 stack,
0 value player
0 value focus  \ what the camera should follow
create doors 30 stack,

variable rendertime 
variable simtime

create bounds   0 , 0 , vres 2@ 2p 2,

variable camofs
variable show-hitboxes  \ show-hitboxes on
variable utils utils on

: bit   dup constant 2 * ;

1
bit C_SHOOTABLE  \ can be shot with souls
bit C_ILLUSION   \ seems to hurt you but really doesn't
bit C_HARMFUL    \ actually hurts you
bit C_PLAYERPROJECTILE
bit C_PLAYER
bit C_WEAK       \ is hurt just by touching the player (atk value)
bit C_REPEL      \ propels the player back with a lot of force
drop

\ stacking orders  - this could be automated by using the Forth dictionary.
-100000 constant =bg
500 constant =redflash
600 constant =barbwire
800 constant =boss
900 constant =darkness
999 constant =bloodrenderer
1000 constant =lady
2000 constant =shard

10000 constant =fg
20000 constant =ui
30000 constant =solidoverlay
40000 constant =static

\ Z values
0.8 value zbg

\ COMPLETE / NEXTUP
\ Simple way for different "parts" of the game to signal to proceed to the next part
\ without having to be coupled to each other

variable 'complete  ' noop 'complete !
: complete   'complete @  ['] noop 'complete ! execute report" Segment completed." ;
: nextup     'complete ! ;

\ ---------------------------------------------------------------------------
\ Common assets

fload commonassets

\ ---------------------------------------------------------------------------
\ Load game specific API

fload ladyapi

\ Lady's level based emotions
calm 1 +
   enum l1r1:|
   enum l1r2:|
   enum l1r3:|
   enum l1boss:|
drop

\ ---------------------------------------------------------------------------
\ Stuff just for testing

image l1bg.image data\l1misc\l1bg.jpg
: clear   clean clear-sounds l1bg.image setbg ;

\ ---------------------------------------------------------------------------
\ Lady stuff

fload lady

view 0.5 1.0 around at %lady one constant lady
%soul lady >weapon1 !


: /lady
   lady control  lady { vis on restart } ;

: lady/
   0 control lady { vis off disable } ;

/lady
lady be
