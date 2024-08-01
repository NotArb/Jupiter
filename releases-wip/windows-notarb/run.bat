@echo off

rem The path to the bot file (required)
set "bot_path=..\NotArb-0.1.9-alpha"

rem The path to the bot config file (required)
set "config_path=..\example-config.toml"

rem The path to the java exe file (optional)
set "java_exe_path="

rem Call the launch_bot.bat script with the specified VM arguments (https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java)
call ".\launch_bot.bat" -Xmx1024m