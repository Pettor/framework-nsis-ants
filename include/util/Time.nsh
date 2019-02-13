!ifndef TIME_UTILS_NSH
!define TIME_UTILS_NSH

!include "FileFunc.nsh" ;GetTime

/*#==============================#::
 GET TIME STRING
 out: Get string of current time
#==============================#*/
!define GetTimeStr '!insertmacro GetTimeStrCall'

Var /GLOBAL __Test_Time0
Var /GLOBAL __Test_Time1
Var /GLOBAL __Test_Time2
Var /GLOBAL __Test_Time3
Var /GLOBAL __Test_Time4
Var /GLOBAL __Test_Time5
Var /GLOBAL __Test_Time6

!macro GetTimeStrCall _outVar
  ${GetTime} "" "LS" $__Test_Time0 $__Test_Time1 $__Test_Time2 $__Test_Time3 $__Test_Time4 $__Test_Time5 $__Test_Time6
  StrCpy ${_outVar} `$__Test_Time2-$__Test_Time1-$__Test_Time0T$__Test_Time4:$__Test_Time5:$__Test_Time6`
!macroend

!endif ;file