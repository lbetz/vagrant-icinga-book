@echo on
start /wait C:\vagrant\scripts\vcredist_x64.exe /install /quiet

choco install -y puppet-agent
