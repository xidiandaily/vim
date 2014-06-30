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

function! Main(pa)
        "最大化窗口
        :simalt ~x
        let s:path=a:pa
        let s:filename=s:path
        call InitCPP()
        call InitLua()
        call InitPkm()
        call InitPHP()
        call SwitchDir(s:path)
        :silent! Tlist
        :NERDTree
        :set rnu
        call InitWorkSpace()
        :echo call(function(g:chiylown_func_dict.getprojtypefunc("CSTAG")),[])
endfunction


