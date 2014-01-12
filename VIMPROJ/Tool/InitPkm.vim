"函数
function UPFILE_pkm()
    let choice=confirm("Upload file?", "&modefy\n&All\n&Cancel",1)
    if (choice!=3)
        let vim_proj=$VIMPROJ."/Tool"
        let cygwin_proj=$CYGWINPATH."/mintty.exe"
        let cmd= "! ".cygwin_proj." ".vim_proj."/SSHFileuploadpkm.sh"." ".g:SSHSendDir." ".g:SSHUSER." ".g:SSHPORT." ".g:SSHRemoteDir." ".choice
        execute cmd
    endif
endfunction

function! InitPkm()
    :let g:proj_upload_dict["pkm"]="UPFILE_default"
    :set tags+=$VIMPROJ/vimlib/lua-5.1.5/tags,
endfunction
