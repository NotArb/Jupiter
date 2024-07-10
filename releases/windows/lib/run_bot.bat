@echo off
setlocal

rem Define lib path to be used instead of %CD% to allow this script to be called from an outside package
set "lib_path=%~dp0"

rem Remove trailing slash from lib path
set "lib_path=%lib_path:~0,-1%"

rem This is automatically assigned per release, change manually to use a different version
set "not_arb_path=%lib_path%\..\..\NotArbBot-0.0.1-alpha"

rem Either provide your own java path (at least jdk22) or leave empty to auto install Java
set "java_exe_path="

rem If java_exe_path is empty, run install_java.bat and capture the output
if "%java_exe_path%"=="" (
    echo Checking for Java installation...
    for /f "delims=" %%i in ('call "%lib_path%\install_java.bat"') do (
        set "java_exe_path=%%i"
    )
)

rem Print java info for debug purposes
echo %java_exe_path%
%java_exe_path% --version

rem More debug prints
echo %not_arb_path%
if "%1"=="" (echo No config file provided.) else (echo %1)

rem Run the bot launcher with the provided configuration file arg
"%java_exe_path%" -cp "%not_arb_path%" org.notarb.launcher.Main "%1"

endlocal
pause