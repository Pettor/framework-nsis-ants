!ifndef ASSERT_NSH
!define ASSERT_NSH

!include "Print.nsh"

!define AssertEquals '!insertmacro AssertEqualsCall'
!define AssertSuccess '!insertmacro AssertSuccessCall'
!define AssertFailed '!insertmacro AssertFailedCall'

!macro AssertEqualsCall _param1 _param2
  ${If} "${_param1}" != "${_param2}"
    StrCpy $TestVar '"${_param1}" was not equal to "${_param2}"'
    ${AssertFailed} '$TestVar'
  ${EndIf}
  ${AssertSuccess}
!macroend

!macro AssertSuccessCall
  ${PrintTestCaseSuccess}
!macroend

!macro AssertFailedCall _message
  ${PrintTestCaseError} '${_message}'
  StrCpy $HasFailed "1"
!macroend

!endif
