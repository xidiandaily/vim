"初始化基本代码
function! DoTarModifyFile(root,iswindows,path,choice)
python << EOF
import os
import time
import re
import tarfile
import sys
import vim

escape_reg=["\.git","\.svn",".last_modify_file"]

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

if int(a_choice)==3:
    with open(last_update_file,"w") as myfile:
        myfile.write("0")
        myfile.close()
    a_choice=1

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
    tarfilename=os.path.abspath(tarfilename)
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
        let choice=confirm("Upload file?", "&modefy\n&All\n&SetTstamp\n&OpenLatestFile\n&Cancel",1)
        if choice==5
            return
        endif

        if choice==4
            call OpenLatestModifyFile(getcwd(),g:iswindows)
            return
        endif

        if g:tarmodifyfile_zlib==0
            let s:zlibopt=''
        else
            let s:zlibopt=' -z '
        endif

        "if isdirectory(g:tarmodifyfile_path)
        "else
        "    echo "Failed!!! is not directory:".g:tarmodifyfile_path
        "    return
        "endif

        call DoTarModifyFile(getcwd(),g:iswindows,g:tarmodifyfile_path,choice)
    endif
endfunction

function! SaveLatestModifyFileName(is_update)
        return
endfunction

function! OpenLatestModifyFile(root,iswindows)
python << EOF
import os
import time
import re
import tarfile
import sys
import vim

escape_reg=["\.git","\.svn"]

g_proj_type = vim.eval("g:proj_type")
a_root      = vim.eval("a:root")
a_iswindows = vim.eval("g:iswindows")

if a_iswindows==1:
    base_dir=a_root.replace("/","\\")
else:
    base_dir=a_root

include_reg=[]
if g_proj_type=="cpp":
    include_reg=["\.cc$","\.hpp$","\.h$","\.cpp$"]

cur_tstamp=time.time()
max_tstamp=0
last_modify_filename=''
for root, dirs, files in os.walk(base_dir):
    for file in files:
        filename=os.path.join(root,file)
        if re.search("^\.",os.path.basename(filename)):
            continue

        bEscape=True
        for regex in escape_reg:
            m=re.search(regex,filename)
            if m:
                bEscape=False
        if not bEscape:
            continue

        bEscape=False
        if len(include_reg)>0:
            bEscape=True
            for regex in include_reg:
                m=re.search(regex,filename)
                if m:
                    bEscape=False
        if bEscape:
            continue
        cur=os.path.getmtime(filename)
        if abs(cur-cur_tstamp) < abs(max_tstamp-cur_tstamp):
            max_tstamp=cur
            last_modify_filename=os.path.join(root,file)
if not os.path.exists(last_modify_filename):
    print("{} filename not found!".format(last_modify_filename))
else:
    cmd=":silent e "+last_modify_filename
    vim.command(cmd)
EOF
endfunction

