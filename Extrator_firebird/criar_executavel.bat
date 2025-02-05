@echo off
:: ================================
:: Script de Empacotamento com PyInstaller
:: ================================

:: Configuração Inicial
set PYTHON_EXECUTABLE=python.exe
set PYTHON_VERSION=3.9
set PYTHON_39_PATH=.venv\Scripts\python.exe
set VENV_DIR=.venv
set BUILD_DIR=build
set DIST_DIR=dist
set SPEC_FILE=pgfarma_firebird.spec
set MAIN_SCRIPT=main.py
set PROJECT_NAME=pgfarma_firebird

:: Verificar se o Python 3.9 está disponível
echo Verificando se o Python %PYTHON_VERSION% está instalado...
%PYTHON_39_PATH% --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo ERRO: Python %PYTHON_VERSION% não encontrado no caminho especificado: %PYTHON_39_PATH%.
    echo Por favor, instale o Python %PYTHON_VERSION% ou ajuste o caminho no script.
    pause
    exit /B 1
)

:: Verificar se o ambiente virtual existe
if not exist %VENV_DIR% (
    echo Criando ambiente virtual com Python %PYTHON_VERSION%...
    "%PYTHON_39_PATH%" -m venv %VENV_DIR%
) else (
    echo Ambiente virtual encontrado. Usando o existente...
)

:: Ativar ambiente virtual
echo Ativando ambiente virtual...
call %VENV_DIR%\Scripts\activate

:: Garantir que todas as dependências estão instaladas
if not exist requirements.txt (
    echo ERRO: Arquivo requirements.txt não encontrado.
    deactivate
    pause
    exit /B 1
)
echo Instalando dependências do projeto...
pip install --upgrade pip
pip install pyinstaller
pip install -r requirements.txt

:: Limpar diretórios de build antigos
if exist %BUILD_DIR% (
    echo Removendo pasta de build antiga...
    rmdir /s /q %BUILD_DIR%
)
if exist %DIST_DIR% (
    echo Removendo pasta dist antiga...
    rmdir /s /q %DIST_DIR%
)
if exist %SPEC_FILE% (
    echo Removendo arquivo spec antigo...
    del /q %SPEC_FILE%
)

:: Função para corrigir a biblioteca FDB
echo Aplicando correções na biblioteca FDB...
call :modificar_fdb

:: Gerar o executável com PyInstaller
echo Gerando o executável com PyInstaller...
%VENV_DIR%\Scripts\python.exe -m PyInstaller ^
    --clean ^
    --onefile ^
    --noconsole ^
    --add-data "config;config" ^
    --add-data "dicionarios_tipos.json;." ^
    --hidden-import fdb ^
    --hidden-import polars-lts-cpu ^
    --hidden-import aioboto3 ^
    --hidden-import aiobotocore ^
    --hidden-import aiobotocore.session ^
    --hidden-import azure.storage.blob ^
    --hidden-import azure.identity ^
    --hidden-import azure.core ^
    --name "%PROJECT_NAME%" ^
    %MAIN_SCRIPT%

IF ERRORLEVEL 1 (
    echo ERRO: Falha ao gerar o executável.
    deactivate
    pause
    exit /B 1
)

:: Desativar ambiente virtual
echo Desativando o ambiente virtual...
deactivate

echo Processo concluído com sucesso!
echo O executável está localizado no diretório "%DIST_DIR%".
pause
exit /B 0

:: ================================
:: Função para modificar a biblioteca FDB
:: ================================
:modificar_fdb
powershell -Command "(Get-Content .venv\Lib\site-packages\fdb\gstat.py).Replace('resetlocale', '') | Set-Content .venv\Lib\site-packages\fdb\gstat.py"
powershell -Command "(Get-Content .venv\Lib\site-packages\fdb\__init__.py).Replace('from fdb import gstat', '') | Set-Content .venv\Lib\site-packages\fdb\__init__.py"
powershell -Command "(Get-Content .venv\Lib\site-packages\fdb\gstat.py).Replace('from locale import LC_ALL, LC_CTYPE, getlocale, setlocale, resetlocale', 'from locale import LC_ALL, LC_CTYPE, getlocale, setlocale') | Set-Content .venv\Lib\site-packages\fdb\gstat.py"
goto :eof
