@echo off 
if "%1" == "" ( 
 echo "project name is [NULL]". 
) ELSE (
echo "building ..."
copy template.vim "%1".vim
echo start gvim.exe -S "%VIMPROJ%\%1.vim" > PROJ/"%1".bat
echo exit >> PROJ/"%1".bat
echo "done!"
)

