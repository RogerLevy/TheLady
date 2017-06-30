\ ==============================================================================
\ ForestLib > GameBlocks
\ Asset objects
\ ========================= copyright 2014 Roger Levy ==========================

\ 4/24/13


create assets  500 stack,

true ?constant log-assets


: ending ( addr len char -- addr len )
  >r begin  2dup r@ scan
    ?dup while  2swap 2drop  1 /string
  repeat  r> 2drop ;
: -path  [char] \ ending [char] / ending 0 max ;


pstruct %asset
  noop: onload
  noop: ondestroy
  256 field path
  [[ path count ]] var: 'fetchpath
  var assetid
endp


: find-asset ( path c -- path c )
  ?homepath ;

: untitled?  2dup " newasset" -match nip 0= ;
: untitled   " newasset" ;

: path@  'fetchpath @ execute ;

: ?log
  log-assets if
    untitled? if
      report" Untitled asset " struct .
    else
      report" Asset: "  2dup -path type space
    then
  then ;

: exec.
  get-xy nip 50 swap at-xy 1000 / dup 4 .r  ."  ms "
    5 + 10 / 0 ?do [char] * emit loop ;

: (load)  path@ find-asset ?log [[ onload @ execute ]] exectime exec. ;
\ if the file is not found where specified from the current directory, check the home directory
: asset^  ( path c -- )  path place  assets length assetid !  struct assets push  (load) ;
: load-assets  [[ @ -> (load) ]] assets each  ;

: load-asset  -> (load) ;

: destroy-asset  => ondestroy @ execute ;
: clear-assets  [[ @ destroy-asset ]] assets each  assets vacate ;
: (reload)  => ondestroy @ execute  (load) ;
: reload-assets   [[ @ (reload) ]] assets each ;
: .assets  [[ cr @ -> path@ type ]] assets each ;
: identifier  bl parse bl skip 2dup -path $create ;

: loaded  ( path c -- 0 | asset )
  locals| c p |
  0 [[ => path count p c compare 0= if drop struct then ]] assets those ;

: ?loaded ( path c -- asset true | path c false )
  locals| c path |
  path c loaded ?dup if true exit else path c false then ;


\ Synchronous progress bar support

defer (update-loader) 
: load-assets-showing-progress  ( xt -- )
  is (update-loader)  [[ @ => (update-loader) (load) ]] assets each ;

\ tool for making loading screens; returns a value 0.0 ~ 1.0 for the current asset (in STRUCT)
: progress%  1.0 assetid @ assets length 1 - */ ;
