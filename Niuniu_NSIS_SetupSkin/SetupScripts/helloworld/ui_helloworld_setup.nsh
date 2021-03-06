﻿
# ===================== External plug-ins and macros =============================
!include "StrFunc.nsh"
!include "WordFunc.nsh"
; ${StrRep}
; ${StrStr}
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "common.nsh"
!include "x64.nsh"
!include "MUI.nsh"
!include "WinVer.nsh" 
!include "..\commonfunc.nsh"
!define APP_SIZE "30M"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "English"
# ===================== Install package version =============================
VIProductVersion             		"${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion"    "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName"       "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName"       "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion"       "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName"      "${EXE_NAME}"
VIAddVersionKey "FileDescription"   "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright"    "${PRODUCT_LEGAL}"

!define INSTALL_PAGE_CONFIG 			0
;!define INSTALL_PAGE_LICENSE 			1
!define INSTALL_PAGE_PROCESSING 		1
!define INSTALL_PAGE_FINISH 			2
!define INSTALL_PAGE_UNISTCONFIG 		3
!define INSTALL_PAGE_UNISTPROCESSING 	4
!define INSTALL_PAGE_UNISTFINISH 		5

# Custom page
Page custom DUIPage

# Uninstaller shows progress
UninstPage custom un.DUIPage

# ======================= DUILIB Custom page =========================
Var hInstallDlg
Var hInstallSubDlg
Var sCmdFlag
Var sCmdSetupPath
Var sSetupPath 
Var sReserveData   #Whether to keep data when uninstalling 
Var InstallState   #Is it being installed or is it installed  
Var UnInstallValue  #Uninstall progress  

Var temp11
Var temp12

Function .onInit
	InitPluginsDir ;
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

!include "Messages.nsi"
Function DUIPage
    StrCpy $InstallState "0"	#Set the status of not installed
	InitPluginsDir   	
	SetOutPath "$PLUGINSDIR"
	File "${INSTALL_LICENCE_FILENAME}"
    File "${INSTALL_RES_PATH}"
	File /oname=logo.ico "${INSTALL_ICO}" 		#The target file here must be logo.ico, otherwise the control will not find the file
	nsNiuniuSkin::InitSkinPage "$PLUGINSDIR\" "${INSTALL_LICENCE_FILENAME}" #Specify the plugin path and protocol file name
    Pop $hInstallDlg
   	
	#Generate the installation path, including identifying the old installation path  
    Call GenerateSetupAddress
	
	#Set the control to display the installation path
    nsNiuniuSkin::SetControlAttribute $hInstallDlg "editDir" "text" "$INSTDIR\"
	Call OnRichEditTextChange
	#Set the title and taskbar display of the installation package  
	nsNiuniuSkin::SetWindowTile $hInstallDlg"${PRODUCT_NAME} Installer"
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_CONFIG}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "lblSpaceRequired" "text" "$(LBL_SPACE_REQUIRED)${APP_SIZE}"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "lblInstallPath" "text" "$(LBL_SELECT_DIRECTORY)"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licensename" "text" "Software Service Terms"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "chkAgree" "text" "$(lbllicensename)"
	#nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnAgreement" "text" "  User License Agreement"
		
    Call BindUIControls	
    nsNiuniuSkin::ShowPage 0	
FunctionEnd

Function un.DUIPage
	StrCpy $InstallState "0"
    InitPluginsDir
	SetOutPath "$PLUGINSDIR"
    File "${INSTALL_RES_PATH}"
	nsNiuniuSkin::InitSkinPage "$PLUGINSDIR\" "" 
    Pop $hInstallDlg
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTCONFIG}
	#Set the title and taskbar display of the installation package  
	nsNiuniuSkin::SetWindowTile $hInstallDlg"${PRODUCT_NAME} Uninstall program"
	nsNiuniuSkin::SetWindowSize $hInstallDlg 508 418
	Call un.BindUnInstUIControls
	
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "chkAutoRun" "selected" "true"
	
    nsNiuniuSkin::ShowPage 0
	
FunctionEnd

#Event of binding unloading 
Function un.BindUnInstUIControls
	GetFunctionAddress $0 un.ExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnUninstalled" $0
	
	GetFunctionAddress $0 un.onUninstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnUnInstall" $0
	
	GetFunctionAddress $0 un.ExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnClose" $0
