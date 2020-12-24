@echo off
cd MicroBloggerCore
start cmd.exe /k start.bat
start cmd.exe /k "ngrok http localhost:5000"
cd ..
cd Microblogger
start cmd.exe /k "code ."
