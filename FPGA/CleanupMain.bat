echo Cleanup-Batch für ISE-main-Verzeichnis
rem Bei Konsistenz-Problemen oder 
rem vor Weitergabe eines Projektes ausfuehren
@echo off
if not exist sdcard md sdcard
if exist main\*.bit copy main\*.bit sdcard\*.bit
cd /main
if exist *.bgn del *.bgn
if exist *.bld del *.bld
if exist *.cmd_log del *.cmd_log
if exist *.csv del *.csv
if exist *.prj del *.prj
if exist *.jhd del *.jhd
if exist *.lso del *.lso
if exist *.map del *.map
if exist *.mrp del *.mrp
if exist *.ncd del *.ncd
if exist *.ngd del *.ngd
if exist *.ngc del *.ngc
if exist *.ngr del *.ngr
if exist *.drc del *.drc
if exist *.par del *.par
if exist *.ngm del *.ngm
if exist *.ntrc_log del *.ntrc_log
if exist *.pad del *.pad
if exist *.pcf del *.pcf
if exist *.ptwx del *.ptwx
if exist *.restore del *.restore
if exist *.unroutes del *.unroutes
if exist *.spl del *.spl
if exist *.stx del *.stx
if exist *.syr del *.syr
if exist *.twr del *.twr
if exist *.twx del *.twx
if exist *.ut del *.ut
if exist *.vhf del *.vhf
if exist *.xpi del *.xpi
if exist *.xrpt del *.xrpt
if exist *.xst del *.xst
if exist *.xml del *.xml
if exist *.html del *.html
if exist xst rd /s /q xst
if exist _ngo rd /s /q _ngo
if exist _xmsgs rd /s /q _xmsgs
if exist main_xdb rd /s /q main_xdb
cd..
@echo on
pause