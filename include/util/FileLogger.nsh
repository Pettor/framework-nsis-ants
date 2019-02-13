!ifndef TEXT_LOG_NSH
!define TEXT_LOG_NSH

!include "TimeUtils.nsh"

/*#==============================#::
 LOG TEXT
 param: Log a string to file with break
#==============================#*/
!define LogText '!insertmacro LogTextCall'

/*#==============================#::
 LOG TEXT TEST
 param: Log a string to file from test
#==============================#*/
!define LogTextTest '!insertmacro _LogTextGenericCall `1`'

/*#==============================#::
 LOG TEXT
 param: Log a string to file
#==============================#*/
!define LogTextClean '!insertmacro _LogTextGenericCall `0`'

/*#==============================#::
 LOG SET ON
 Used to enable file logging
 param: Directory to store log file
#==============================#*/
!define LogSetOn '!insertmacro LogSetOnCall'

/*#==============================#::
 LOG SET OFF
 Used to disable file logging
 param: Close file when finished
#==============================#*/
!define LogSetOff '!insertmacro LogSetOffCall'

/*#==============================#::
 LOG ENABLE TEST LOG ONLY
 Used to make only test logs available in file
 param: Set logger to only register test logs
#==============================#*/
!define LogEnableTestLogOnly '!insertmacro LogEnableTestLogOnlyCall'

Var /GLOBAL __TextLog_FileHandle
Var /GLOBAL __TextLog_FileName
Var /GLOBAL __TextLog_State
Var /GLOBAL __TextLog_TestLogOnly

/*#==============================#::
 LOG TEXT CALL
 param: Log a string to file with break
#==============================#*/
!macro LogTextCall _text
  Push $R0
  ${GetTimeStr} $R0
  ${LogTextClean} `[$R0]`
  Pop $R0
  ${LogTextClean} ` ${_text}`
  ${LogTextClean} `$\r$\n`
!macroend

/*#==============================#::
 LOG TEXT GENERIC
 param: "1" if test log and "0" if normal
 param: Log a string to file with break
#==============================#*/
!macro _LogTextGenericCall _isTest _text 
  ${If} `$__TextLog_TestLogOnly` == `1`
  ${AndIf} `${_isTest}` == `0`
    ;Do nothing (NSIS quite bad if statement makes this easier)
  ${Else}
    FileWrite $__TextLog_FileHandle `${_text}`
  ${EndIf}
!macroend

/*#==============================#::
 LOG SET ON
 Used to enable file logging
 param: directory to store log file
#==============================#*/
!macro LogSetOnCall _dir
  StrCpy $__TextLog_TestLogOnly "0"
  StrCmp $__TextLog_FileName "" +1 _logAlreadySet
  StrCpy $__TextLog_FileName "${_dir}"
_logAlreadySet:
  StrCmp $__TextLog_State "open" +2
  FileOpen $__TextLog_FileHandle  "$__TextLog_FileName"  a
  FileSeek $__TextLog_FileHandle 0 END
  StrCpy $__TextLog_State "open"
!macroend

/*#==============================#::
 LOG SET OFF
 Used to disable file logging
 param: close file when finished
#==============================#*/
!macro LogSetOffCall
  StrCmp $__TextLog_State "open" +1 +2
  FileClose $__TextLog_FileHandle
  StrCpy $__TextLog_State ""
!macroend

/*#==============================#::
 LOG ENABLE TEST LOG ONLY
 Used to make only test logs available in file
 param: set logger to only register test logs
#==============================#*/
!macro LogEnableTestLogOnlyCall
  StrCpy $__TextLog_TestLogOnly "1"
!macroend

!endif ;file