@ECHO OFF
::��ַ: nat.ee
::QQȺ: 6281379
::TGȺ: https://t.me/nat_ee
::������: ��ҫ&���� QQ:1800619
>nul 2>&1 "%SYSTEMROOT%\system32\caCLS.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
GOTO UACPrompt
) ELSE ( GOTO gotAdmin )
:UACPrompt
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
ECHO UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
title nat.ee
mode con: cols=36 lines=8
color 17
SET "wall=HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"
SET "rdp=HKLM\SYSTEM\ControlSet001\Control\Terminal Server"
:Menu
CLS
ECHO.
ECHO 1.�޸�Զ������˿�
ECHO.
ECHO 2.�޸��û�����
ECHO.
ECHO 3.���������
ECHO.
choice /C:123 /N /M "���������ѡ�� [1,2,3]": 
if errorlevel 3 GOTO:Restart
if errorlevel 2 GOTO:Password
if errorlevel 1 GOTO:RemotePort
:RemotePort
SET Port=3389
CLS
ECHO �޸�Զ������˿�
ECHO.
ECHO ����^" q ^"�������˵�
ECHO ����Ĭ��ʹ�� 3389 �˿�
ECHO ���س��� (Enter) ȷ��
ECHO.
SET /P "Port=�Զ���˿ڷ�Χ(1-65535):"
ECHO;%Port%|find " "&&goto:RemotePort
ECHO;%Port%|findstr "^0.*"&&goto:RemotePort
IF "%Port%" == "q" (GOTO:Menu)
IF "%Port%" == "0" (GOTO:RemotePort)
IF "%Port%" == "" (SET Port=3389)
IF %Port% LEQ 65535 (
Reg add "%rdp%\Wds\rdpwd\Tds\tcp" /v "PortNumber" /t REG_DWORD /d "%Port%" /f  > nul
Reg add "%rdp%\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d "%Port%" /f  > NUL
Reg add "%wall%" /v "{338933891-3389-3389-3389-338933893389}" /t REG_SZ /d "v2.29|Action=Allow|Active=TRUE|Dir=In|Protocol=6|LPort=%Port%|Name=Remote Desktop(TCP-In)|" /f
Reg add "%wall%" /v "{338933892-3389-3389-3389-338933893389}" /t REG_SZ /d "v2.29|Action=Allow|Active=TRUE|Dir=In|Protocol=17|LPort=%Port%|Name=Remote Desktop(UDP-In)|" /f
CLS
ECHO.
ECHO �޸ĳɹ���
ECHO.
ECHO ���μǣ����Զ�̶˿���: %Port% 
ECHO.
ECHO �����������Ч��
TIMEOUT 5 >NUL
GOTO:Menu
) ELSE (
CLS
ECHO.
ECHO ����˿�: %Port% 
ECHO ���������õķ�Χ��
ECHO ����^"1 - 65535^"�ڡ�
TIMEOUT 3 >NUL
GOTO:RemotePort
)
:Password
SET pwd1=
SET pwd2=
CLS
ECHO �޸ĵ�ǰ�û�: %username% ������
ECHO.
ECHO ����^" q ^"�������˵�
ECHO ���س��� (Enter) ȷ��
ECHO.
SET /p pwd1=������������: 
IF "%pwd1%" == "q" (GOTO:Menu)
CLS
ECHO.
ECHO ����^" q ^"�������˵�
ECHO ���س��� (Enter) ȷ��
ECHO.
SET /p pwd2=���ٴ���������: 
IF "%pwd2%" == "q" (GOTO:Menu)
IF "%pwd1%" == "%pwd2%" (
CLS
net user "%username%" "%pwd2%"||PAUSE&&GOTO:Password
ECHO.
TIMEOUT 3 >NUL
GOTO:Menu
) ELSE (
CLS
ECHO.
ECHO ����������������롣
TIMEOUT 3 >NUL
GOTO:Password
)
:Restart
CLS
ECHO ���ڵ���ʱ��������
TIMEOUT /t 5
shutdown.exe /r /f /t 0
EXIT