FunctionEnd

#Interface events for binding installation
Function BindUIControls
	# License页面
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnLicenseClose" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnLicenseMin" $0
    
	
	GetFunctionAddress $0 OnBtnLicenseClick
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnAgreement" $0
	
    # Catalog selection page
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirClose" $0
	
	GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnLicenseCancel" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirMin" $0
    
    GetFunctionAddress $0 OnBtnSelectDir
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnSelectDir" $0
    
    GetFunctionAddress $0 OnBtnDirPre
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirPre" $0
    
	GetFunctionAddress $0 OnBtnShowConfig
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnAgree" $0
	
    GetFunctionAddress $0 OnBtnCancel
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDirCancel" $0
        
    GetFunctionAddress $0 OnBtnInstall
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnInstall" $0
    
    # Installation progress page
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDetailClose" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnDetailMin" $0

    # Installation complete page
    GetFunctionAddress $0 OnFinished
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnRun" $0
    
    GetFunctionAddress $0 OnBtnMin
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnFinishedMin" $0
    
    GetFunctionAddress $0 OnExitDUISetup
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnClose" $0
	
	GetFunctionAddress $0 OnCheckLicenseClick
    nsNiuniuSkin::BindCallBack $hInstallDlg "chkAgree" $0
	
	GetFunctionAddress $0 OnBtnShowMore
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnShowMore" $0
	
	GetFunctionAddress $0 OnBtnHideMore
    nsNiuniuSkin::BindCallBack $hInstallDlg "btnHideMore" $0
	
	#Событие уведомления при закрытии связанного окна с помощью alt + f4 и т. Д.
	GetFunctionAddress $0 OnSysCommandCloseEvent
    nsNiuniuSkin::BindCallBack $hInstallDlg "syscommandclose" $0
	
	#Событие уведомления об изменении пути привязки
	GetFunctionAddress $0 OnRichEditTextChange
    nsNiuniuSkin::BindCallBack $hInstallDlg "editDir" $0
FunctionEnd

#Here is the event notification when the path changes
Function OnRichEditTextChange
	#You can get the path here to determine whether it is legal and other processing
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "editDir" "text"
    Pop $0	
	StrCpy $INSTDIR "$0"
	
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "$(LBL_SPACE_AVAILABLE)"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "lblSpaceRequired" "text" "$(LBL_SPACE_REQUIRED)"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "textcolor" "#ffff0000"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "false"
		goto TextChangeAbort
    ${EndIf}
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "textcolor" "#FF999999"
	${If} $R0 > 1024                               #400 That is, the actual space that the program needs to occupy after installation, the unit：MB  
	    
		IntOp $R1  $R0 % 1024	
		IntOp $R0  $R0 / 1024;		
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "$(LBL_SPACE_AVAILABLE)：$R0.$R1GB"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "local_space" "text" "$(LBL_SPACE_AVAILABLE)：$R0.$R1MB"
     ${endif}
	
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	${If} $0 == "1"        
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "true"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "false"
    ${EndIf}
	
TextChangeAbort:
FunctionEnd


#Control whether the button is displayed in gray according to the selected situation
Function OnCheckLicenseClick
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	${If} $0 == "0"        
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "true"
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnInstall" "enabled" "false"
    ${EndIf}
FunctionEnd

Function OnBtnLicenseClick
    ;nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_LICENSE}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "visible" "true"
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "moreconfiginfo" "visible"
	Pop $0
	${If} $0 = 0        
		;pos="10,35,560,405"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "pos" "5,35,475,385"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editLicense" "height" "270"		
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "pos" "5,35,475,495"
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editLicense" "height" "375"
    ${EndIf}
	
FunctionEnd

# Add an empty Section to prevent the compiler from reporting errors
Section "None"
SectionEnd

Function ShowMsgBox
	nsNiuniuSkin::InitSkinSubPage "msgBox.xml" "btnOK" "btnCancel,btnClose"  ; "prompt" "${PRODUCT_NAME} running，Please log out and try again!" 0
	Pop $hInstallSubDlg
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblTitle" "text" "prompt"
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblMsg" "text" "$R8"
	${If} "$R7" == "1"
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "hlCancel" "visible" "true"
	${EndIf}
	
	nsNiuniuSkin::ShowSkinSubPage 0 
	Exec 'cmd.exe /C rmdir /Q /S "$PLUGINSDIR"' 

