; 脚本由 Inno Setup 脚本向导 生成！
; 有关创建 Inno Setup 脚本文件的详细资料请查阅帮助文档！

[Setup]
; 注: AppId的值为单独标识该应用程序。
; 不要为其他安装程序使用相同的AppId值。
; (生成新的GUID，点击 工具|在IDE中生成GUID。)
AppId={{65AB20C7-ED13-4AB6-AFD8-F45DE60D6035}
AppName=HelloWorld
AppVersion=1.0
;AppVerName=HelloWorld 1.0
AppPublisher=张国栋
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
; 注意: 不要在任何共享系统文件上使用“Flags: ignoreversion”

[Icons]
Name: "{group}\HelloWorld"; Filename: "{app}\electron-quick-start.exe"
Name: "{commondesktop}\HelloWorld"; Filename: "{app}\electron-quick-start.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\HelloWorld"; Filename: "{app}\electron-quick-start.exe"; Tasks: quicklaunchicon
Name: "{group}\{cm:UninstallProgram,HelloWorld}"; Filename: "{uninstallexe}" 

[Run]
Filename: "{app}\electron-quick-start.exe"; Description: "{cm:LaunchProgram,HelloWorld}"; Flags: nowait postinstall skipifsilent

