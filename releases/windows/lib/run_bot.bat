@echo off

rem This is assigned per release, change manually to use a different version
set not_arb_path=%CD%\..\..\NotArbBot-0.0.1-alpha

rem Either provide your own java path (at least jdk22) or leave empty to auto install Java
set java_exe_path=

rem If java_exe_path is empty, run install_java.bat and capture the output
if "%java_exe_path%"=="" (
    for /f "delims=" %%i in ('call "%CD%\install_java.bat"') do (
        set java_exe_path=%%i
    )
    echo Java installed at: %java_exe_path%
)

rem Run the bot launcher with the provided configuration file arg
"%java_exe_path%" -cp "%not_arb_path%" org.notarb.launcher.Main %1
pause