FunctionEnd

# start installation
Function OnBtnInstall
    nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkAgree" "selected"
    Pop $0
	StrCpy $0 "1"
		
	#If you don’t agree, just exit
	StrCmp $0 "0" InstallAbort 0
	
	#Here to check whether there is a program currently running, if it is running, it will prompt to uninstall and then install
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0
	
	${If} $R0 == 0
        StrCpy $R8 "${PRODUCT_NAME} 正在运行，请退出后重试!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}		

	nsNiuniuSkin::GetControlAttribute $hInstallDlg "editDir" "text"
    Pop $0
    StrCmp $0 "" InstallAbort 0
	
	#Correction path (addition) 
	Call AdjustInstallPath
	StrCpy $sSetupPath "$INSTDIR"	
	
	Call IsSetupPathIlleagal
	${If} $R5 == "0"
		StrCpy $R8 "The path is illegal, please use the correct path to install!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}	
	${If} $R5 == "-1"
		StrCpy $R8 "The target disk space is insufficient, please use another disk to install!"
		StrCpy $R7 "0"
		Call ShowMsgBox
		goto InstallAbort
    ${EndIf}
	
	
	nsNiuniuSkin::SetWindowSize $hInstallDlg 508 418
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "false"
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_PROCESSING}
    
    nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "min" "0"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "max" "100"
	
    # Temporarily save these files in a temporary directory.
    #Call BakFiles
    
    #Start a background thread with low priority
    GetFunctionAddress $0 ExtractFunc
    BgWorker::CallAndWait
	
    
	Call CreateShortcut
	#TODO: Code added by yourself Add to desktop shortcut action Add here
	CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${EXE_NAME}"	
	Call CreateUninstall
    
			
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "true"		
	StrCpy $InstallState "1"
	#If you don’t want to start immediately, you need to shield the call of OnFinished below, and open the display INSTALL_PAGE_FINISH
	#Call OnFinished
	#If the following line is opened, it will jump to the completion page
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_FINISH}
InstallAbort:
FunctionEnd

Function ExtractCallback
    Pop $1
    Pop $2
    System::Int64Op $1 * 100
    Pop $3
    System::Int64Op $3 / $2
    Pop $0
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "value" "$0"	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_pos" "text" "$0%"
    ${If} $1 == $2  
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrProgress" "value" "100"	
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "progress_pos" "text" "100%"
    ${EndIf}
FunctionEnd

#CTRL+F4 Event notification when closing
Function OnSysCommandCloseEvent
	Call OnExitDUISetup
FunctionEnd

#Click to exit on the installation interface and give a prompt
Function OnExitDUISetup
	${If} $InstallState == "0"		
		StrCpy $R8 "The installation has not been completed, are you sure to exit the installation?"
		StrCpy $R7 "1"
		Call ShowMsgBox
		pop $0
		${If} $0 == 0
			goto endfun
		${EndIf}
	${EndIf}
  Exec 'cmd.exe /C rmdir /Q /S "$PLUGINSDIR"' 
  nsNiuniuSkin::ExitDUISetup
endfun: 
 Exec 'cmd.exe /C rmdir /Q /S "$PLUGINSDIR"' 
FunctionEnd


Function OnBtnMin
    SendMessage $hInstallDlg ${WM_SYSCOMMAND} 0xF020 0
FunctionEnd

Function OnBtnCancel
	nsNiuniuSkin::ExitDUISetup
FunctionEnd

Function OnFinished	
		    
	#Start now
    Exec "$INSTDIR\${EXE_NAME}"
    Call OnExitDUISetup
FunctionEnd

Function OnBtnSelectDir
    nsNiuniuSkin::SelectInstallDir
    Pop $0
	${Unless} "$0" == ""
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "editDir" "text" $0
	${EndUnless}
FunctionEnd

Function StepHeightSizeAsc
${ForEach} $R0 418 528 + 10
  nsNiuniuSkin::SetWindowSize $hInstallDlg 508 $R0
  Sleep 5
${Next}
FunctionEnd

Function StepHeightSizeDsc
${ForEach} $R0 528 418 - 10
  nsNiuniuSkin::SetWindowSize $hInstallDlg 508 $R0
  Sleep 5
${Next}
FunctionEnd

