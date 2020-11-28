@call makeapp.bat

@call makeskinzip.bat songliwu

".\NSIS\makensis.exe" ".\SetupScripts\songliwu\songliwu_demo.nsi"

@rem Если вы хотите отладить ошибки, используйте приведенный ниже скрипт, который откроет интерфейс компиляции (интерфейс командной строки будет отображаться)
@rem ".\NSIS\makensisw.exe" ".\SetupScripts\songliwu\songliwu_demo.nsi"
@pause