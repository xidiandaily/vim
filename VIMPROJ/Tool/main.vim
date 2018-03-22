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
"初始化工作目录
source  $VIMPROJ/Tool/SwitchDir.vim


function! MaximizeWindow()    
    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

function! Main(pa)
        "最大化窗口
        if (g:iswindows==1)
            :simalt ~x
        endif 

        let s:path=a:pa
        let s:filename=s:path
        let g:tarmodifyfile_path=s:filename
        let g:tarmodifyfile_dstpath=''
        let g:tarmodifyfile_zlib=0      "是否压缩
        let g:tarmodifyfile_listfile=0  "是否打印文件列表
        let g:tarmodifyfile_exclude=".svn .git *.md tags cscope.files cscope.out *.swp *.tmp *.log *.tar .last_modify_file"
        call InitCPP()
        call InitLua()
        call InitPkm()
        call InitPHP()
        call SwitchDir(s:path)
        call OpenLatestModifyFile(getcwd(),g:iswindows)
        ":silent! Tlist
        :NERDTree
        :set rnu
        call InitWorkSpace()
        :set rnu
        if filereadable("cscope.out")
            silent! execute "cs add cscope.out"
        else
            :echo call(function(g:chiylown_func_dict.getprojtypefunc("CSTAG")),[])
        endif

        "autocmd
        autocmd BufWritePost *	call SaveLatestModifyFileName(1)
        autocmd VimLeave *	call SaveLatestModifyFileName(0)

        if(has("gui_macvim"))    
            set fu
        endif
        silent execute "redraw"
endfunction

