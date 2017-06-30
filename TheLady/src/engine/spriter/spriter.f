
\ relies on:
\  ~brute4x array, %displaytransform

\ temporary:
fload brute4x

package spriter 

private

: string   128 field ;

0
enum NO_LOOPING
enum LOOPING
drop

0
enum OBJECT_TYPE_SPRITE
enum OBJECT_TYPE_BONE
enum OBJECT_TYPE_BOX
enum OBJECT_TYPE_POINT
enum OBJECT_TYPE_SOUND
enum OBJECT_TYPE_ENTITY
enum OBJECT_TYPE_VARIABLE
drop

0
enum CURVE_INSTANT
enum CURVE_LINEAR
enum CURVE_QUADRATIC
enum CURVE_CUBIC
drop

%displaytransform ~> %spatialinfo
   var a \ fixed
   var spin \ int
   var px \ fixed
   var py
   var pz
endp

pstruct %timelinekey
   var time \ int - same offset
   CURVE_LINEAR var: curvetype
\   0e fvar: c1
\   0e fvar: c2
   noop: linear  \ meant to be overridden ( timelinekey time -- timelinekey )
endp

%timelinekey ~> %spatialtimelinekey
   %spatialinfo inline: info
   noop: paint   \ meant to be overridden
endp

%spatialtimelinekey ~> %bonetimelinekey
   \ var bone-length
   \ var bone-width
endp

%spatialtimelinekey ~> %spritetimelinekey
   var skfile
   var skfolder
   true var: usedefaultpivot
endp


pstruct %timeline
\   string name         \ this is ok, same offset
   OBJECT_TYPE_SPRITE var: objecttype
   /array field keys
endp

pstruct %ref
   -1 var: parent
   var timeline
   var key
endp

pstruct %mainlinekey
   var time \ int - same offset
   /array field bonerefs \ ref
   /array field objectrefs \ ref
endp

pstruct %animation
[i
   string name         \ this is ok, same offset
i]
   var duration         \ "length" in the psuedocode
   LOOPING var: looptype
   /array field mainlinekeys
   /array field timelines
endp

pstruct %mapinstruction
   var folder  \ n
   var file    \ n
   -1 var: targetfolder \ n
   -1 var: targetfile   \ n
endp

pstruct %charactermap
   string name      \ this is ok, same offset
   /array field maps \ mapinstructions
endp

pstruct %entity
   string name
   /array field charactermaps
   /array field animations
endp

pstruct %file
   string name         \ this is ok, same offset
   var pivotx  \ fixed
   var pivoty
   var bmp     \ reference to a %bitmap - could be written over (with an exposed word) for fun time shenanigans
endp

pstruct %folder
   string name         \ this is ok, same offset
   /array field files
endp

pstruct %scmlobject
   /array field folders
   /array field entities
   /array field activeCharacterMap
\   var currentEntity
\   var currentAnimation
\   var currentTime
endp


0 value destarr



public

\ API
fload spriter-api


\ Load SCML
fload spriter-schema

: does-animdata   does> @ ;
: animdata    ?create here 0 , does-animdata namespec spriter-schema swap ! ;

end-package