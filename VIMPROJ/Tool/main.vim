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
"��ʼ��LGame����
source  $VIMPROJ/Tool/InitLGameSvr.vim
"��ʼ��Python����
source  $VIMPROJ/Tool/InitPython.vim
"��ʼ��VIM����
source  $VIMPROJ/Tool/InitVim.vim
"��ʼ������Ŀ¼
source  $VIMPROJ/Tool/SwitchDir.vim


function! MaximizeWindow()    
    silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
endfunction

function! Main(pa)
        let s:path=a:pa
        let s:filename=s:path
        let g:tarmodifyfile_path=s:filename
        let g:tarmodifyfile_dstpath=''
        let g:tarmodifyfile_zlib=0      "�Ƿ�ѹ��
        let g:tarmodifyfile_listfile=0  "�Ƿ��ӡ�ļ��б�
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
        "��󻯴���
        if (g:iswindows==1)
            :simalt ~x
        endif 
        :silent execute "redraw"
endfunction

