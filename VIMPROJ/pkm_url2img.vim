"³õÊ¼»¯Mainº¯Êý
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal /CardConfig
	normal o
	normal /Main.cpp
	normal o
    ":e makefile
endfunction

call Main("G:/work/url2img")
