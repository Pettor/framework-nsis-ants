!ifndef PRINT_NSH
!define PRINT_NSH

!include "StringUtils.nsh"
!include "Console.nsh"
!include "TextLog.nsh"

!insertmacro "STRING_UTILS" ""

/*#==============================#::
 PRINT TEST HEADER
 Used to print a test header
#==============================#*/
!define PrintTestHeader '!insertmacro PrintTestHeaderCall'

/*#==============================#::
 PRINT TEST FOOTER
 Used to print a test footer
#==============================#*/
!define PrintTestFooter '!insertmacro PrintTestFooterCall'

/*#==============================#::
 PRINT TEST CASE HEADER
 Used to print a test case header
 param: Test case name
#==============================#*/
!define PrintTestCaseHeader '!insertmacro PrintTestCaseHeaderCall'

/*#==============================#::
 PRINT TEST CASE FOOTER
 Used to print a test case footer
 param: If test case failed
 param: Number of tests in test case
 param: Number of passed tests
 param: Number of failed tests
#==============================#*/
!define PrintTestCaseFooter '!insertmacro PrintTestCaseFooterCall'

/*#==============================#::
 PRINT AND LOG
 Print and log text to console and file
 param: Message to log
#==============================#*/
!define PrintAndLog '!insertmacro _PrintAndLogGenericCall `0` `0` `0`'

/*#==============================#::
 PRINT AND LOG HEADING
 param: Message to log
#==============================#*/
!define PrintAndLogHeading '!insertmacro _PrintAndLogGenericCall `1` `0` `0`'

/*#==============================#::
 PRINT AND LOG A PASSED TEST
 param: Message to log
#==============================#*/
!define PrintAndLogPassed '!insertmacro _PrintAndLogGenericCall `0` `1` `0`'

/*#==============================#::
 PRINT AND LOG A FAILED TEST
 param: Message to log
#==============================#*/
!define PrintAndLogFailed '!insertmacro _PrintAndLogGenericCall `0` `0` `1`'

; Used to insert correct number of tabs for console print
!define TAB_BREAK_LEN_1 8
!define TAB_BREAK_LEN_2 16
!define TAB_BREAK_LEN_3 24
!define TAB_BREAK_LEN_4 32
!define TAB_BREAK_LEN_5 40
!define TAB_BREAK_LEN_6 48

Var /GLOBAL __Print_GenVar0
Var /GLOBAL __Print_GenVar1
Var /GLOBAL __Print_GenVar2

!macro PrintTestHeaderCall
  ${LogEnableTestLogOnly}
  ${PrintAndLog} '$\r$\n'
!macroend

!macro PrintTestFooterCall _failed _testCount _testSuccessCount _testSuccessFailure _startTime _endTime
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLogHeading} 'Test run summary:'
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLog} '  Overall result: '
  ${If} ${_failed} == 1
    ${PrintAndLogFailed} 'Failed'
  ${Else}
    ${PrintAndLogPassed} 'Passed'
  ${EndIf}
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLog} '  Test count: ${_testCount}, Passed: ${_testSuccessCount}, Failed: ${_testSuccessFailure}'
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLog} '  Start time: ${_startTime}'
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLog} '    End time: ${_endTime}'
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLog} '$\r$\n'
!macroend

!macro PrintTestCaseHeaderCall _testCaseName
  ${StrCase} $__Print_GenVar0 "${_testCaseName}" "L"
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLogHeading} 'Test start: "$__Print_GenVar0"'
!macroend

!macro PrintTestCaseFooterCall _failed _testCount _testSuccessCount _testSuccessFailure
  ${PrintAndLog} '$\r$\n'
  ${PrintAndLog} 'Overall result: '
  ${If} ${_failed} == 1
    ${PrintAndLogFailed} 'Failed'
  ${Else}
    ${PrintAndLogPassed} 'Passed'
  ${EndIf}
  ${PrintAndLog} ', Test count: ${_testCount}, Passed: ${_testSuccessCount}, Failed: ${_testSuccessFailure}'
  ${PrintAndLog} '$\r$\n'
!macroend

!macro PRINT_TEST _testName

/*#==============================#::
 PRINT TEST PASSED
#==============================#*/
!define PrintTestPassed '!insertmacro PrintTestPassedCall'

/*#==============================#::
 PRINT TEST FAILED
#==============================#*/
!define PrintTestFailed '!insertmacro PrintTestFailedCall'
!define _PrintTestGeneric '!insertmacro _PrintTestGenericCall ${_testName}'

!macroend

!macro PrintTestPassedCall
  ${_PrintTestGeneric} `passed` `0`
!macroend

!macro PrintTestFailedCall _message
  ${_PrintTestGeneric} `failed$\t(${_message})` `1`
!macroend

!macro _PrintTestGenericCall _testName _message _failed
  StrCpy $__Print_GenVar0 `  ${_testName}`
  StrLen $__Print_GenVar2 `$__Print_GenVar0`

  ${If} $__Print_GenVar2 >= ${TAB_BREAK_LEN_6}
    StrCpy $__Print_GenVar1 "$\t"
  ${ElseIf} $__Print_GenVar2 >= ${TAB_BREAK_LEN_5}
    StrCpy $__Print_GenVar1 "$\t$\t"      
  ${ElseIf} $__Print_GenVar2 >= ${TAB_BREAK_LEN_4}
    StrCpy $__Print_GenVar1 "$\t$\t$\t"  
  ${ElseIf} $__Print_GenVar2 >= ${TAB_BREAK_LEN_3}
    StrCpy $__Print_GenVar1 "$\t$\t$\t$\t"
  ${ElseIf} $__Print_GenVar2 >= ${TAB_BREAK_LEN_2}
    StrCpy $__Print_GenVar1 "$\t$\t$\t$\t$\t"
  ${ElseIf} $__Print_GenVar2 >= ${TAB_BREAK_LEN_1}
    StrCpy $__Print_GenVar1 "$\t$\t$\t$\t$\t$\t"
  ${Else}
    StrCpy $__Print_GenVar1 "$\t$\t$\t$\t$\t$\t$\t"
  ${EndIf}

  ${PrintAndLog} `$\r$\n$__Print_GenVar0$__Print_GenVar1`
  ${If} `${_failed}` == `1`
    ${PrintAndLogFailed} `${_message}`
  ${Else}
    ${PrintAndLogPassed} `${_message}`
  ${EndIf}
!macroend

/*#==============================#::
 PRINT AND LOG
 Print and log text to console and file
 param: If print is a header
 param: Number of passed tests
 param: Number of failed tests
 param: Message to log
#==============================#*/
!macro _PrintAndLogGenericCall _heading _passed _failed _message
  ${If} `${_heading}` == `1`
    ${ConsolePrintHeading} `${_message}`
  ${ElseIf} "${_passed}" == "1"
    ${ConsolePrintPassed} `${_message}`
  ${ElseIf} "${_failed}" == `1`
    ${ConsolePrintFailed} `${_message}`
  ${Else}
    ${ConsolePrint} `${_message}`
  ${EndIf}
  ${LogTextTest} `${_message}`
!macroend

!endif
