function! HandleList()
    let s:ct=0
    for n in s:filelist
        if s:ct>31
            let s:it=printf("%d.%s",s:ct-31,n)
            call add(s:prjlist,s:it)
        endif
        let s:ct = s:ct+1
    endfor
endfunction

function! SwitchDir()
    echo s:filename
    if !isdirectory(s:filename)
        if exists("*mkdir")
            call mkdir(s:filename,"p",0755)
        endif
    endif
    execute ":cd ".s:filename
endfunction

function! InitWorkSpace()
    :e makefile
    :45split  main.c
    :50vsplit 题目.t2t
endfunction

"最大化窗口
:simalt ~x
let s:path="F:/work/Didit"
let s:lsout=system("ls -t ".s:path)
let s:filelist=split(s:lsout)
let s:prjlist=["请选择项目名称(鼠标点击，或者键入序号)\n"]
call HandleList()

let s:select=inputlist(s:prjlist)
if s:select >len(s:prjlist)
    :echo "\nout of range\n I will exit ....\n"
    :sleep 2
    :exit
elseif s:select==0
    :exit
endif

let s:filename=printf("%s/%s",s:path,s:filelist[31+s:select])
call SwitchDir()
call InitWorkSpace()
:set path=.,C:\MSYS\mingw\include,C:\MSYS\mingw\lib\gcc\mingw32\4.3.3\include,C:\MSYS\mingw\lib\gcc\mingw32\4.3.3\include\ssp,C:\MSYS\mingw\lib\gcc\mingw32\4.3.3\include\objc
