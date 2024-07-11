@echo off

if not defined cur_path (
    set standalone=1

    rem Define cur path
    set "cur_path=%~dp0"

    rem Remove trailing slash from cur path if it exists
    if "%cur_path:~-1%"=="\" (
        set "cur_path=%cur_path:~0,-1%"
    )
)

rem The url of the java archive to download
set "java_url=https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_windows-x64_bin.zip"

rem This must match the folder name being extracted from the java url archive
set "archive_folder=jdk-22.0.1"

rem The path of the executable java file
set "java_exe_path=%cur_path%\%archive_folder%\bin\java.exe"

rem Check if Java is valid
"%java_exe_path%" --version

rem Install Java if error from --version check
if %errorlevel% neq 0 (
    echo Installing Java, please wait...
    echo %java_url%

    rem Download and extract Java using PowerShell
    powershell -Command ^
        "$tempFile = '%cur_path%\java_download_temp.zip'; " ^
        "Invoke-WebRequest -Uri '%java_url%' -OutFile $tempFile; " ^
        "Expand-Archive -Path $tempFile -DestinationPath '%cur_path%' -Force; " ^
        "Remove-Item -Force $tempFile;"
)

if defined standalone (
    pause
)