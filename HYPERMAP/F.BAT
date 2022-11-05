@echo off
C:\util\masm61\bin\ml source\hypermap.asm 
C:\util\masm61\bin\link hypermap
rem lzexe hypermap.exe
del hypermap.old
del hypermap.obj
@echo on