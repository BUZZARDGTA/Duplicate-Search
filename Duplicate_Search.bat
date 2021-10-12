@echo off
::------------------------------------------------------------------------------
:: NAME
::     Duplicate_Search.bat - Duplicate Search
::
:: DESCRIPTION
::     Scan for duplicate files in the current folder and it's subfolders.
::
:: KNOWN BUG
::     Output is obfuscated when it meet an different encoding name.
::
:: AUTHOR
::     IB_U_Z_Z_A_R_Dl
::
:: CREDITS
::     @Grub4K - Teached me the tuple pseudo-data pattern.
::     @Grub4K - Creator of the timer algorithm.
::     A project created in the "server.bat" Discord: https://discord.gg/GSVrHag
::------------------------------------------------------------------------------
cd /d "%~dp0"
set "title=title [!percentage!/100%%]  ^|  [!result! duplicate!s_result! found from !index_1! indexed file!s_index!] - Duplicate Search"
Setlocal EnableDelayedExpansion
for /f "tokens=1-4delims=:.," %%a in ("!time: =0!") do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100"
set /a percentage=0, result=0, index_1=0, index_2=1
for /f "tokens=2delims=:." %%a in ('chcp') do set /a "CP=%%a"
for /f "tokens=4,5delims=. " %%a in ('ver') do (
    if "%%a.%%b"=="10.0" (
        set cyan=[36m
        set yellow=[33m
        set scan=comp "%%x" "%%y" /m
    ) else (
        set scan=fc "%%x" "%%y"
    )
)
echo.
echo !cyan!Searching for duplicate(s) in "%~dp0" ...
echo.
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
>nul chcp 65001
for /f "delims=" %%a in ('dir /a:-d /b /o:-s /s') do (
    set /a index_1+=1
    set "cache[!index_1!]=%%a"
    if !index_1! gtr 1 set s_index=s
    %title%
)
for /l %%a in (1 1 !index_1!) do (
    set /a index_2+=1, percentage=%%a*100/index_1
    for /l %%b in (!index_2! 1 !index_1!) do (
        for /f "tokens=1,2delims=`" %%x in ("!cache[%%a]!`!cache[%%b]!") do (
            if "%%~zx"=="%%~zy" (
                >nul 2>&1 %scan% && (
                    set /a result+=1
                    if !result! gtr 1 set s_result=s
                    echo The !yellow!"%%x"!cyan! and !yellow!"%%y"!cyan! files are duplicated.
                )
            )
        )
    )
    %title%
)
>nul chcp !CP!
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
for /f "tokens=1-4delims=:.," %%a in ("!time: =0!") do set /a "t2=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100, tDiff=t2-t1, tDiff+=((~(tDiff&(1<<31))>>31)+1)*8640000, seconds=tDiff/100"
if !seconds! gtr 1 set s_s=s
%title%
echo.
echo Scan complited with !result! duplicate!s_result! found from !index_1! indexed file!s_index! in !seconds! second!s_s!.
echo.
<nul set /p="Press {ANY KEY} to exit..."
>nul pause
exit