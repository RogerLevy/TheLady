\ general actions
1 0 action hurt
1 0 action recover
0 0 action die
0 0 action walk
smudge run
0 0 action run
0 0 action idle
0 0 action fall
0 0 action wake
0 0 action slumber
0 0 action excited
1 0 action chase
1 0 action avoid
2 0 action attack ( attack# power )
1 0 action chase
1 0 action avoid
0 0 action intro
3 0 action shoot ( vx. vy. prototype -- )
0 0 action ?shoot
0 0 action physics
1 0 action face

\ :: face    dir! ;

: +hp   hp +!   hp @ 0 <= if die then ; 
: -hp   negate +hp ;

:: hurt  -hp ;
:: recover   +hp ;
:: die   me delete ;

: ?die  hp @ 0 = if die r> drop exit then ;

create dv   0 , -1.0 , 0 , 1.0 , -1.0 , 0 , 1.0 , 0 ,
: dirv   direction @ 2 cells * dv + 2@ speed @ dup 2p* ;
: travel  dirv vel 2! ;

\ create -dv   0 , 1.0 , 0 , -1.0 , 1.0 , 0 , -1.0 , 0 ,
\ : -dirv   direction @ 2 cells * dv + 2@ speed @ dup 2p* ;
\ : -travel  -dirv vel 2! ;

: forward   speed ! travel ;
: backward  negate speed ! travel ;


:: walk   travel ;
\ :: idle   0 speed !  travel ;

: kill  { die } ;
: ?kill { hurt hp @ 0 <= } ;
: heal  { recover } ;

: walkl  left direction ! walk ;
: walkr  right direction ! walk ;

: pos+   x 2@ 2+ ;

: from   ( entity x|. y|. -- )
   2?p rot { pos+ } at ;

:: shoot   me 0 0 from one { vx 2! } ;