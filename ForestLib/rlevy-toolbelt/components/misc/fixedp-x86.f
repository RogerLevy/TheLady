icode fixed-mul  \ 4x faster
  ebx eax mov
  0 [ebp] imul
  4 # ebp add
  dx ax mov
  eax 16 # ror
  eax ebx mov
  ret end-code

icode s>p  \ convert int to fixed
   EBX 16 # SHL
   ret end-code

icode p>s  \ convert fixed to int
   EBX 16 # SAR
   ret end-code

icode 2s>p  \ convert 2 ints to fixed
   ebx 16 # shl
   0 [ebp] 16 # shl
   ret end-code

icode 2p>s  \ convert 2 fixed to int
   ebx 16 # sar
   0 [ebp] 16 # sar
   ret end-code

icode 3s>p  \ convert 3 ints to fixed
   ebx 16 # shl
   0 [ebp] 16 # shl
   4 [ebp] 16 # shl
   ret end-code

icode 3p>s  \ convert 3 fixed to int
   ebx 16 # sar
   0 [ebp] 16 # sar
   4 [ebp] 16 # sar
   ret end-code

icode floor  $ffff0000 # ebx and  ret end-code
