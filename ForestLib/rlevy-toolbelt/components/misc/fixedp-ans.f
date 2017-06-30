: fixed-mul  m* 16 >> swap 16 << or ;
macro: s>p  16 << ;
macro: p>s  65536 / ;
: 2s>p  s>p swap s>p swap ;
: 2p>s  p>s swap p>s swap ;
: 3s>p  s>p rot s>p rot s>p rot ;
: 3p>s  p>s rot p>s rot p>s rot ;
macro: floor  $ffff0000 and ;
