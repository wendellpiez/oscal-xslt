rem Invoking Morgana XProc III engine for XProc 3 pipeline execution.

rem All arguments are passed to the script in the distribution.

rem NB - may need to update path and Saxon setting to your installed versions

rem TODO: port fallback logic / --help 
call lib/MorganaXProc-IIIse-1.3.7/Morgana.bat %* -xslt-connector=saxon12-3

pause