Function OnBtnShowMore	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "moreconfiginfo" "visible" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "visible" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "visible" "false"
	;Adjust window height 
	 GetFunctionAddress $0 StepHeightSizeAsc
    BgWorker::CallAndWait
	
	nsNiuniuSkin::SetWindowSize $hInstallDlg 508 528
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "true"
FunctionEnd

Function OnBtnHideMore
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "moreconfiginfo" "visible" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "visible" "false"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "visible" "true"
	; Adjust window height
	 GetFunctionAddress $0 StepHeightSizeDsc
    BgWorker::CallAndWait
	nsNiuniuSkin::SetWindowSize $hInstallDlg 508 418
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnShowMore" "enabled" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnHideMore" "enabled" "true"
FunctionEnd


Function OnBtnShowConfig
    ;nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_CONFIG}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "licenseshow" "visible" "false"
FunctionEnd

Function OnBtnDirPre
    
	StrCpy $R8 "The installation has not been completed, are you sure to exit the installation?"
	StrCpy $R7 "0"
	Call ShowMsgBox
		;nsNiuniuSkin::PrePage "wizardTab"
FunctionEnd


Function un.ShowMsgBox
	nsNiuniuSkin::InitSkinSubPage "msgBox.xml" "btnOK" "btnCancel,btnClose"  ; "Prompt ""${PRODUCT_NAME} is running, please exit and try again!" 0
	Pop $hInstallSubDlg
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblTitle" "text" "prompt"
	nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "lblMsg" "text" "$R8"
	${If} "$R7" == "1"
		nsNiuniuSkin::SetControlAttribute $hInstallSubDlg "hlCancel" "visible" "true"
	${EndIf}
	
	nsNiuniuSkin::ShowSkinSubPage 0 
FunctionEnd

Function un.ExitDUISetup
	nsNiuniuSkin::ExitDUISetup
FunctionEnd

#Perform a specific uninstall
Function un.onUninstall
	nsNiuniuSkin::GetControlAttribute $hInstallDlg "chkReserveData" "selected"
    Pop $0
	StrCpy $sReserveData $0
		
	#Here to check whether there is a program currently running, if it is running, it will prompt to uninstall and then install
	nsProcess::_FindProcess "${EXE_NAME}"
	Pop $R0
	
	${If} $R0 == 0
		StrCpy $R8 "${PRODUCT_NAME} Running, please exit and try again!"
		StrCpy $R7 "0"
		Call un.ShowMsgBox
		goto InstallAbort
    ${EndIf}
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "false"
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTPROCESSING}
	
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "min" "0"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "max" "100"
	IntOp $UnInstallValue 0 + 1
	
	Call un.DeleteShotcutAndInstallInfo
	
	IntOp $UnInstallValue $UnInstallValue + 8
    
	#Delete Files
	GetFunctionAddress $0 un.RemoveFiles
    BgWorker::CallAndWait
	InstallAbort:
FunctionEnd

#Delete files in the thread to show progress
Function un.RemoveFiles
	${Locate} "$INSTDIR" "/G=0 /M=*.*" "un.onDeleteFileFound"
	StrCpy $InstallState "1"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "btnClose" "enabled" "true"
	nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "100"	
	nsNiuniuSkin::ShowPageItem $hInstallDlg "wizardTab" ${INSTALL_PAGE_UNISTFINISH}
FunctionEnd



#The process of deleting files when uninstalling the program. If there are files that need to be filtered, add in this function
Function un.onDeleteFileFound
    ; $R9    "path\name"
    ; $R8    "path"
    ; $R7    "name"
    ; $R6    "size"  ($R6 = "" if directory, $R6 = "0" if file with /S=)
    
	
	#Whether to filter and delete  
			
	Delete "$R9"
	RMDir /r "$R9"
    RMDir "$R9"
	
	IntOp $UnInstallValue $UnInstallValue + 2
	${If} $UnInstallValue > 100
		IntOp $UnInstallValue 100 + 0
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "100"	
	${Else}
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "slrUnInstProgress" "value" "$UnInstallValue"	
		nsNiuniuSkin::SetControlAttribute $hInstallDlg "un_progress_pos" "text" "$UnInstallValue%"
		
		Sleep 100
	${EndIf}	
	undelete:
	Push "LocateNext"	
FunctionEnd