"初始化基本代码
source  $VIMPROJ/Tool/InitBase.vim
"初始化CPP环境
source  $VIMPROJ/Tool/InitCPP.vim
"初始化LUA环境
source  $VIMPROJ/Tool/InitLua.vim
"初始化PKM环境
source  $VIMPROJ/Tool/InitPkm.vim
"初始化PHP环境
source  $VIMPROJ/Tool/InitPHP.vim
"初始化LGame环境
source  $VIMPROJ/Tool/InitLGameSvr.vim
"初始化Python环境
source  $VIMPROJ/Tool/InitPython.vim
"初始化VIM环境
source  $VIMPROJ/Tool/InitVim.vim
"初始化工作目录
source  $VIMPROJ/Tool/SwitchDir.vim


function! MaximizeWindow()    
    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

function! Main(pa)
        let s:path=a:pa
        let s:filename=s:path
        let g:tarmodifyfile_path=s:filename
        let g:tarmodifyfile_dstpath=''
        let g:tarmodifyfile_zlib=0      "是否压缩
        let g:tarmodifyfile_listfile=0  "是否打印文件列表
        let g:tarmodifyfile_exclude=".svn .git *.md tags cscope.files cscope.out *.swp *.tmp *.log *.tar .last_modify_file"
        call InitWorkSpace()

        let s:proj_type = get(g:,'proj_type','default')
        if 'lua' == s:proj_type
            call InitLua()
        elseif 'pkm' == s:proj_type
            call InitPkm()
        elseif 'php' == s:proj_type
            call InitPHP()
        elseif 'python' == s:proj_type
            call InitPython()
        elseif 'vim' == s:proj_type
            call InitVim()
        elseif 'cpp' == s:proj_type
            call InitCPP()
        elseif 'lgamesvr' == s:proj_type
            call InitLGameSvr()
        else
            call InitCPP()
        endif

        call SwitchDir(s:path)
        call OpenLatestModifyFile(getcwd(),g:iswindows)
        :NERDTree
        :set rnu
        if (g:iswindows!=1)
            :silent! Tlist
            :set rnu
        endif

        if 'cpp' == s:proj_type || 'lgamesvr' == s:proj_type
            if filereadable("cscope.out")
                silent! execute "cs add cscope.out"
            else
                :echo call(function(g:chiylown_func_dict.getprojtypefunc("CSTAG")),[])
            endif
        endif

        if(has("gui_macvim"))    
            :set fu
        endif
        "最大化窗口
        if (g:iswindows==1)
            :simalt ~x
        endif 
        :silent execute "redraw"
endfunction

