; The name of the installer
Name "test"

; The file to write
OutFile "..\output\test.exe"

; The default installation directory
InstallDir $TEMP\ncts-temp
RequestExecutionLevel user

!addincludedir "include"
!include "Test.nsh"

Function .onInit
FunctionEnd

Section ""
	quit
SectionEnd