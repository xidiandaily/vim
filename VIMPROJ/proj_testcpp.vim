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
    :45split  main.cpp
    :50vsplit 题目.txt
endfunction

"初始化CPP环境
source  $VIMPROJ/Tool/InitCPP.vim

"最大化窗口
:simalt ~x
let s:path="F:/temp/testcpp"
let s:tip="请选择项目名称\n目前已存在的项目如下:\n"
let s:tip=s:tip.system("ls ".s:path)
echo s:tip
let s:input=input("输入项目名称:")
if s:input==""
    :exit
endif
let s:filename=s:path."/".s:input
call SwitchDir()
call InitWorkSpace()
call InitCPP()
:map <F5> :!main.exe<CR>
