@echo off
Setlocal EnableDelayedExpansion

set TITOLO=QUICK IP INTERFACE MANAGER
set TEMPLATES_FLD=templates
set EXTENSION=site
set INTNAME=Ethernet

:menu
setlocal
	call :print_header
	echo     [1] Exit
	echo     [2] Show INTERFACE Settings
	echo     [3] Set DHCP on Selected Interface
	echo     [4] Set STATIC IP from TEMPLATES 
	echo     [5] Set STATIC IP Manual Entry
	echo     [6] Show NEIGHBORS on Selected Interface (ARP Table)
	echo     [7] Save Setting to TEMPLATE
	echo     [8] Show HELP
	echo     [9] Reload MENU
	echo ======================================================================================
	choice -c 123456789 -n -m "   Choose an option: "
	echo ======================================================================================
	set userinput=%errorlevel%
	if %userinput%==1 (
		goto end
	) else if %userinput%==2 (
		netsh int sh int	
		set /p nomeInterfaccia = "Please Enter INTERFACE Name to be used [void no change]: "
		if not %nomeInterfaccia%=="" (
			call netsh int ip sh ipaddresses "%nomeInterfaccia%"
			if %ERRORLEVEL% == 0 (
				echo Setting %nomeInterfaccia% as Active Interface ...
				set INTNAME=%nomeInterfaccia%
			) else (
				echo ERROR: Interface %nomeInterfaccia% not found !
			)	
		)	
	) else if %userinput%==3 (
		echo Setting DHCP on Interface %INTNAME% ...
		netsh int ip set addr name=%INTNAME% source=dhcp	
	) else if %userinput%==4 (
		set /p nomeTemplate = "Please Enter TEMPLATE Name [void to cancel]:"
		if not %nomeTemplate%=="" (
			call :load_template %nomeSede%
		)		
	) else if %userinput%==5 (	
		call :add_manual
	) else if %userinput%==7 (
		netsh int ip sh neighbors "%INTNAME%"
	) else if %userinput%==8 (
		echo This script is based on NETSH Windows CLI Command, to change and show 
		echo connections interfaces.
		echo It's possible to create and use TEMPLATES for quickly set IP on Interfaces.
		echo All templates have extension .%EXTENSION% into %TEMPLATES_FLD%/ Folder.
		echo The script must be runned as Administrator.
		echo -------------------------------
		echo        TEMPLATE EXAMPLE
		echo -------------------------------
		echo NAME=My_Template
		echo IP=192.168.0.10
		echo MASK=255.255.255.0
		echo GW=192.168.0.1
		echo -------------------------------
		echo GITHUB: https://github.com/pax91/ip-manager 
	) else if %userinput%==9 (
		goto menu
	)
	echo ======================================================================================
	pause
	goto menu
exit /b 0

:print_header
setlocal
	title %TITOLO%
	cls
	echo
	echo ======================================================================================
	echo                             %TITOLO%       
	echo                             Made by PAX - Luca Passoni
	echo ======================================================================================	
	call :get_interface_settings %INTNAME%	
	echo     INTERFACE NAME  	: %_return1%
	echo     ADMIN STATE        : %_return2%
	echo     CONNECTION STATE   : %_return3%
	echo     DHCP ENABLED		: %_return4%
	echo     IP ADDRESS			: %_return5%
	echo     SUBNET MASK   		: %_return6%
	echo     DEFAULT GATEWAY	: %_return7%
	echo ======================================================================================
	if not exist %TEMPLATES_FLD%/ (
		echo Creating TEMPLATES Folder %TEMPLATES_FLD%/ ...
		mkdir %TEMPLATES_FLD%
	)
exit /b 0

