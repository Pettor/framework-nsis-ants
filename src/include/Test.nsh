!ifndef TEST_NSH
!define TEST_NSH

!define BeginTest '!insertmacro BeginTestCall'
!define EndTest '!insertmacro EndTestCall'
!define CreateTestCase '!insertmacro CreateTestCaseCall'

var /global TestName
var /global TestVar
var /global HasFailed

!macro BeginTestCall
  StrCpy $HasFailed "0"
!macroend

!macro EndTestCall
  ${If} "$HasFailed" == "1"
    SetErrorlevel 1
    abort
  ${EndIf}

  SetErrorlevel 0
  abort
!macroend

!macro CreateTestCaseCall _testName
  StrCpy $TestName "${_testName}"
!macroend

!endif
