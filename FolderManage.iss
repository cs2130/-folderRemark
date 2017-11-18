; �ű��� Inno Setup �ű��� ���ɣ�
; �йش��� Inno Setup �ű��ļ�����ϸ��������İ����ĵ���

#define MyAppName "�ļ��б�ע"
#define MyAppVersion "1.0"
#define MyAppPublisher "�۴�"
#define MyAppExeName "FolderManage.exe"

[Setup]
; ע: AppId��ֵΪ������ʶ��Ӧ�ó���
; ��ҪΪ������װ����ʹ����ͬ��AppIdֵ��
; (�����µ�GUID����� ����|��IDE������GUID��)
AppId={{62CA26F3-C6AD-4597-94E1-41810E6C0011}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={pf}\foldertool
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
InfoBeforeFile=F:\project\WinTool\doc\show_one.txt
OutputDir=C:\Users\Administrator\Desktop
OutputBaseFilename=�ļ��б�ע��װ
SetupIconFile=F:\project\WinTool\Desktop.ico
Compression=lzma
SolidCompression=yes
WizardImageFile=compiler:WizModernImage-Is.bmp
WizardSmallImageFile=compiler:WizModernSmallImage-IS.bmp

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked;
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Add the ISSkin DLL used for skinning Inno Setup installations.
Source: compiler:ISSkin.dll; DestDir: {app}; Flags: dontcopy

; Add the Visual Style resource contains resources used for skinning,
; you can also use Microsoft Visual Styles (*.msstyles) resources.
Source: compiler:IsSkins\Codejock.cjstyles; DestDir: {tmp}; Flags: dontcopy

Source: "F:\project\WinTool\Release\FolderTool.dll"; DestDir: "{app}"; Flags:   ignoreversion   regserver
Source: "F:\project\WinTool\Release\FolderManage.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\project\WinTool\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; ע��: ��Ҫ���κι���ϵͳ�ļ���ʹ�á�Flags: ignoreversion��

[Registry]
Root: HKCU; Subkey: "Software\FolderTool"; ValueType: string; ValueName: "LOAD"; ValueData: "{app}\WinTool.exe"; Flags: uninsdeletekey

[Code]
// Importing LoadSkin API from ISSkin.DLL
procedure LoadSkin(lpszPath: AnsiString; lpszIniFileName: AnsiString);
external 'LoadSkin@files:isskin.dll stdcall';

// Importing UnloadSkin API from ISSkin.DLL
procedure UnloadSkin();
external 'UnloadSkin@files:isskin.dll stdcall';

// Importing ShowWindow Windows API from User32.DLL
function ShowWindow(hWnd: Integer; uType: Integer): Integer;
external 'ShowWindow@user32.dll stdcall';

procedure RegeditWrite(); 
var
strPth: string;
begin
  strPth := '{app}/WinTool.exe';
  RegWriteStringValue(HKCU, 'Software\FolderTool','LOAD', strPth);
end;

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('Codejock.cjstyles');
	LoadSkin(AnsiString(ExpandConstant('{tmp}\Codejock.cjstyles')), '');
  //RegeditWrite();
	Result := True;
end;

procedure DeinitializeSetup();
begin
	// Hide Window before unloading skin so user does not get
	// a glimse of an unskinned window before it is closed.
	ShowWindow(StrToInt(ExpandConstant('{wizardhwnd}')), 0);
	UnloadSkin();
end;

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; WorkingDir: "{app}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

