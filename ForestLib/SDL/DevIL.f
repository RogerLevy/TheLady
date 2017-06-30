\ ==============================================================================
\ ForestLib
\ DevIL bindings
\ ========================= copyright 2014 Roger Levy ==========================

LIBRARY DevIL
LIBRARY ILU

\ IL
Function: ilActiveFace ( ILuint-Number -- ILboolean )
Function: ilActiveImage ( ILuint-Number -- ILboolean )
Function: ilActiveLayer ( ILuint-Number -- ILboolean )
Function: ilActiveMipmap ( ILuint-Number -- ILboolean )
Function: ilApplyPal ( ILconst_string-FileName -- ILboolean )
Function: ilApplyProfile ( ILstring-InProfile, ILstring-OutProfile -- ILboolean )
Function: ilBindImage ( ILuint-Image -- )
Function: ilBlit ( ILuint-Source, ILint-DestX, ILint-DestY, ILint-DestZ, ILuint-SrcX, ILuint-SrcY, ILuint-SrcZ, ILuint-Width, ILuint-Height, ILuint-Depth -- ILboolean )
Function: ilClampNTSC ( -- ILboolean )
Function: ilClearColour ( ILclampf-Red, ILclampf-Green, ILclampf-Blue, ILclampf-Alpha -- )
: ilClearColour  4sfparms ilClearColour ;
Function: ilClearImage ( -- ILboolean )
Function: ilCloneCurImage ( -- ILuint )
Function: ilCompressDXT ( ILubyte-*Data, ILuint-Width, ILuint-Height, ILuint-Depth, ILenum-DXTCFormat, ILuint-*DXTCSize -- ILubyte* )
Function: ilCompressFunc ( ILenum-Mode -- ILboolean )
Function: ilConvertImage ( ILenum-DestFormat, ILenum-DestType -- ILboolean )
Function: ilConvertPal ( ILenum-DestFormat -- ILboolean )
Function: ilCopyImage ( ILuint-Src -- ILboolean )
Function: ilCopyPixels ( ILuint-XOff, ILuint-YOff, ILuint-ZOff, ILuint-Width, ILuint-Height, ILuint-Depth, ILenum-Format, ILenum-Type, *Data -- ILuint )
Function: ilCreateSubImage ( ILenum-Type, ILuint-Num -- ILuint )
Function: ilDefaultImage ( -- ILboolean )
Function: ilDeleteImage ( const-ILuint-Num -- )
Function: ilDeleteImages ( ILsizei Num, const-ILuint-*Images -- )
Function: ilDetermineType ( ILconst_string-FileName -- ILenum )
Function: ilDetermineTypeF ( ILhandle-File -- ILenum )
Function: ilDetermineTypeL ( const-*Lump, ILuint-Size -- ILenum )
Function: ilDisable ( ILenum-Mode -- ILboolean )
Function: ilDxtcDataToImage ( -- ILboolean )
Function: ilDxtcDataToSurface ( -- ILboolean )
Function: ilEnable ( ILenum-Mode -- ILboolean )
\ Function: ilFlipSurfaceDxtcData ( -- )
Function: ilFormatFunc ( ILenum-Mode -- ILboolean )
Function: ilGenImages ( ILsizei Num, ILuint-*Images -- )
Function: ilGenImage ( -- ILuint )
Function: ilGetAlpha ( ILenum-Type -- ILubyte*  )
Function: ilGetBoolean ( ILenum-Mode -- ILboolean )
Function: ilGetBooleanv ( ILenum-Mode, ILboolean *Param -- )
Function: ilGetData ( -- ILubyte*  )
Function: ilGetDXTCData ( *Buffer, ILuint-BufferSize, ILenum-DXTCFormat -- ILuint )
Function: ilGetError ( -- ILenum )
Function: ilGetInteger ( ILenum-Mode -- ILint )
Function: ilGetIntegerv ( ILenum-Mode, ILint-*Param -- )
Function: ilGetLumpPos ( -- ILuint )
Function: ilGetPalette ( -- ILubyte*  )
Function: ilGetString ( ILenum-StringName -- ILconst_string )
Function: ilHint ( ILenum-Target, ILenum-Mode -- )
\ Function: ilInvertSurfaceDxtcDataAlpha ( -- ILboolean )
Function: ilInit ( -- )
Function: ilImageToDxtcData ( ILenum-Format -- ILboolean )
Function: ilIsDisabled ( ILenum-Mode -- ILBoolean )
Function: ilIsEnabled ( ILenum-Mode -- ILBoolean )
Function: ilIsImage ( ILuint-Image -- ILBoolean )
Function: ilIsValid ( ILenum-Type, ILconst_string-FileName -- ILBoolean )
Function: ilIsValidF ( ILenum-Type, ILhandle-File -- ILBoolean )
Function: ilIsValidL ( ILenum-Type, *Lump, ILuint-Size -- ILBoolean )
Function: ilKeyColour ( ILclampf-Red, ILclampf-Green, ILclampf-Blue, ILclampf-Alpha -- )
: ilKeyColour  4sfparms ilKeyColour ;
Function: ilLoad ( ILenum-Type, ILconst_string-FileName -- ILBoolean )
Function: ilLoadF ( ILenum-Type, ILhandle-File -- ILBoolean )
Function: ilLoadImage ( ILconst_string-FileName -- ILBoolean )
Function: ilLoadL ( ILenum-Type, const-*Lump, ILuint-Size -- ILBoolean )
Function: ilLoadPal ( ILconst_string-FileName -- ILBoolean )
Function: ilModAlpha ( ILdouble-AlphaValue -- )
: ilModAlpha  1df ilModAlpha ;
Function: ilOriginFunc ( ILenum-Mode -- ILBoolean )
Function: ilOverlayImage ( ILuint-Source, ILint-XCoord, ILint-YCoord, ILint-ZCoord -- ILBoolean )
Function: ilPopAttrib ( -- )
Function: ilPushAttrib ( ILuint-Bits -- )
Function: ilRegisterFormat ( ILenum-Format -- )
Function: ilRegisterLoad ( ILconst_string-Ext, IL_LOADPROC-Load -- ILBoolean )
Function: ilRegisterMipNum ( ILuint-Num -- ILBoolean )
Function: ilRegisterNumFaces ( ILuint-Num -- ILBoolean )
Function: ilRegisterNumImages ( ILuint-Num -- ILBoolean )
Function: ilRegisterOrigin ( ILenum-Origin -- )
Function: ilRegisterPal ( *Pal, ILuint-Size, ILenum-Type -- )
Function: ilRegisterSave ( ILconst_string-Ext, IL_SAVEPROC-Save -- ILBoolean )
Function: ilRegisterType ( ILenum-Type -- )
Function: ilRemoveLoad ( ILconst_string-Ext -- ILboolean )
Function: ilRemoveSave ( ILconst_string-Ext -- ILboolean )
Function: ilResetMemory ( -- ) \ Deprecated
Function: ilResetRead ( -- )
Function: ilResetWrite ( -- )
Function: ilSave ( ILenum-Type, ILconst_string-FileName -- ILboolean )
\ Function: ilSaveF ( ILenum-Type, ILhandle-File --ILboolean  ILuint )
Function: ilSaveImage ( ILconst_string-FileName -- ilboolean )
Function: ilSaveL ( ILenum-Type, *Lump, ILuint-Size -- ILuint )
Function: ilSavePal ( ILconst_string-FileName -- ILboolean )
Function: ilSetAlpha ( ILdouble-AlphaValue -- ILboolean )
: ilSetAlpha  1df ilSetAlpha ;
Function: ilSetData ( *Data -- ILboolean )
Function: ilSetDuration ( ILuint-Duration -- ILboolean )
Function: ilSetInteger ( ILenum-Mode, ILint-Param -- )
Function: ilSetMemory ( mAlloc, mFree -- )
Function: ilSetPixels ( ILint-XOff, ILint-YOff, ILint-ZOff, ILuint-Width, ILuint-Height, ILuint-Depth, ILenum-Format, ILenum-Type, *Data -- )
Function: ilSetRead ( fOpenRProc, fCloseRProc, fEofProc, fGetcProc, fReadProc, fSeekRProc, fTellRProc -- )
Function: ilSetString ( ILenum-Mode, const-char-*string -- )
Function: ilSetWrite ( fOpenWProc, fCloseWProc, fPutcProc, fSeekWProc, fTellWProc, fWriteProc -- )
Function: ilShutDown ( -- )
Function: ilSurfaceToDxtcData ( ILenum-Format -- )
\ Function: ilTexImage ( ILuint-Width, ILuint-Height, ILuint-Depth, ILubyte-NumChannels, ILenum-Format, ILenum-Type, *Data -- ILboolean )
Function: ilTexImage ( w h d NumChannels Format Type Data -- ILboolean )

