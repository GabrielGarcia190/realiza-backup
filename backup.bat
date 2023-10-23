@echo off
REM Defina as variáveis
set ServerName=SERVIDOR/INSTÂNCIA
set DatabaseName=NOME_DO_BANCO
set BackupPath=CAMINHO DO BACKUP
set SevenZipPath="CAMINHO DO EXECUTAL DO 7Z\7za.exe" 
REM Substitua pelo caminho para o executável 7za.exe

for /f %%a in ('wmic os get LocalDateTime ^| find "."') do set DateTime=%%a
set Year=%DateTime:~0,4%
set Month=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hour=%DateTime:~8,2%
set Minute=%DateTime:~10,2%
set Second=%DateTime:~12,2%

REM Obtenha o nome do dia da semana
for /f %%a in ('wmic path win32_localtime get dayofweek ^| findstr [1-7]') do set DayOfWeek=%%a

REM Mapeie o número do dia da semana para o nome do dia
if %DayOfWeek%==0 set DayName=Sunday
if %DayOfWeek%==1 set DayName=Monday
if %DayOfWeek%==2 set DayName=Tuesday
if %DayOfWeek%==3 set DayName=Wednesday
if %DayOfWeek%==4 set DayName=Thursday
if %DayOfWeek%==5 set DayName=Friday
if %DayOfWeek%==6 set DayName=Saturday

REM Define o nome do arquivo de backup com base no dia da semana
set BackupFileName=%DatabaseName%_%DayName%.bak

REM Comando SQL para executar o backup
set SqlCmdCommand=sqlcmd -S %ServerName% -d %DatabaseName% -E -Q "BACKUP DATABASE [%DatabaseName%] TO DISK='%BackupPath%\%BackupFileName%'"

REM Executa o comando SQL
%SqlCmdCommand%

REM Caminho completo para o arquivo de backup
set backupFilePath=%backupPath%\%backupFileName%

REM Caminho completo para o arquivo compactado
set compressedFilePath=%backupPath%\%dayName%.7z

REM Compacte o arquivo de backup usando o 7-Zip
"%sevenZipPath%" a -t7z "%compressedFilePath%" "%backupFilePath%"

REM Pause para que você possa ver a saída antes de fechar a janela
pause
