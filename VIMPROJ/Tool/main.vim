"��ʼ����������
source  $VIMPROJ/Tool/InitBase.vim
"��ʼ��CPP����
source  $VIMPROJ/Tool/InitCPP.vim
"��ʼ��LUA����
source  $VIMPROJ/Tool/InitLua.vim
"��ʼ��PKM����
source  $VIMPROJ/Tool/InitPkm.vim
"��ʼ��PHP����
source  $VIMPROJ/Tool/InitPHP.vim
"��ʼ������Ŀ¼
source  $VIMPROJ/Tool/SwitchDir.vim


function! MaximizeWindow()    
    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

function! Main(pa)
        "��󻯴���
        if (g:iswindows==1)
            :simalt ~x
        endif 

        let s:path=a:pa
        let s:filename=s:path
        let g:tarmodifyfile_path=s:filename
        let g:tarmodifyfile_dstpath=''
        let g:tarmodifyfile_zlib=0      "�Ƿ�ѹ��
        let g:tarmodifyfile_listfile=0  "�Ƿ��ӡ�ļ��б�
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

