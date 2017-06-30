
VARIABLE _powers
: power/2 ( n -- n )   0 _powers !   1 begin over over > while 1 _powers +! 2* repeat nip ;
: power/2?   dup power/2 = ;
: powers/2 ( n -- n )   power/2 drop _powers @ ;
