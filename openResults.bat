@Echo Off
FOR /D /r %%G in ("Trunc*") DO (
Echo We found %%~nxG
cd %%~nxG
results.txt
cd .. 
)