Function: ilTexImageDxtc ( ILint-w, ILint-h, ILint-d, ILenum-DxtFormat, const-ILubyte* data -- ILboolean )
Function: ilTypeFromExt ( ILconst_string-FileName -- ILenum )
Function: ilTypeFunc ( ILenum-Mode -- ILboolean )
Function: ilLoadData ( ILconst_string-FileName, ILuint-Width, ILuint-Height, ILuint-Depth, ILubyte-Bpp -- ILboolean )
Function: ilLoadDataF ( ILhandle-File, ILuint-Width, ILuint-Height, ILuint-Depth, ILubyte-Bpp -- ILboolean )
Function: ilLoadDataL ( *Lump, ILuint-Size, ILuint-Width, ILuint-Height, ILuint-Depth, ILubyte-Bpp -- ILboolean )
Function: ilSaveData ( ILconst_string-FileName -- ILboolean )


\ \ ILU
Function: iluMirror ( -- )
Function: iluFlipImage ( -- )
\ Function: iluInit ( -- )
\ Function: ilutRenderer ( n -- )
\ Function: iluErrorString ( n -- z$ )
\
\ \ Direct-to-OpenGL commands
\ Function: ilutDisable ( n -- )
\ Function: ilutGLLoadImage ( z$ -- n )
\ Function: ilutGLScreen ( -- )
\ Function: ilutGLScreenie ( -- )
\ Function: ilutGLTexImage ( level -- )
\ Function: ilutGLBindTexImage ( -- n )

