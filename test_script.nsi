;The name of the installer
Name "test"

;The file to write
OutFile "output\test.exe"

!include "MUI2.nsh"
!define MUI_ICON "resources\ants.ico"
!define MUI_UNICON "resources\ants.ico"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

;The default installation directory
InstallDir $TEMP\AppGateTestInstaller
RequestExecutionLevel user

!addincludedir "include\test"

;Includes for tests
!include "LogicLib.nsh"
!include "Test.nsh"

Function .onInit
  ${InitiateTesting} `output\test.log`
  ;Put test code here
  ${ExitTesting}
FunctionEnd

Section ""
  quit
SectionEnd

Section "WriteUninstaller"
  WriteUninstaller "$EXEDIR\Uninstaller.exe"
  quit
SectionEnd