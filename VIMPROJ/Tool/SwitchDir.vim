function! UpdatePath(root)
python3 << EOF
import os
import vim

class DirItem:
    def __init__(self,relpath,depno):
        self.relpath = relpath
        self.depno = depno

    def __lt__(self,other):
        if self.depno < other.depno:
            return True
        elif self.depno == other.depno and self.relpath < other.relpath:
            return True
        return False

    def __gt__(self,other):
        if self.depno > other.depno:
            return True
        elif self.depno == other.depno and self.relpath > other.relpath:
            return True
        return False

    def __eq__(self,other):
        return self.depno == other.depno and self.relpath == other.relpath

base_dir = vim.eval("a:root") 
result=[]
for root, dirs, files in os.walk(base_dir):
    dirs[:]=[d for d in dirs if d not in [".svn",".git"] ]
    bFoundHeader=False
    for filename in files:
        ext = os.path.splitext(filename)[1]
        if ext in ['.h','.hpp']:
            bFoundHeader = True
            break
    if not bFoundHeader:
        continue
    rel=os.path.relpath(root,base_dir)
    item=DirItem(rel,len(rel.split(os.path.sep)))
    if not item in result:
        result.append(item)

result.sort()
for r in result:
    cmd=":set path+="+r.relpath.replace(r" ",r"\ ")
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

