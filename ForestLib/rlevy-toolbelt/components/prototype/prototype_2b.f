1 strands here 0 , 
create %class  /class , , ' noop , ' pstruct-fields , , 0 , %class , including string,

1 strands here 0 , 
create %object  0 , , ' noop , ' pstruct-fields , , 0 , %class , including string,

: addressing:  ( -- <code> ; ) \ ( offset -- address ) code should tell how to get at the field
  " [[ [[ create-field does> @ " <$
  [char] ; parse $+ 
  "  ]] is ifield ]] fields" $+ $> evaluate ;

create pdefs 16 cells allot
variable >pdef
: push-pdef  pdef >pdef @ 15 and cells pdefs + !  >pdef ++ ;
: pop-pdef   >pdef --  >pdef @ 15 and cells pdefs + @ to pdef ;

: begetting  pdef .onbeget ! ;
macro: >prototype  .proto @ ;
: force-size  pdef .size ! ;
: pdef-$create-field  $create pdef .size @ , ;
: pdef+psize  pdef .size +! ;
: new-structs  ['] pdef-$create-field is $create-field
          ['] pdef+psize is +psize ; new-structs
: phere  prototype pdef .size @ + ;
: var:   ( value -- <name> )  phere ! var ;
: fvar:  phere f! dvar ;
: sfvar:  phere sf! var ;
: mark:  0 field ;
: ^    phere !  cell +psize ;
: 2^    phere 2!  2 cells +psize ;
: string:  phere place  128 field ;
: noop:  ['] noop var: ;
: inline:  ( ... prototype -- <name> ... )  \ embed another object
  with  proto @ phere size @ move  s@ sizeof field ;
aka inline: inline

: ~> ( class -- <name> )
  push-buf  push-pdef  \ new-structs
  derive  1 strands locals| wl parent |
  create  here  dup s!  to pdef
  parent dup .classclass @ sizeof copy,
  parent ancestor !
  wl pwl !
  including ppath place
  onbeget @ execute ptype @ execute 
  pdef innards ;

\ finish up the prototype and copy the data into a unique buffer
: endp ( -- )
  pdef with  pdef -innards
  pop-pdef  
  here proto !  prototype size @ copy,
  pop-buf ;

: reopen  ( prototype -- )
  push-buf  pdef >o  dup innards  dup s!  to pdef
  prototype /buf erase  proto @ prototype size @ cmove  ptype @ execute ;

: pstruct  %object ~> ;
