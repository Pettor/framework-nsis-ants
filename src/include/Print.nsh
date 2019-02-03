!ifndef PRINT_NSH
!define PRINT_NSH

!define PrintTestCaseResult '!insertmacro PrintTestCaseResultCall'
!define PrintTestCaseSuccess '!insertmacro PrintTestCaseSuccessCall'
!define PrintTestCaseError '!insertmacro PrintTestCaseErrorCall'

!macro PrintTestCaseResultCall _message
  System::Call "kernel32::AttachConsole(i -1)i .r0"
  System::Call "kernel32::GetStdHandle(i -11)i .r0"
  ;To choose color goto (https://www.miniwebtool.com/bitwise-calculator)
  ;for colors: (https://docs.microsoft.com/en-us/dotnet/api/system.consolecolor?redirectedfrom=MSDN&view=netframework-4.7.2)
  ;do bitwise operator like 1100 (12 red in binary) and 11110000 (15 white in binary) for red text and white background
  System::Call "kernel32::SetConsoleTextAttribute(i $0, i 1111)i .r1"
  System::Call "*(i 0)i .r1"
  FileWrite $0 '$\r$\n'
  FileWrite $0 '=================================================='
  FileWrite $0 '$\r$\n'
  System::Call "kernel32::SetConsoleTextAttribute(i $0, i 50)i .r1"
  FileWrite $0 '${_message}'
  System::Call "kernel32::SetConsoleTextAttribute(i $0, i 1111)i .r1"
  FileWrite $0 '$\r$\n'
  System::Free $1
  System::Call "kernel32::FreeConsole()"
  FileClose $0
!macroend

!macro PrintTestCaseSuccessCall
  ${PrintTestCaseResult} '$TestName succeeded'
!macroend

!macro PrintTestCaseErrorCall _message
  ${PrintTestCaseResult} '$TestName failed with message: ${_message}'
!macroend

!endif
