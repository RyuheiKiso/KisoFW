@echo off
REM filepath: KisoFW/04_FrameworkAndDriver/DataBase/PostgreSQL/start_postgres.bat

REM コマンドプロンプトの文字コードをUTF-8に設定
chcp 65001

REM 作業ディレクトリを設定
SET WORKDIR=%~dp0

REM ホストマシンのデータディレクトリ（相対パス）
SET DATA_DIR=%WORKDIR%data

REM コンテナ名を設定
SET CONTAINER_NAME=my_postgres_container

REM 環境変数を設定
SET POSTGRES_DB=mydatabase
SET POSTGRES_USER=myuser
SET POSTGRES_PASSWORD=mypassword

REM ポート番号を設定
SET POSTGRES_PORT=5432

REM 初期化スクリプトを含めるかどうかのフラグを設定
SET INCLUDE_INIT_SCRIPT=true

REM 初期化スクリプトのパスを設定
SET INIT_SCRIPT=%WORKDIR%init.sql

REM 変数のチェック
IF "%POSTGRES_DB%"=="" (
  echo POSTGRES_DBが設定されていません。
  exit /b 1
)
IF "%POSTGRES_USER%"=="" (
  echo POSTGRES_USERが設定されていません。
  exit /b 1
)
IF "%POSTGRES_PASSWORD%"=="" (
  echo POSTGRES_PASSWORDが設定されていません。
  exit /b 1
)
IF "%POSTGRES_PORT%"=="" (
  echo POSTGRES_PORTが設定されていません。
  exit /b 1
)

REM Dockerコンテナを起動
IF "%INCLUDE_INIT_SCRIPT%"=="true" (
  REM 初期化スクリプトを含めてコンテナを起動
  docker run -d ^
    --name %CONTAINER_NAME% ^
    -e POSTGRES_DB=%POSTGRES_DB% ^
    -e POSTGRES_USER=%POSTGRES_USER% ^
    -e POSTGRES_PASSWORD=%POSTGRES_PASSWORD% ^
    -v %DATA_DIR%:/var/lib/postgresql/data ^
    -v %INIT_SCRIPT%:/docker-entrypoint-initdb.d/init.sql ^
    -p %POSTGRES_PORT%:5432 ^
    postgres:latest
) ELSE (
  REM 初期化スクリプトを含めずにコンテナを起動
  docker run -d ^
    --name %CONTAINER_NAME% ^
    -e POSTGRES_DB=%POSTGRES_DB% ^
    -e POSTGRES_USER=%POSTGRES_USER% ^
    -e POSTGRES_PASSWORD=%POSTGRES_PASSWORD% ^
    -v %DATA_DIR%:/var/lib/postgresql/data ^
    -p %POSTGRES_PORT%:5432 ^
    postgres:latest
)

REM エラーチェック
IF %ERRORLEVEL% NEQ 0 (
  echo Dockerコンテナの起動に失敗しました。
  exit /b %ERRORLEVEL%
)

REM コンテナ起動成功メッセージ
echo PostgreSQLコンテナが起動しました。