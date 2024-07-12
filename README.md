# QUICK IP INTERFACE MANAGER
## © made by PAX - Luca Passoni

GITHUB: https://github.com/pax91/ip-manager

### Installation
Download and execute the .bat file as Administrator, the script will create a new Templates folder in running Directory.
If you want to run directly the script from the CMD, just copy the .bat file into System32 Folder and call ip_manager.bat from CMD.

### Description
This script is based on NETSH Windows CLI Command, to change and show connections interfaces.
It's possible to create and use TEMPLATES for quickly set IP on Interfaces.
All templates have extension .site into templates/ Folder.

### Menu Description
The script let you make al actions asking you to choose a Menu option.
Below all menu options description
#### [1] Exit                                                  
Exit the program
#### [2] Show INTERFACE Settings                               
List Interfaces and let you choose to change active
#### [3] Set DHCP on Selected Interface                        
Set DHCP on selected Interface
#### [4] Set STATIC IP from TEMPLATES                          
Let you enter a Template filename and apply it
#### [5] Set STATIC IP Manual Entry                            
Let you manually enter a Static IP
#### [6] Show NEIGHBORS on Selected Interface (ARP Table)      
Display Neighbors (ARP Table) on Interface
#### [7] Save Setting to TEMPLATE                              
Save current IP, MASK and GW on a Template
#### [8] Show HELP                                             
Display HELP
#### [9] Reload MENU                                           
Reload MENu and Interface Settings display


### Template File Example
```
NAME=My_Template
IP=192.168.0.10
MASK=255.255.255.0
GW=192.168.0.1
```
