# QUICK IP INTERFACE MANAGER
## © made by PAX - Luca Passoni

GITHUB: https://github.com/pax91/ip-manager

### Installation
Download and execute the .bat file as Administrator, the script will create a new Templates folder in running Directory.
If you want to run directly the script from the CMD, just copy the .bat file into System32 Folder and call ip_manager.bat from CMD.

### Description
This script is based on NETSH Windows CLI Command, to change and show connections interfaces.
It's possible to create and use TEMPLATES for quickly set IP on Interfaces.
All templates have extension .%EXTENSION% into %TEMPLATES_FLD%/ Folder.
### Template File Example
NAME=My_Template
IP=192.168.0.10
MASK=255.255.255.0
GW=192.168.0.1