:load_template
setlocal
	set filename= %TEMPLATES_FLD%/%1.%EXTENSION%
	set _name=
	set _ip=
	set _mask=
	set _gw=
	if exist %filename% (
		echo Loading TEMPLATE %filename% ...
		for /f "tokens=2 delims==" %i in ('findstr /c:"NAME" %filename%') do set _name=%i
		for /f "tokens=2 delims==" %i in ('findstr /c:"IP" %filename%') do set _ip=%i
		for /f "tokens=2 delims==" %i in ('findstr /c:"MASK" %filename%') do set _mask=%i
		for /f "tokens=2 delims==" %i in ('findstr /c:"GW" %filename%') do set _gw=%i
		echo NAME    : %_name%
		echo IP      : %_ip%
		echo MASK    : %_mask%
		echo GATEWAY : %_gw%
		set /p choice = "Apply Setting to Interface ? [Y/N]: "
		if /i "%choice%"=="Y" (
			call :set_ip %_ip% %_mask% %_gw% 
		)		
	) else (
		echo ERROR: %filename% not found !
		pause
	)
exit /b 0

:add_manual
setlocal
	call :print_header
	echo                            IP STATIC MANUAL SETTINGS
	echo ======================================================================================
	set /p _ip = "    IP        : "
	set /p _mk = "    MASK      : "
	set /p _gw = "    GW        : "
	echo ======================================================================================
	set /p choice = "Apply Setting to Interface ? [Y/N]: "
	if /i "%choice%"=="Y" (
		call :set_ip %_ip% %_mask% %_gw% 
	)	
exit /b 0

:save_template
setlocal
	set _name=%1
	set _ip=%2
	set _mask=%3
	set _gw=%4
	set filename=%SEDI_FLD%/%_name%.%EXTENSION%
	if exist %filename% (
		echo Replacing %filename% ...
	) else (
		echo Creating %filename% ...
	)
	echo NAME=%_name% > %filename%
	echo IP=%_ip% >> %filename%
	echo MASK=%_mask% >> %filename%
	echo GW=%_gw% >> %filename%
exit /b 0

:set_ip
setlocal
	set _ip=%1
	set _mask=%2
	set _gw=%3
	if not %_ip%=="" if not %_mask%=="" (
		echo Setting STATIC IP: %_ip% %_mask% %_gw%
		if %_gw%=="" (
			netsh int ip set addr name=%INTNAME% source=static addr=%_ip% mask=%_mask%
		) else (
			netsh int ip set addr name=%INTNAME% source=static addr=%_ip% mask=%_mask% gateway=%_gw% gwmetric=0
		)				
		pause
	) else (
		echo ERROR: Missing IP and MASK !
		pause
	)
exit /b 0

:get_interface_settings
setlocal
	set temp_file=temp_int_settings.txt
	set _intname=%1
	set _adminstate=
	set _connectionstate=
	set _dhcp=
	set _ip=
	set _mask=
	set _gw=
	:: Retrieving Interface States
	netsh int sh int "%_intname%" > %temp_file%
	:: Checking Interface Admin State
	for /f "tokens=3 delims=: " %i in ('findstr /c:"Stato amministrativo" %temp_file%') do set _adminstate=%i
	:: Getting Interface Connection State
	for /f "tokens=3 delims=: " %i in ('findstr /c:"Stato di connessione" %temp_file%') do set _connectionstate=%i
	:: Retrieving Interface Configurations
	netsh int ip sh conf "%_intname%" > %temp_file%
	:: Checking if DHCP is enabled or not
	for /f "tokens=3 delims=: " %i in ('findstr /c:"DHCP abilitato" %temp_file%') do set _dhcp=%i
	:: Getting IP Address
	for /f "tokens=3 delims=: " %i in ('findstr /c:"Indirizzo IP" %temp_file%') do set _ip=%i
	:: Getting Subnet MASK
	for /f "tokens=5 delims=) " %i in ('findstr /c:"maschera" %temp_file%') do set _mask=%i
	:: Getting GATEWAY Address
	for /f "tokens=3 delims=: " %i in ('findstr /c:"Gateway predefinito" %temp_file%') do set _gw=%i
	:: Removing TEMP file
	if exist %temp_file% del %temp_file%
Endlocal & (
    set "_return1=%_intname%"
    set "_return2=%_adminstate%"
    set "_return3=%_connectionstate%"
    set "_return4=%_dhcp%"
    set "_return5=%_ip%"
    set "_return6=%_mask%"
    set "_return7=%_gw%"
)

:end
echo ""
echo Exiting Program ...
sleep 3
exit 
