@echo off
setlocal enabledelayedexpansion

if not exist "output" (mkdir "output")

:: Create test installer
call makensis.exe test_script.nsi

if not "%errorlevel%" == "0" (
	Exit /B 1
)

:: Run installer
call "output\test.exe"

if not "%errorlevel%" == "0" (
	Exit /B 1
)

endlocal

Exit /B 0