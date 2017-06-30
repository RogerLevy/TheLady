\ ==============================================================================
\ ForestLib
\ Region-based memory management
\ ========================= copyright 2014 Roger Levy ==========================

\ depends on these parts of ForestLib right now (6/22/2014):
\  arrays, quicksort

\ this file provides region-based dynamic memory management for a number of new planned capabilities.
\  (listed in a separate doc)

\ it's not intended to be a total replacement for ALLOT or ALLOCATE, but it does have the advantage
\  of being both dynamic while also existing in the dictionary, so the same words can be used for dynamic and static data.

\ RESERVE guarantees that requested bits of memory and subregions are both sequential.

\ TODO: another word that doesn't guarantee granted memory to be in sequence
\     or i might just make RESERVE work that way.

\ the way it works
\  there is a virtual pool of memory divided into fairly big chunks of /SEGMENT size,
\    kept track of by an array of segment descriptors
\  we only allot memory from the dictionary when it's needed
\  memory is kept in subregions
\    when a subregion is created for the first time, all subsequent segments are initialized and the memory is
\      ALLOTed from the dictionary.
\    freed-subregions fill with memory reservations, and an offset tracks how much data is used
\  memory is RESERVE'd from regions, which are backwards-linked lists of subregions.
\    (we scan backwards to reduce the size of a region)
\    ("indexing" into the region, for dynamic arrays, can be done by accumulating an array of segment addresses)
\    regions can be RECLAIM'd wholesale.
\    they can also be reduced in size 
\    when a subregion does not have enough memory to accomodate a memory request,
\      we check the list of free subregions if there are any
\      if not we create a new subregion at the end of the dictionary
\    finding an optimal subregion:
\      we don't want to waste memory, so freed-subregions are sorted by increasing size in a list.
\