\ Formats. These match OpenGL:
#define IL_COLOUR_INDEX     $1900
#define IL_COLOR_INDEX      $1900
#define IL_RGB              $1907
#define IL_RGBA             $1908
#define IL_BGR              $80E0
#define IL_BGRA             $80E1
#define IL_LUMINANCE        $1909
#define IL_LUMINANCE_ALPHA  $190A

\ Data Widths:
#define IL_BYTE           $1400
#define IL_UNSIGNED_BYTE  $1401
#define IL_SHORT          $1402
#define IL_UNSIGNED_SHORT $1403
#define IL_INT            $1404
#define IL_UNSIGNED_INT   $1405
#define IL_FLOAT          $1406
#define IL_DOUBLE         $140A
#define IL_VENDOR   $1F00
#define IL_LOAD_EXT $1F01
#define IL_SAVE_EXT $1F02

\ Attribute Bits
#define IL_ORIGIN_BIT          $00000001
#define IL_FILE_BIT            $00000002
#define IL_PAL_BIT             $00000004
#define IL_FORMAT_BIT          $00000008
#define IL_TYPE_BIT            $00000010
#define IL_COMPRESS_BIT        $00000020
#define IL_LOADFAIL_BIT        $00000040
#define IL_FORMAT_SPECIFIC_BIT $00000080
#define IL_ALL_ATTRIB_BITS     $000FFFFF


\ Palette types
#define IL_PAL_NONE   $0400
#define IL_PAL_RGB24  $0401
#define IL_PAL_RGB32  $0402
#define IL_PAL_RGBA32 $0403
#define IL_PAL_BGR24  $0404
#define IL_PAL_BGR32  $0405
#define IL_PAL_BGRA32 $0406


\ Image types
#define IL_TYPE_UNKNOWN $0000
#define IL_BMP          $0420
#define IL_CUT          $0421
#define IL_DOOM         $0422
#define IL_DOOM_FLAT    $0423
#define IL_ICO          $0424
#define IL_JPG          $0425
#define IL_JFIF         $0425
#define IL_LBM          $0426
#define IL_PCD          $0427
#define IL_PCX          $0428
#define IL_ppiC          $0429
#define IL_PNG          $042A
#define IL_PNM          $042B
#define IL_SGI          $042C
#define IL_TGA          $042D
#define IL_TIF          $042E
#define IL_CHEAD        $042F
#define IL_RAW          $0430
#define IL_MDL          $0431
#define IL_WAL          $0432
#define IL_LIF          $0434
#define IL_MNG          $0435
#define IL_JNG          $0435
#define IL_GIF          $0436
#define IL_DDS          $0437
#define IL_DCX          $0438
#define IL_PSD          $0439
#define IL_EXIF         $043A
#define IL_PSP          $043B
#define IL_ppiX          $043C
#define IL_PXR          $043D
#define IL_XPM          $043E
#define IL_HDR          $043F

