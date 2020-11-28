@call makensiscode.bat

@call makeskinzip.bat nim

".\NSIS\makensis.exe" /DINSTALL_WITH_NO_NSIS7Z=1 ".\SetupScripts\nim\nim_setup.nsi"

@rem Если вы хотите отладить ошибки, используйте приведенный ниже скрипт, который откроет интерфейс компиляции (интерфейс командной строки будет)
@rem ".\NSIS\makensisw.exe" /DINSTALL_WITH_NO_NSIS7Z=1 ".\SetupScripts\nim\nim_setup.nsi"
@pause