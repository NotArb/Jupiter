@echo off

rem The path to the bot file (required)
set "bot_path=..\notarb-0.1.43-alpha"

rem The path to the bot config file (required)
set "config_path=..\temp-config.toml"

rem The path to the java exe file (optional)
set "java_exe_path="

rem Move to the correct workdir to prevent path issues
cd /d "%~dp0"

rem Call the notarb_java.bat script with the specified VM arguments
rem We highly recommend you increase the -Xmx value to better fit your system. Refer to other VM args here:
rem https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java
call ".\notarb_java.bat" ^
    -server ^
    -Xms256m -Xmx2048m ^
    -XX:+UseSerialGC