#define IL_JASC_PAL     $0475


\ Error Types
#define IL_NO_ERROR             $0000
#define IL_INVALID_ENUM         $0501
#define IL_OUT_OF_MEMORY        $0502
#define IL_FORMAT_NOT_SUPPORTED $0503
#define IL_INTERNAL_ERROR       $0504
#define IL_INVALID_VALUE        $0505
#define IL_ILLEGAL_OPERATION    $0506
#define IL_ILLEGAL_FILE_VALUE   $0507
#define IL_INVALID_FILE_HEADER  $0508
#define IL_INVALID_PARAM        $0509
#define IL_COULD_NOT_OPEN_FILE  $050A
#define IL_INVALID_EXTENSION    $050B
#define IL_FILE_ALREADY_EXISTS  $050C
#define IL_OUT_FORMAT_SAME      $050D
#define IL_STACK_OVERFLOW       $050E
#define IL_STACK_UNDERFLOW      $050F
#define IL_INVALID_CONVERSION   $0510
#define IL_BAD_DIMENSIONS       $0511
#define IL_FILE_READ_ERROR      $0512  \ 05/12/2002: Addition by Sam.
#define IL_FILE_WRITE_ERROR     $0512

#define IL_LIB_GIF_ERROR  $05E1
#define IL_LIB_JPEG_ERROR $05E2
#define IL_LIB_PNG_ERROR  $05E3
#define IL_LIB_TIFF_ERROR $05E4
#define IL_LIB_MNG_ERROR  $05E5
#define IL_UNKNOWN_ERROR  $05FF


\ Origin Definitions
#define IL_ORIGIN_SET        $0600
#define IL_ORIGIN_LOWER_LEFT $0601
#define IL_ORIGIN_UPPER_LEFT $0602
#define IL_ORIGIN_MODE       $0603


\ Format and Type Mode Definitions
#define IL_FORMAT_SET  $0610
#define IL_FORMAT_MODE $0611
#define IL_TYPE_SET    $0612
#define IL_TYPE_MODE   $0613


\ File definitions
#define IL_FILE_OVERWRITE $0620
#define IL_FILE_MODE      $0621


\ Palette definitions
#define IL_CONV_PAL $0630


\ Load fail definitions
#define IL_DEFAULT_ON_FAIL $0632


\ Key colour definitions
#define IL_USE_KEY_COLOUR $0635
#define IL_USE_KEY_COLOR  $0635


\ Interlace definitions
#define IL_SAVE_INTERLACED $0639
#define IL_INTERLACE_MODE  $063A


\ Quantization definitions
#define IL_QUANTIZATION_MODE $0640
#define IL_WU_QUANT          $0641
#define IL_NEU_QUANT         $0642
#define IL_NEU_QUANT_SAMPLE  $0643
#define IL_MAX_QUANT_INDEXS  $0644 \ XIX: ILint: Maximum number of colors to reduce to, default of 256. and has a range of 2-256


\ Hints
#define IL_FASTEST          $0660
#define IL_LESS_MEM         $0661
#define IL_DONT_CARE        $0662
#define IL_MEM_SPEED_HINT   $0665
#define IL_USE_COMPRESSION  $0666
#define IL_NO_COMPRESSION   $0667
#define IL_COMPRESSION_HINT $0668


\ Subimage types
#define IL_SUB_NEXT   $0680
#define IL_SUB_MIPMAP $0681
#define IL_SUB_LAYER  $0682


\ Compression definitions
#define IL_COMPRESS_MODE $0700
#define IL_COMPRESS_NONE $0701
#define IL_COMPRESS_RLE  $0702
#define IL_COMPRESS_LZO  $0703
#define IL_COMPRESS_ZLIB $0704


\ File format-specific Values
#define IL_TGA_CREATE_STAMP        $0710
#define IL_JPG_QUALITY             $0711
#define IL_PNG_INTERLACE           $0712
#define IL_TGA_RLE                 $0713
#define IL_BMP_RLE                 $0714
#define IL_SGI_RLE                 $0715
#define IL_TGA_ID_STRING           $0717
#define IL_TGA_AUTHNAME_STRING     $0718
#define IL_TGA_AUTHCOMMENT_STRING  $0719
#define IL_PNG_AUTHNAME_STRING     $071A
#define IL_PNG_TITLE_STRING        $071B
#define IL_PNG_DESCRIPTION_STRING  $071C
#define IL_TIF_DESCRIPTION_STRING  $071D
#define IL_TIF_HOSTCOMPUTER_STRING $071E
#define IL_TIF_DOCUMENTNAME_STRING $071F
#define IL_TIF_AUTHNAME_STRING     $0720
#define IL_JPG_SAVE_FORMAT         $0721
#define IL_CHEAD_HEADER_STRING     $0722
#define IL_PCD_ppiCNUM              $0723

