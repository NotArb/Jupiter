@echo off

rem The url of the java archive to download
set "java_url=https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_windows-x64_bin.zip"

rem This must match the folder name being extracted from the java url archive
set "java_folder=jdk-22.0.1"

rem The path of the executable java file
set "java_exe_path=%~dp0%java_folder%\bin\java.exe"

rem Verify existing Java executable
if exist "%java_exe_path%" (
    echo %java_exe_path%
    "%java_exe_path%" --version
    if %errorlevel% == 0 (
        echo Java installation not required.
        goto :eof
    )
)

echo Installing Java, please wait...
echo %java_url%

rem Skip several lines because of PowerShell overlay
echo.
echo.
echo.

rem Download and extract Java using PowerShell
powershell -Command ^
    "$tempFile = '%~dp0java_download_temp.zip'; " ^
    "Invoke-WebRequest -Uri '%java_url%' -OutFile $tempFile; " ^
    "Expand-Archive -Path $tempFile -DestinationPath '%~dp0' -Force; " ^
    "Remove-Item -Force $tempFile;"

rem Verify installed java exe
echo %java_exe_path%
"%java_exe_path%" --version
if %errorlevel% == 0 (
    echo Java installation successful!
) else (
    echo Warning: Java installation could not be verified!
    pause
)