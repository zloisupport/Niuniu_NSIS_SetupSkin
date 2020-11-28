@call makeapp.bat

@call makeskinzip.bat helloworld

".\NSIS\makensis.exe" ".\SetupScripts\helloworld\helloworld_setup.nsi"

@rem Если вы хотите отладить ошибки, используйте приведенный ниже скрипт, который откроет интерфейс компиляции (интерфейс командной строки будет отображаться как? На китайском языке)
@rem ".\NSIS\makensisw.exe" ".\SetupScripts\helloworld\helloworld_setup.nsi"
@pause