\    creating:
\      dictionary bytes are ALLOT'd, starting address is recorded.
\      total size is put in the first AND last segments
\      initial used bytes are stored in first segment
\
\    splitting:
\      if the smallest subregion that our request, rounded up to /SEGMENT, can fit is at least /SEGMENT too big,
\      split subregion into 2 new ones and grant the memory using the first one.
\      this is to avoid extreme cases where we grant a few bytes from a 1MB subregion and all that memory is kept from
\      being used by other regions.
\       
\    combining:
\      when a subregion is freed, surrounding ones are checked to see if they are unused. (unallocated ones at the end don't count)
\      if one is found the freed-subregions are combined
\
\    sorting:
\      to let the system find the best subregion match for a memory request in a region,
\      a sorted list of subregion-defining descriptors (leaving out all other ones) is maintained.
\      and is re-sorted any time subregions are directly freed, re-used, combined or split.



\ data structures
\   segment descriptor pool
\     each descriptor contains potential info about a subregion
\     an additional link on each subregion links it to the previous one as part of the region's list of subregions.
\     every descriptor has an address field, showing that it has been ALLOT'd in the dictionary
\     number of bytes granted by subregion - ALWAYS non-zero if subregion is in use by a region
\   segment descriptors sorted in increasing size
\   region
\     first subregion
\     last subregion
\     total granted bytes size
\     total size of freed-subregions in bytes


reporting off
\ reporting on  \ uncomment to see region debug messages

package regioning

: megs  [ 1024 dup * ]# * ;

8192 ?constant /segment
32 megs ?constant /maxmem

/maxmem /segment / constant #maxsegments

variable memused \ total amount of in-use memory
variable allocated \ total combined size of all allocated segments. 

private

pstruct %subregion
  var regprev  \ link to previous subregion in region.
  var addr    \ address of the data
  var size    \ total allocated size of subregion in bytes. (can be more than /SEGMENT)
  var used    \ next available offset (can be more than /SEGMENT)
endp
%subregion sizeof constant /segdescr \ segment descriptor
public

create segments      #maxsegments /segdescr array,
create freed-subregions #maxsegments stack,



private
\ ------------------------------------------------------------------------------
\ Segments

: in-use?    .used @ 0> ;
: unallocated? .addr @ 0= ;


\ ------------------------------------------------------------------------------
\ Subregions

\ assumes subregion has enough space
: use  ( bytes subregion -- addr ) with used @ addr @ +  swap dup memused +!  used +! ;

: remaining  ( subregion -- bytes ) with size @ used @ - ;

: sort-subregions
  freed-subregions vacate
  [[ with size @ used @ 0= and if s@ freed-subregions push then ]] segments each
  [[ .size @ swap .size @ > ]] freed-subregions sort ;

: (free-subregion) ( subregion -- )
  with  used @ negate memused +!  0 used !  0 regprev ! ;

: frontier ( -- unallocated-segment )
  allocated @ /segment / segments [] ;

: segs+  ( segdescr bytes -- segdescr )
  /segment / /segdescr * + ;

: >cap ( subregion -- segdescr )
  dup .size @ 1 - segs+ ;

: seground  1 - /segment / 1 + /segment * ;

: init-subregion  ( addr used-bytes subregion -- )
  with swap ( .s ) addr !  dup  seground dup size ! s@ >cap -1 over .used !  .size !  dup memused +! used !  ;

: new-subregion ( requested-bytes -- subregion )
  here over seground /allot frontier with
  ( bytes address ) swap s@ init-subregion
  size @ allocated +!  0 regprev !
  s@ ;
  
: connect ( older-subregion newer-subregion -- )
  .regprev ! ;

: shakeoff ( subregion -- )
  .regprev off ;

: split ( bytes subregion -- subregion1 subregion2 )
  2dup swap segs+ locals| s2 s1 b |  
  s1 .addr @ dup  s1 .size @ + ( address of memory for subregion2 )
  s1 .size @ b seground - ( size of subregion2 )
  s2 init-subregion  s2 (free-subregion)
  ( address of memory for subregion1 ) b s1 init-subregion
  sort-subregions 
  s1 s2 ;
  
\ freed-subregions are assumed to be unused.
: combine ( subregion1 subregion2 -- subregion )
  locals| s2 s1 |
  s1 .addr @ s1 .size @ s2 .size @ +  0 s2 .size !
  ( addr combined-size ) s1 init-subregion 
  sort-subregions
  s1 ;

\ TODO
: ?combine
  drop
;

: free-subregion
  dup shakeoff dup (free-subregion) ?combine ;

: reuse  ( bytes subregion -- addr )
  use ; \ sort-subregions ;

: use-any-unused-subregion ( requested-bytes -- addr subregion | 0 )
  locals| b | 
  freed-subregions itemsbounds ?do
    i @ .used @ not if 
      i @ dup .size @ b >= if b over reuse swap unloop exit else drop then
    then
  cell +loop
  false ;

: should-split? ( requested-bytes subregion -- flag )
  .size @ swap seground - /segment >= ;

: has-enough? ( requested-bytes subregion -- flag )
  remaining < ;

public 


\ a region is a list of subregions.
pstruct %region
  var lastsr
  var total
  var firstsr
  var onset
endp

: REGION,  %region instance, ;
: REGION   create region, ;


\ trims at most one subregion, returning however many bytes to trim remain.
: trimstep  ( region trim-bytes -- region remaining-trim-bytes )
  locals| b | with
  b  lastsr @ .used @ < if
    b negate lastsr @ use drop
    0 to b
    report" reduce last sr"
  else
    lastsr @ .used @ negate +to b
    lastsr @ .regprev @ 
    lastsr @ free-subregion 
    lastsr !
    report" shake off last sr"
  then
  s@ b ;


: RESERVED ( region -- bytes )
  .total @ ;

\ resize a region.  only size reduction is allowed. 
: TRIM ( region bytes -- )
  0 max locals| b | with
  total @ 0= ?exit
  total @ b = ?exit
  b s@ reserved > abort" TRIM bytes param more than region size"
  s@ dup reserved b - 
  begin trimstep ?dup 0= until drop
  b total !
  sort-subregions ;

: RECLAIM ( region -- )
  0 trim ;


: new-reservation
  new-subregion dup .addr @ swap ;

\ debugging off
: RESERVE ( region bytes -- addr )
  locals| bytes | with
  bytes total +!
\ if there is a last subregion, see if it has space and if so use it
  lastsr @ ?dup if
    bytes over has-enough? if
      report" use last sr"
      bytes swap reuse exit
    then
    drop
  then

\ otherwise see if there are any unused subregions we can add to the region
  bytes use-any-unused-subregion ?dup if
    report" reuse free sr"
  else
\ otherwise create a new subregion.
    report" new sr"
    bytes new-reservation
  then
    
\ depending on LASTSR link any new or newly-reused subregion into the chain
  lastsr @ ?dup if
    report" link to last sr"
    over connect
  else
    dup firstsr !
    dup .addr @ onset !
  then

  lastsr !  
  
\ split the subregion if it has too much space in it.
  \ b lastsr @  should-split? if
  \   report" split sr"
  \   b lastsr @ split 2drop
  \ then
;

: init-region
  %region sizeof erase ;

: available ( region -- bytes )
  .lastsr @ ?dup if remaining else /segment then ;

end-package

reporting on