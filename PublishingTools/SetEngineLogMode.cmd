@echo off
setlocal
set VSRegSuffix=

:ArgLoop
if /i "%~1"=="" goto Help
if /i "%~1"=="-?" goto Help
if /i "%~1"=="/?" goto Help
if /i "%~1"=="/exp" set VSRegSuffix=Exp& shift& goto ArgLoop
if /i "%~1"=="default" set EngineDiagEnableState=0& goto FindVS
if /i "%~1"=="error" set EngineDiagEnableState=1& goto FindVS
if /i "%~1"=="method" set EngineDiagEnableState=2& goto FindVS
if /i "%~1"=="dump" set DumpValue=1& goto FindVS

echo ERROR: Unknown argument '%1'.
exit /b -1

:FindVS
REM Find a default VS installation or use one specified by the cmdline.
set VSInstallRoot=%~2
if NOT "%VSInstallRoot%"=="" goto :HaveVSDir
REM Next check the environment variable if we are being launched from a developer command prompt, use "%VSINSTALLDIR%"
set VSInstallRoot=%VSINSTALLDIR%
if NOT "%VSInstallRoot%"=="" goto :HaveVSDir
set ProgRoot=%ProgramFiles(x86)%
if "%ProgRoot%"=="" set ProgRoot=%ProgramFiles%
call :TryVSPaths "%ProgRoot%\Microsoft Visual Studio\2017\*"
goto :EOF

:TryVSPaths
for /d %%d in (%1) do call :TryVSPath "%%d"
if "%VSInstallRoot%"=="" echo ERROR: Unable to find VS Install root. Please specify the VS install root as an argument to this script, or use this script from a Developer Command Prompt.& exit /b -1
goto :EOF

:TryVSPath
REM Arg1: path to VS Root
if not exist "%~1" goto :EOF
if not exist "%~1\Common7\IDE\vsregedit.exe" goto :EOF
set VSInstallRoot=%~1
goto :HaveVSDir

:HaveVSDir
pushd "%VSInstallRoot%"
set reg_exe=".\Common7\IDE\vsregedit.exe"
if "%DumpValue%"=="1" goto Dump

:Set
call %reg_exe% set "%CD%" %VSRegSuffix% HKLM Debugger EngineDiagEnableState DWORD %EngineDiagEnableState%
popd
if not %ERRORLEVEL%==0 echo ERROR: failed to write to the registry (%1) & exit /b -1
goto eof

:Dump
echo.
echo Listing current settings (0=default, 1=error, 2=method) for '%CD%'...
echo ----------------------------------------------------------

REM First check if the key exists. If it doesn't this will echo something that looks like an error, so we send stdout to NUL
call %reg_exe% read "%CD%" %VSRegSuffix% HKLM Debugger EngineDiagEnableState DWORD 2>NUL 1>NUL
if "%ERRORLEVEL%"=="0" goto DumpRegValue
if NOT "%ERRORLEVEL%"=="0" goto OutputNoValueMessage

:DumpRegValue
call %reg_exe% read "%CD%" %VSRegSuffix% HKLM Debugger EngineDiagEnableState DWORD
popd
exit /b 0

:OutputNoValueMessage
echo Name: EngineDiagEnableState, Value: 0
popd
exit /b 0

:Help
echo SetEngineLogMode.cmd [/exp] ^<default ^| error ^| method ^| dump^> [VSInstancePath]
echo.
echo SetEngineLogMode.cmd is used to configure the logging mode used by 
echo vsdebugeng.dll. Three modes of operation are available:
echo.
echo '/exp' - optional switch that causes SetEngineLogMode to work on the
echo experimental instance of Visual Studio instead of the standard instance.
echo NOTE: Registry values in the experimental instance will get reset regularly,
echo so when using this option, start the experimental instance, do NOT start
echo debugging, modify the setting, and then start debugging.
echo 
echo 'default' mode - significant errors are set to the debug output when a 
echo debugger is attached to Visual Studio (or whatever process has loaded 
echo vsdebugeng). Default mode is the behavior in a clean install of Visual 
echo Studio.
echo.
echo 'error' mode - significant errors are set to %%tmp%%\vsdebugeng.dll.log if no
echo debugger is attached to visual studio. If a debugger is attached to Visual 
echo Studio, default mode and error mode are the same.
echo.
echo 'method' mode - In addition to the tracing in 'error' mode, method entry/exit
echo tracing is provided. Four different types of output are sent -- 'CALL' lines 
echo are used when an implementation was successfully loaded and is about to be 
echo called. 'RETURN' lines are used when a called component returns successfully.
echo If the operation fails, a 'RETURN ERROR' line will appear instead. If no 
echo implementation could be found or if the implementation fails to load a 'CALL 
echo ERROR' line will appear. In addition to this, after a CALL/CALL ERROR line, 
echo there are 'Skipped' lines explaining why components are not called.
echo.
echo 'dump' mode displays the current log mode.
echo.
echo If VSInstancePath is not specified the default installation path is searched
echo and any the command is run on any instances found.
echo Otherwise only the VS instance at VSInstancePath is affected.
echo.
echo Example method logging output:
echo CALL: IDkmRuntimeMonitorBreakpointHandler.EnableRuntimeBreakpoint (ThreadId=6080 Class=Win32BDM.CBaseDebugMonitor IP=0x577D3B00 Object=0x10BD4F90 TickCount=217496250 ComponentId={F50FC269-4428-4680-8A45-462B8C5D37CD})
echo   Skipped: ManagedDM::CCommonEntryPoint {38A59583-E6B1-4EE4-A53C-133BE0F45E55} for object visibility
echo   Skipped: MinidumpBDM.CBaseDebugMonitor {016426E1-A85F-4CAB-941A-7C5EB5C82DC4} for 'BaseDebugMonitorId' filter
echo RETURN: IDkmRuntimeMonitorBreakpointHandler.EnableRuntimeBreakpoint (hr = 0x0, ThreadId=6080, TickCount=217496250)
echo.
:eof
