@echo off
    
start .\llamacpp\llama-server.exe  --models-dir ./models --host 127.0.0.1 --port 8033 -ngl 99

pause
