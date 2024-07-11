@echo off

rem The path to the bot file (optional)
set "bot_path="

rem The path to the bot config file (required)
set "config_path=..\example-config.toml"

rem The path to the java exe file (optional)
set "java_exe_path="

rem Call the run_bot.bat script with the specified VM arguments
call ".\lib\run_bot.bat" -Xmx512m