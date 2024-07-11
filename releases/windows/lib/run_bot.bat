@echo off

rem Define caller path, passed to bot for locating config files
set "caller_path=%CD%"

rem Define cur path
set "cur_path=%~dp0"

rem Remove trailing slash from cur path if it exists
if "%cur_path:~-1%"=="\" (
    set "cur_path=%cur_path:~0,-1%"
)

if not defined config_path (
    echo Error: config_path not defined
    pause
    exit
)

if not defined vm_args (
    echo Warning: vm_args not defined
    set "vm_args="
)

if not defined bot_args (
    set "bot_args="
)

if not defined bot_path (
    rem If bot_path is not set from caller, it will default to the last defined release
    set "bot_path=%caller_path%\..\NotArbBot-0.0.1-alpha"
)

if not defined java_exe_path (
    rem Attempt to install Java if necessary
    call "%cur_path%\install_java.bat"
)

echo %java_exe_path%
"%java_exe_path%" --version

echo %bot_path%

"%java_exe_path%" %vm_args% -cp "%bot_path%" org.notarb.launcher.Main %bot_args%