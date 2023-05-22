@echo off
chcp 65001 > nul

setlocal enabledelayedexpansion

REM Obtener la ruta del directorio actual
set "currentDir=%~dp0"

set /p folder=Por favor, introduce la ruta de la carpeta: 

REM Verificar si la carpeta existe
if exist "%folder%" (
    REM Establecer la carpeta como el directorio actual
    cd /d "%folder%"
    echo La carpeta %folder% se ha establecido como directorio actual.

    REM Crear una carpeta llamada "backup" en la carpeta seleccionada si no existe
    if not exist "%folder%\backup" (
        mkdir "%folder%\backup"
        echo Se ha creado una carpeta llamada "backup" en la carpeta seleccionada.
    ) else (
        echo La carpeta "backup" ya existe en la carpeta seleccionada.
    )

    REM Copiar el archivo "int.exe" a la carpeta "backup" si no existe
    set "intFilePath=%currentDir%\int.exe"
    if not exist "%folder%\backup\int.exe" (
        xcopy /D /Y "%currentDir%\int.exe" "%folder%"
        echo Se ha copiado el archivo "int.exe" a la carpeta.
    ) else (
        echo El archivo "int.exe" ya existe en la carpeta  seleccionada. No se copiará nuevamente.
    )

    REM Crear el archivo "exclusiones.txt" en la ubicación del archivo .bat con la ruta completa de la carpeta "backup"
    echo %folder%\backup > "%currentDir%\exclusiones.txt"
    echo Se ha creado el archivo "exclusiones.txt" en la ubicación del archivo .bat.
    
    REM Aquí puedes realizar las modificaciones en la carpeta seleccionada

    REM Buscar los archivos "steam_api.dll" o "steam_api64.dll" dentro de la carpeta seleccionada y sus subcarpetas
    set "fileFound=false"
    for /r "%folder%" %%F in (steam_api.dll steam_api64.dll) do (
        if exist "%%F" (
            echo Se encontró el archivo "%%~nxF" en la carpeta "%%~dpF"
            set "fileFound=true"
            set "BackupFolder=%folder%\backup"
            if not exist "%%~dpF\int.exe" (
                xcopy /D /Y "%currentDir%\int.exe" "%%~dpF"
                echo Se ha copiado el archivo "int.exe" a la carpeta "%%~dpF".)
            if not exist "%%~dpF\steam_interfaces.txt" (
                start int.exe steam_api64.dll
                echo generando steam_interfaces!.)
                if not exist "%%~dpF\steam_interfaces.txt" (
                    start int.exe steam_api.dll
                    echo generando steam_interfaces!.)
            if not exist "%%~dpF\steam_appid.txt" (
                set /p "inputAppID=Ingresa el App ID (o deja vacío para omitir): "
                if "!inputAppID!" neq "" (
                    (
                        echo !inputAppID!
                    ) > "%%~dpF\steam_appid.txt"
                    echo Se ha creado el archivo "steam_appid.txt" en la carpeta "%%~dpF".
                ) else (
                    echo No se ha ingresado ningún App ID. Se omitirá))
            REM Reemplazar los archivos encontrados en la carpeta seleccionada si son más recientes
            xcopy /D /Y "%%~nxF" "%folder%\backup"
            xcopy /D /Y "%currentDir%\steam_api.dll" "%%~dpF" /EXCLUDE:%BackupFolder%
            xcopy /D /Y "%currentDir%\steam_api64.dll" "%%~dpF" /EXCLUDE:%BackupFolder%
            echo Se han reemplazado los archivos en la carpeta "%%~dpF".
        )
    )
    for /r "%folder%" %%F in (int.exe) do (
        if exist "%%F" (
            timeout 1 > nul
            del /F int.exe
        ))

) else (
    echo La carpeta especificada no existe.
)

pause