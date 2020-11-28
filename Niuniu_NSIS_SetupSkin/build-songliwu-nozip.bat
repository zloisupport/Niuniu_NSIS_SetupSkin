@call makensiscode.bat

@call makeskinzip.bat songliwu

".\NSIS\makensis.exe" /DINSTALL_WITH_NO_NSIS7Z=1 ".\SetupScripts\songliwu\songliwu_demo.nsi"
@rem Если вы хотите отладить ошибки, используйте приведенный ниже скрипт
@rem ".\NSIS\makensisw.exe" /DINSTALL_WITH_NO_NSIS7Z=1 ".\SetupScripts\songliwu\songliwu_demo.nsi"
@pause