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
::     @Grub4K - Helped reducing variables plural algorithm.
::     @Grub4K - Teached me the tuple pseudo-data pattern.
::     @Grub4K - Creator of the timer algorithm.
::     @Sintrode - Helped me encoding the CLI.
::     A project created in the "server.bat" Discord: https://discord.gg/GSVrHag
::------------------------------------------------------------------------------
cls
>nul chcp 65001
setlocal DisableDelayedExpansion
cd /d "%~dp0"
set "@TITLE=title [!Percentage!/100%%]  ^|  [!Results! duplicate!s_Results! found from !Index_1! indexed file!s_Index_1!] - Duplicate Search"
set "@SET_S=if !?! gtr 1 (set s_?=s) else (set s_?=)"
setlocal EnableDelayedExpansion
for /f "tokens=4,5delims=. " %%A in ('ver') do (
    if "%%A.%%B"=="10.0" (
        set CYAN=[36m
        set YELLOW=[33m
        set @SCAN=comp "%%C" "%%D" /m
    ) else (
        set @SCAN=fc "%%C" "%%D"
    )
)
for %%A in (s_Index s_Result s_Second) do set %%A=
set /a Percentage=0, Results=0, Index_1=0, Index_2=1
echo.
echo  !CYAN!■ Searching for duplicates in "%~dp0" ...
echo  ├──────────────────────────────────────────────────────────────────────────────
for /f "tokens=1-4delims=:.," %%A in ("!time: =0!") do set /a "t1=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100"
for /f "delims=" %%A in ('dir /a:-d /b /o:-s /s') do (
    set /a Index_1+=1
    set "Cache[!Index_1!]=%%A"
    %@SET_S:?=Index_1%
    %@TITLE%
)
for /l %%A in (1 1 !Index_1!) do (
    set /a Percentage=%%A*100/Index_1, Index_2+=1
    for /l %%B in (!Index_2! 1 !Index_1!) do (
        for /f "tokens=1,2delims=`" %%C in ("!Cache[%%A]!`!Cache[%%B]!") do (
            if "%%~zC"=="%%~zD" (
                >nul 2>&1 %@SCAN% && (
                    set /a Results+=1
                    %@SET_S:?=Results%
                    echo  ├ The !YELLOW!"%%C"!CYAN! and !YELLOW!"%%D"!CYAN! files are duplicated.
                )
            )
        )
    )
    %@TITLE%
)
if !Results!==0 echo  │ No duplicate file found.
for /f "tokens=1-4delims=:.," %%A in ("!time: =0!") do set /a "t2=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100, tDiff=t2-t1, tDiff+=((~(tDiff&(1<<31))>>31)+1)*8640000, Seconds=tDiff/100"
echo  └──────────────────────────────────────────────────────────────────────────────
set Percentage=100
%@TITLE%
%@SET_S:?=Seconds%
echo.
echo  ■ Scan complited with !Results! duplicate!s_Results! found from !Index_1! indexed file!s_Index_1! in !Seconds! second!s_Seconds!.
echo.
<nul set /p= ■ Press {ANY KEY} to exit...
>nul pause
exit