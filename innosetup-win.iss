; �ű��� Inno Setup �ű��� ���ɣ�
; �йش��� Inno Setup �ű��ļ�����ϸ��������İ����ĵ���

[Setup]
; ע: AppId��ֵΪ������ʶ��Ӧ�ó���
; ��ҪΪ������װ����ʹ����ͬ��AppIdֵ��
; (�����µ�GUID����� ����|��IDE������GUID��)
AppId={{65AB20C7-ED13-4AB6-AFD8-F45DE60D6035}
AppName=HelloWorld
AppVersion=1.0
;AppVerName=HelloWorld 1.0
AppPublisher=�Ź���
AppPublisherURL=http://lanmiao.oschina.io/
AppSupportURL=http://lanmiao.oschina.io/
AppUpdatesURL=http://lanmiao.oschina.io/
DefaultDirName={pf}\HelloWorld
DefaultGroupName=HelloWorld
OutputDir=G:\practiceSpace\electron-quick-start-master\out
OutputBaseFilename=HelloWorld
SetupIconFile=G:\practiceSpace\electron-quick-start-master\icon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "G:\practiceSpace\electron-quick-start-master\out\electron-quick-start-win32-ia32\electron-quick-start.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "G:\practiceSpace\electron-quick-start-master\out\electron-quick-start-win32-ia32\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; ע��: ��Ҫ���κι���ϵͳ�ļ���ʹ�á�Flags: ignoreversion��

[Icons]
Name: "{group}\HelloWorld"; Filename: "{app}\electron-quick-start.exe"
Name: "{commondesktop}\HelloWorld"; Filename: "{app}\electron-quick-start.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\HelloWorld"; Filename: "{app}\electron-quick-start.exe"; Tasks: quicklaunchicon
Name: "{group}\{cm:UninstallProgram,HelloWorld}"; Filename: "{uninstallexe}" 

[Run]
Filename: "{app}\electron-quick-start.exe"; Description: "{cm:LaunchProgram,HelloWorld}"; Flags: nowait postinstall skipifsilent

