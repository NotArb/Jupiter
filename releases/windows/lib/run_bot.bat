@echo off

rem Define lib path
set "lib_path=%~dp0"

rem Remove trailing slash from lib path if it exists
if "%lib_path:~-1%"=="\" (
    set "lib_path=%lib_path:~0,-1%"
)

rem Set bot_path to default path if not defined
if not defined bot_path (
    rem This default path is auto generated by our release task
    set "bot_path=%lib_path%\..\..\NotArbBot-0.0.5-alpha-jito-only"
)

rem Ensure bot_path file exists
if not exist "%bot_path%" (
    echo Error: bot_path file does not exist
    echo %bot_path%
    pause & exit
)

rem Ensure config_path is defined
if not defined config_path (
    echo Error: config_path not defined
    pause & exit
)

rem Ensure config_path file exists
if not exist %config_path% (
    echo Error: config_path file does not exist
    echo %config_path%
    pause & exit
)

rem Java exe check
if not defined java_exe_path (
    rem Attempt to install Java if necessary
    call "%lib_path%\install_java.bat"
) else (
    echo %java_exe_path%
    "%java_exe_path%" --version
    if %errorlevel% neq 0 (
        echo Warning: Java could not be verified.
    )
)

rem Java vm_args check
if "%~1"=="" (
    echo Warning: No vm_args set, this is not advised.
) else (
    echo vm_args=%*
)

rem Misc debug
echo bot_path=%bot_path%
echo config_path=%config_path%

rem Run bot
"%java_exe_path%" --enable-preview %* -Dcaller_script_dir="%CD%" -cp "%bot_path%" org.notarb.launcher.Main "%config_path%"
echo Bot exited with code %errorlevel%
pause
