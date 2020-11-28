@call makeapp.bat

@call makeskinzip.bat nim

".\NSIS\makensis.exe" ".\SetupScripts\nim\nim_setup.nsi"

@rem Если вы хотите отладить ошибки, используйте приведенный ниже скрипт, который откроет интерфейс компиляции (интерфейс командной строки будет)
@rem ".\NSIS\makensisw.exe" ".\SetupScripts\nim\nim_setup.nsi"
@pause