#define IL_PNG_ALPHA_INDEX $0724 \ XIX: ILint: the color in the pallete at this index Value (0-255) is considered transparent, -1 for no trasparent color

\ DXTC definitions
#define IL_DXTC_FORMAT      $0705
#define IL_DXT1             $0706
#define IL_DXT2             $0707
#define IL_DXT3             $0708
#define IL_DXT4             $0709
#define IL_DXT5             $070A
#define IL_DXT_NO_COMP      $070B
#define IL_KEEP_DXTC_DATA   $070C
#define IL_DXTC_DATA_FORMAT $070D
#define IL_3DC              $070E
#define IL_RXGB             $070F
#define IL_ATI1N            $0710

\ Cube map definitions
#define IL_CUBEMAP_POSITIVEX $00000400
#define IL_CUBEMAP_NEGATIVEX $00000800
#define IL_CUBEMAP_POSITIVEY $00001000
#define IL_CUBEMAP_NEGATIVEY $00002000
#define IL_CUBEMAP_POSITIVEZ $00004000
#define IL_CUBEMAP_NEGATIVEZ $00008000


\ Values
#define IL_VERSION_NUM           $0DE2
#define IL_IMAGE_WIDTH           $0DE4
#define IL_IMAGE_HEIGHT          $0DE5
#define IL_IMAGE_DEPTH           $0DE6
#define IL_IMAGE_SIZE_OF_DATA    $0DE7
#define IL_IMAGE_BPP             $0DE8
#define IL_IMAGE_BYTES_PER_pixel $0DE8
#define IL_IMAGE_BITS_PER_pixel  $0DE9
#define IL_IMAGE_FORMAT          $0DEA
#define IL_IMAGE_TYPE            $0DEB
#define IL_PALETTE_TYPE          $0DEC
#define IL_PALETTE_SIZE          $0DED
#define IL_PALETTE_BPP           $0DEE
#define IL_PALETTE_NUM_COLS      $0DEF
#define IL_PALETTE_BASE_TYPE     $0DF0
#define IL_NUM_IMAGES            $0DF1
#define IL_NUM_MIPMAPS           $0DF2
#define IL_NUM_LAYERS            $0DF3
#define IL_ACTIVE_IMAGE          $0DF4
#define IL_ACTIVE_MIPMAP         $0DF5
#define IL_ACTIVE_LAYER          $0DF6
#define IL_CUR_IMAGE             $0DF7
#define IL_IMAGE_DURATION        $0DF8
#define IL_IMAGE_PLANESIZE       $0DF9
#define IL_IMAGE_BPC             $0DFA
#define IL_IMAGE_OFFX            $0DFB
#define IL_IMAGE_OFFY            $0DFC
#define IL_IMAGE_CUBEFLAGS       $0DFD
#define IL_IMAGE_ORIGIN          $0DFE
#define IL_IMAGE_CHANNELS        $0DFF

0 constant ILUT_OPENGL



\ ilut State Definitions
#define ILUT_PALETTE_MODE         $0600
#define ILUT_OPENGL_CONV          $0610
#define ILUT_D3D_MIPLEVELS        $0620
#define ILUT_MAXTEX_WIDTH         $0630
#define ILUT_MAXTEX_HEIGHT        $0631
#define ILUT_MAXTEX_DEPTH         $0632
#define ILUT_GL_USE_S3TC          $0634
#define ILUT_D3D_USE_DXTC         $0634
#define ILUT_GL_GEN_S3TC          $0635
#define ILUT_D3D_GEN_DXTC         $0635
#define ILUT_S3TC_FORMAT          $0705
#define ILUT_DXTC_FORMAT          $0705
#define ILUT_D3D_POOL             $0706
#define ILUT_D3D_ALPHA_KEY_COLOR  $0707
#define ILUT_D3D_ALPHA_KEY_COLOUR $0707

ilInit
