@echo off

rem The path to the bot file (optional)
set "BOT_PATH="

rem The path to the bot config file (required)
set "CONFIG_PATH=..\example-config.toml"

rem The path to the java exe file (optional)
set "JAVA_EXE_PATH="

rem Call the run_bot.bat script with the specified VM arguments
call ".\lib\run_bot.bat" -Xmx512m