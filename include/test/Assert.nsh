!ifndef ASSERT_NSH
!define ASSERT_NSH

!macro ASSERT _resHasFailed_ _assertMessage_

!include "VarLogic.nsh"

var /global __Assert_Message

/*#==============================#::
 ASSERT EQUALS
 param: First param to compare
 param: Second param to compare
#==============================#*/
!define AssertEqual '!insertmacro AssertEqualCall'

/*#==============================#::
 ASSERT NOT EQUALS
 param: First param to compare
 param: Second param to compare
#==============================#*/
!define AssertNotEqual '!insertmacro AssertNotEqualCall'

/*#==============================#::
 ASSERT PASSED
#==============================#*/
!define _AssertPassed '!insertmacro _AssertPassedCall `${_resHasFailed_}` `${_assertMessage_}`'

/*#==============================#::
 ASSERT EQUALS
 param: First param to compare
 param: Second param to compare
#==============================#*/
!define AssertFailed '!insertmacro AssertFailedCall `${_resHasFailed_}` `${_assertMessage_}`'

!macroend

!macro AssertEqualCall _param1 _param2
  ${If} `${_param1}` != `${_param2}`
    StrCpy $__Assert_Message '"${_param1}" was not equal to "${_param2}"'
    ${_AssertFailed} '$__Assert_Message'
  ${Else}
    ${_AssertPassed}
  ${EndIf}
!macroend

!macro AssertNotEqualCall _param1 _param2
  ${If} `${_param1}` == `${_param2}`
    StrCpy $__Assert_Message '"${_param1}" was equal to "${_param2}"'
    ${_AssertFailed} '$__Assert_Message'
  ${Else}
    ${_AssertPassed}
  ${EndIf}
!macroend

!macro _AssertPassedCall _resHasFailed_ _assertMessage_
  ${If} `${_resHasFailed_}` == `0`
    StrCpy ${_assertMessage_} ``
  ${EndIf}
!macroend

!macro _AssertFailedCall _resHasFailed_ _assertMessage_ _message
  StrCpy ${_resHasFailed_} `0`
  ${If} `${_assertMessage_}` == ``
    StrCpy ${_assertMessage_} `${_message}`
  ${EndIf}
!macroend

!endif