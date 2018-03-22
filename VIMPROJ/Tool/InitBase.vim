"初始化基本代码
function! DoTarModifyFile(root,iswindows,path,choice)
python << EOF
import os
import time
import re
import tarfile
import sys
import vim

escape_reg=["\.git","\.svn",".last_update_file"]

a_root      = vim.eval("a:root")
a_iswindows = int(vim.eval("a:iswindows"))
a_path      = vim.eval("a:path")
a_choice    = vim.eval("a:choice")

if a_iswindows==1:
    base_dir=a_path.replace("/","\\")
else:
    base_dir=a_path

compres_dir=os.path.join(base_dir,"..")
last_update_file=os.path.join(a_root,".last_modify_file")
last_tstamp=0
if int(a_choice)==1 and os.path.exists(last_update_file):
    last_tstamp=os.path.getmtime(last_update_file)

result=[]
for root, dirs, files in os.walk(base_dir):
    for file in files:
        filename=os.path.join(root,file)
        bEscape=True
        for regex in escape_reg:
            m=re.search(regex,filename)
            if m:
                bEscape=False
        if not bEscape:
            continue
        cur=os.path.getmtime(filename)
        if cur>=last_tstamp:
            result.append(filename)
            print("{}.{}".format(len(result),filename))
if len(result)==0:
    print("modify file empty, exit!")
else:
    dir=os.path.split(a_root)

    # tar new file
    tarfilename=os.path.join(compres_dir,dir[1]+".tar")
    tar=tarfile.open(tarfilename,"w")
    for r in result:
        tar.add(r,arcname=os.path.relpath(r,base_dir))
    tar.close()

    # update last_update_file
    with open(last_update_file,"w") as myfile:
        myfile.write(str(len(result)))
        myfile.close()
    cmd=":let @*='"+tarfilename+"'"
    vim.command(cmd)

    print('')
    print(30*'-')
    print("打包文件数  :"+str(len(result)))
    print("打包文件路径:\'"+tarfilename+"\' 已经复制到粘贴板!!")
EOF
endfunction

function! TarModifyFile()
    if g:tarmodifyfile_path!=''
        let choice=confirm("Upload file?", "&modefy\n&All\n&&Cancel",1)
        if choice==3
            return
        endif

        if g:tarmodifyfile_zlib==0
            let s:zlibopt=''
        else
            let s:zlibopt=' -z '
        endif

        if isdirectory(g:tarmodifyfile_path)
        else
            echo "Failed!!! is not directory:".g:tarmodifyfile_path
            return
        endif

        call DoTarModifyFile(getcwd(),g:iswindows,g:tarmodifyfile_path,choice)
    endif
endfunction

function! SaveLatestModifyFileName(is_update)
    if(g:proj_type!="cpp" && g:proj_type!="php" && g:proj_type!="pkm")
        return
    endif

    if(a:is_update==1)
        let g:chiyl_last_modify_file_name=strpart(expand("%:p"),strlen(getcwd())+1)
    else
        call writefile([g:chiyl_last_modify_file_name], ".last_modify_file");
    endif
endfunction

function! OpenLatestModifyFile()
    "TODO:在 iOA监控下，打开很慢，后面重构成 python的实现
    " "默认打开最近修改的文件
    " let vim_proj=$VIMPROJ."/Tool"
    " let cygwin_proj=$CYGWINPATH."/mintty.exe"
    " call delete(".openfile.tmp")
    " let a:tips="wait for update last modify file:.openfile.tmp "
    " if(g:iswindows==1)
    "     let cmd= "! ".cygwin_proj." ".vim_proj."/get_the_latest_cppproj_modifty_file.sh"
    "     silent! execute cmd 

    "     while(!filereadable(".openfile.tmp"))
    "         echo a:tips
    "         let a:tips=a:tips."  .  "
    "         sleep 1
    "     endwhile

    "     source .openfile.tmp
    " else
    "     let cmd= "!sh ".vim_proj."/get_the_latest_cppproj_modifty_file.sh"
    "     silent! execute cmd 
    "     while(!filereadable(".openfile.tmp"))
    "         echo a:tips
    "         let a:tips=a:tips."  .  "
    "         sleep 1
    "     endwhile
    "     "source .openfile.tmp
    " endif
endfunction

