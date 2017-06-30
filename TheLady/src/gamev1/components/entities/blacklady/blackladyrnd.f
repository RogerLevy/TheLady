\ randomization logic for Black Ladies


0 value doorlady

\ select a new lady to be the door lady - can't be near the player
: select-doorlady-far
   doorlady if
      doorlady >hp @ 0 > if doorlady { blacklady:revert } else exit then
   then
   [[ C_BLACKLADY cflags? player vw 2 / close? not and ]] onewhich ?dup -exit
   dup to doorlady { %blackladybreathing morph }
;

: select-doorlady
   doorlady if
      doorlady >hp @ 0 > if doorlady { blacklady:revert } else exit then
   then
   [[ C_BLACKLADY cflags? ]] onewhich 
   dup to doorlady { %blackladybreathing morph }
;


create blackladies 100 stack,

\ divide # of black ladies by 2 and make that many ladies watchers or chasers
: randomize-ladies
   blackladies vacate
   \ first get all ladies into BLACKLADIES
   [[ C_BLACKLADY cflags? ]] which ?dup -exit blackladies pushes
   \ then shuffle it
   blackladies shuffle
   \ then pop 1/4 of them, make those watchers, then pop another 1/4 and make those chasers
   blackladies length 4 / 
   blackladies over pops [[ { %blackladywatcher morph } ]] execs
   blackladies swap pops [[ { %blackladychaser morph } ]] execs
;

\ manages changing the door lady periodically
: doorlady-script
   0 to doorlady
   select-doorlady-far
   0 [[ begin 6 #screens 1 - * delay select-doorlady again ]] parallel
;