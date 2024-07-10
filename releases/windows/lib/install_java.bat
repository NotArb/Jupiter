@echo off
setlocal enabledelayedexpansion

rem The url to the java archive to download
set java_url=https://download.java.net/java/GA/jdk22.0.1/c7ec1332f7bb44aeba2eb341ae18aca4/8/GPL/openjdk-22.0.1_windows-x64_bin.zip

rem This must match the folder name being extracted from the java url archive
set archive_folder=jdk-22.0.1

rem The path to the downloaded and extracted java archive
set java_path=%CD%\%archive_folder%

rem Check if exe already exists and is valid
if exist "%java_path%\bin\java.exe" (
    echo Checking existing java.exe...
    "%java_path%\bin\java.exe" --version
    if !errorlevel! == 0 (
        echo %java_path%\bin\java.exe
        endlocal
        goto :eof
    )
    echo Existing java.exe is corrupt or not functioning, re-downloading...
)

rem Download and extract Java using PowerShell
powershell -Command ^
    "$tempFile = '%CD%\java_download_temp.zip'; " ^
    "Invoke-WebRequest -Uri '%java_url%' -OutFile $tempFile; " ^
    "Expand-Archive -Path $tempFile -DestinationPath '%CD%' -Force; " ^
    "Remove-Item -Force $tempFile;"

echo %java_path%\bin\java.exe
endlocal
goto :eof