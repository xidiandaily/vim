"初始化基本代码
function! TarModifyFile()
    if g:tarmodifyfile_path!=''
        let choice=confirm("Upload file?", "&modefy\n&All\n&Option\n&Cancel",1)
        if choice==4
            return
        elseif choice==3
            let s:choiceopt=' -c '
        elseif choice==2
            let s:choiceopt=' -a '
        else 
            let s:choiceopt=''
        endif

        let vim_proj=$VIMPROJ."/Tool"
        if g:iswindows==1 
            let cygwin_proj=$CYGWINPATH."/mintty.exe"
        else
            let cygwin_proj='bash'
        endif

        if g:tarmodifyfile_zlib==0
            let s:zlibopt=''
        else
            let s:zlibopt=' -z '
        endif

        if g:tarmodifyfile_listfile==0
            let s:listopt=''
        else
            let s:listopt=' -l '
        endif

        if isdirectory(g:tarmodifyfile_path)
        else
            echo "Failed!!! is not directory:".g:tarmodifyfile_path
            return
        endif

        if isdirectory(g:tarmodifyfile_dstpath)
        else
            let g:tarmodifyfile_dstpath=g:tarmodifyfile_path."/../"
        endif

        if g:tarmodifyfile_exclude!=''
            let cmd= "! ".cygwin_proj." ".vim_proj
            let cmd= cmd."/tarnewfile/tarnewfile.sh -s"
            let cmd= cmd.s:zlibopt
            let cmd= cmd.s:choiceopt
            let cmd= cmd.s:listopt
            let cmd= cmd." -e \'".g:tarmodifyfile_exclude."\' "
            let cmd= cmd.g:tarmodifyfile_path." "
            let cmd= cmd.g:tarmodifyfile_dstpath
        else
            let cmd= "! ".cygwin_proj." ".vim_proj
            let cmd= cmd."/tarnewfile/tarnewfile.sh -s"
            let cmd= cmd.s:choiceopt
            let cmd= cmd.s:zlibopt
            let cmd= cmd.s:listopt
            let cmd= cmd.g:tarmodifyfile_path." "
            let cmd= cmd.g:tarmodifyfile_dstpath
        endif

        if(g:iswindows==1)
            silent execute cmd
        else
            execute cmd
        endif
    endif
endfunction

function! SaveLatestModifyFileName(is_update)
    if(g:proj_type!="cpp" && g:proj_type!="php" && g:proj_type!="pkm")
        return
    endif

    if(a:is_update==1)
        let g:chiyl_last_modify_file_name=strpart(expand("%:p"),strlen(getcwd())+1)
    else
        call writefile([g:chiyl_last_modify_file_name], ".last_modify_file");
    endif
endfunction

function! OpenLatestModifyFile()
    "默认打开最近修改的文件
    let vim_proj=$VIMPROJ."/Tool"
    let cygwin_proj=$CYGWINPATH."/mintty.exe"
    call delete(".openfile.tmp")
    let a:tips="wait for update last modify file:.openfile.tmp "
    if(g:iswindows==1)
        let cmd= "! ".cygwin_proj." ".vim_proj."/get_the_latest_cppproj_modifty_file.sh"
        silent! execute cmd 

        while(!filereadable(".openfile.tmp"))
            echo a:tips
            let a:tips=a:tips."  .  "
            sleep 1
        endwhile

        source .openfile.tmp
    else
        let cmd= "!sh ".vim_proj."/get_the_latest_cppproj_modifty_file.sh"
        silent! execute cmd 
        while(!filereadable(".openfile.tmp"))
            echo a:tips
            let a:tips=a:tips."  .  "
            sleep 1
        endwhile
        source .openfile.tmp
    endif
endfunction

