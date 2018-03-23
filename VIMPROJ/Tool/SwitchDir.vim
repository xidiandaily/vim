function! UpdatePath(root)
python << EOF

import os
import vim

a_root      = vim.eval("a:root")
a_iswindows = vim.eval("g:iswindows")

if a_iswindows==1:
    base_dir=a_root.replace("/","\\")
else:
    base_dir=a_root

result=[]
for root, dirs, files in os.walk(base_dir):
    for file in files:
        rel=os.path.relpath(root,base_dir)
        if ".svn" in rel:
            continue;
        if ".git" in rel:
            continue;
        if not rel in result:
            result.append(rel)
            cmd=":set path+="+rel.replace(" ","\ ")
            vim.command(cmd)
EOF
endfunction

function! SwitchDir(filename)
    if !isdirectory(a:filename)
        if exists("*mkdir")
            call mkdir(a:filename,"p",0755)
        endif
    endif
    execute ":cd ".a:filename
    call UpdatePath(getcwd())
endfunction

