@echo off
pushd %~dp0

powershell -ExecutionPolicy RemoteSigned -WindowStyle Hidden -File ".\PsFlipWindow.ps1"
rem powershell -ExecutionPolicy RemoteSigned -File ".\PsFlipWindow.ps1"

popd
rem pause
