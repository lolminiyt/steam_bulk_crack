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

    set /p exe=Por favor, introduce el nombre del exe: 

    REM Buscar el archivo .exe en todas las carpetas y subcarpetas
    set "exeFilePath="
    for /r "%folder%" %%F in (%exe%.exe) do (
        set "exeFilePath=%%~dpF"
        goto :FoundExe
    )

    :FoundExe
    REM Verificar si se encontró el archivo .exe
    if defined exeFilePath (
        echo Se encontró el archivo %exe%.exe en la carpeta: !exeFilePath!
        
        REM Copiar steamless.CLI.exe a la carpeta del archivo .exe
        xcopy /D /Y "%currentDir%\steamless.CLI.exe" "%folder%"
        xcopy /D /Y /i "%currentDir%\Plugins" "%folder%\Plugins"

        REM Cambiar el directorio actual a la carpeta del archivo .exe
        cd /d "!exeFilePath!"
        
        REM Abrir el programa "steamless" con el archivo .exe como argumento
        start "" "steamless.CLI.exe" --quiet "%exe%.exe"
        echo Se ha abierto el programa "steamless" con el archivo %exe%.exe.

        REM Eliminar el archivo "steamless.CLI.exe" después de ejecutarlo
        timeout 2 > nul
        del /Q "steamless.CLI.exe"
        pushd "%folder%"
        rd /S /Q "Plugins"
        popd
        
    ) else (
        echo El archivo %exe%.exe no se ha encontrado en la carpeta y sus subcarpetas.
    )
) else (
    echo La carpeta especificada no existe.
)

pause