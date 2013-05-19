"function! SwitchDir()
"    echo s:filename
"    if !isdirectory(s:filename)
"        if exists("*mkdir")
"            call mkdir(s:filename,"p",0755)
"        endif
"    endif
"    execute ":cd ".s:filename
"endfunction

function! InitWorkSpace()
    :silent! ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
    :silent! cscope -Rbkq <CR>
    :silent! Tlist<CR> "按下F3就可以呼出了
    :silent! NERDTreeToggle<CR>
    ":e makefile
    ":45split  main.c
    ":50vsplit 题目.t2t
endfunction

"最大化窗口
:simalt ~x
"let s:path="F:/weibo/cpp"
"let s:tip="请选择项目名称\n目前已存在的项目如下:\n"
"let s:tip=s:tip.system("ls ".s:path)
"echo s:tip
"
"let s:input=input("输入项目名称:")
"if s:input==""
"    :exit
"endif
"let s:filename=s:path."/".s:input
"call SwitchDir()
"call InitWorkSpace()

:cd f:/weibo/cpp
:silent! ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
:silent! cscope -Rbkq
:set path+=tags
:cs add cscope.out
:silent! Tlist
:silent! NERDTreeToggle
:normal gg
:normal 8j
:normal o
:normal gg
:normal 7j
:normal o
:normal gg
:normal 33j
:set rnu
:normal o
:set path=.,C:\MSYS\mingw\include,C:\MSYS\mingw\lib\gcc\mingw32\4.3.3\include,C:\MSYS\mingw\lib\gcc\mingw32\4.3.3\include\ssp,C:\MSYS\mingw\lib\gcc\mingw32\4.3.3\include\objc
:set path+=F:\weibo\cpp
