function! HandleList()
    let s:ct=1
    for n in s:filelist
        let s:it=printf("%d.%s",s:ct,n)
        call add(s:prjlist,s:it)
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
    execute ":silent !cp ../t1.1/linux.mk linux.mk"
endfunction

function! InitWorkSpace()
    :e linux.mk
    :48split  main.c
endfunction

"最大化窗口
:simalt ~x
let s:path="F:/work/unix"
execute ":cd ".s:path
let s:lsout=system("ls -td */ ")
let s:filelist=split(s:lsout)
let s:prjlist=["请选择项目名称(鼠标点击，或者键入序号,0[esc]为新建项目)\n"]
let s:filename=""
call HandleList()

let s:select=inputlist(s:prjlist)
if s:select >len(s:prjlist)-1
    :echo "\nout of range\n I will exit ....\n"
    :sleep 2
    :exit
elseif s:select==0
    let s:input = inputdialog("请输入新项目名称:")
    if s:input == ""
        :exit
    endif
    let s:filename=printf("%s/%s",s:path,s:input)
else
    let s:filename=printf("%s/%s",s:path,s:filelist[s:select-1])
endif
call SwitchDir()
call InitWorkSpace()
:set path=.,C:/MSYS/mingw/include,C:/MSYS/mingw/lib/gcc/mingw32/4.3.3/include,C:/MSYS/mingw/lib/gcc/mingw32/4.3.3/include/ssp,C:/MSYS/mingw/lib/gcc/mingw32/4.3.3/include/objc
:set path=.,F:/Study/unix环境编程/src/apue.2e/include,
:set fileformat=unix
