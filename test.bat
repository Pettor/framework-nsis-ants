@echo off
setlocal enabledelayedexpansion

:: Create test installer
call makensis.exe test_script.nsi

:: Run installer
start "" /WAIT "output\test.exe"

if not "%errorlevel%" == "0" (
	echo.
	echo [91m[0m
	echo [91m============================[0m
	echo [91mInstaller tests failed![0m
	echo [91m============================[0m
	echo.
	Exit /B 1
)

endlocal

Exit /B 0