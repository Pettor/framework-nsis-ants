/*** 
  ANTS - A N(SIS) TEST FRAMEWORK

  Have you ever asked yourself ... why?
  Well now you can also!

  Thanks to stacks, push, pop and A LOT of Macros this test framework
  will make your life go wooooosh! Like really woooooosh!

  ANTS - The modern NSIS test framework for a language no one ever asked for!
*/

!ifndef TEST_NSH
!define TEST_NSH

!addincludedir "..\util"
!include "LogicLib.nsh"
!include "Assert.nsh"
!include "Print.nsh"
!include "Time.nsh"

/*#==============================#::
 INITIATE TESTING
 Used to start testing
 param: Dir for file log
#==============================#*/
!define InitiateTesting '!insertmacro InitiateTestingCall'

/*#==============================#::
 STOP TESTING
 Used to stop testing
#==============================#*/
!define StopTesting '!insertmacro StopTestingCall'

/*#==============================#::
 CREATE TEST CASE
 Create a test case
 param: Name of test case
#==============================#*/
!define CreateTestCase '!insertmacro CreateTestCaseCall'

/*#==============================#::
 END TEST CASE
 End a test case
#==============================#*/
!define EndTestCase '!insertmacro EndTestCaseCall'

/*#==============================#::
 TEST
 Start a test in the test case
 Requires a test case to be started
#==============================#*/
!define Test '!insertmacro TestCall'

/*#==============================#::
 END TEST
 End a test in the test case
#==============================#*/
!define EndTest '!insertmacro EndTestCall'

Var /GLOBAL __Test_TestName
Var /GLOBAL __Test_TestStartTime
Var /GLOBAL __Test_TestStopTime
Var /GLOBAL __Test_TestHasFailed
Var /GLOBAL __Test_TestSuccess
Var /GLOBAL __Test_TestFailure
Var /GLOBAL __Test_TestCount

Var /GLOBAL __Test_TestCaseCount
Var /GLOBAL __Test_TestCaseSuccess
Var /GLOBAL __Test_TestCaseFailure
Var /GLOBAL __Test_TestCaseHasFailed

Var /GLOBAL __Test_SingleTestHasFailed
Var /GLOBAL __Test_SingleTestAssertMessage

!insertmacro "ASSERT" `$__Test_SingleTestHasFailed` `$__Test_SingleTestAssertMessage`
!insertmacro "PRINT_TEST" `$__Test_TestName`

!macro InitiateTestingCall _logDir
  StrCpy $__Test_TestName ""
  StrCpy $__Test_TestHasFailed "0"
  StrCpy $__Test_TestSuccess "0"
  StrCpy $__Test_TestFailure "0"
  StrCpy $__Test_TestCount "0"

  ${LogSetOn} `${_logDir}`
  ${GetTimeStr} $__Test_TestStartTime
  ${PrintTestHeader}
!macroend

!macro StopTestingCall
  ${If} $__Test_TestHasFailed > 0
    SetErrorlevel 1
  ${Else}
    SetErrorlevel 0
  ${EndIf}

  ${GetTimeStr} $__Test_TestStopTime
  ${PrintTestFooter} $__Test_TestHasFailed $__Test_TestCount $__Test_TestSuccess $__Test_TestFailure $__Test_TestStartTime $__Test_TestStopTime
!macroend

!macro CreateTestCaseCall _testCaseName
  StrCpy $__Test_TestCaseHasFailed "0"
  StrCpy $__Test_TestCaseCount "0"
  StrCpy $__Test_TestCaseSuccess "0"
  StrCpy $__Test_TestCaseFailure "0"
  ${PrintTestCaseHeader} `${_testCaseName}`
!macroend

!macro EndTestCaseCall
  StrCpy $__Test_TestName `$__Test_TestName`
  ${If} $__Test_TestCaseFailure > 0
    StrCpy $__Test_TestHasFailed `1`
  ${EndIf}
  ;Overall test summary
  IntOp $__Test_TestCount $__Test_TestCount + $__Test_TestCaseCount
  IntOp $__Test_TestSuccess $__Test_TestSuccess + $__Test_TestCaseSuccess
  IntOp $__Test_TestFailure $__Test_TestFailure + $__Test_TestCaseFailure

  ${PrintTestCaseFooter} $__Test_TestCaseHasFailed $__Test_TestCaseCount $__Test_TestCaseSuccess $__Test_TestCaseFailure
!macroend

!macro TestCall _testName
  StrCpy $__Test_SingleTestHasFailed "0"
  StrCpy $__Test_SingleTestAssertMessage ``
  StrCpy $__Test_TestName "${_testName}"
  ${IncrementVar} $__Test_TestCaseCount
!macroend

!macro EndTestCall
  ${If} `$__Test_SingleTestHasFaile` == `1`
    StrCpy $__Test_TestCaseHasFailed `1`
    ${IncrementVar} $__Test_TestCaseFailure
    ${PrintTestFailed} `$__Test_SingleTestAssertMessage`
  ${Else}
    ${IncrementVar} $__Test_TestCaseSuccess
    ${PrintTestPassed}
  ${EndIf}
!macroend

!endif ;file