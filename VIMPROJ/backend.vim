"³õÊ¼»¯Mainº¯Êý
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal /Logic
	normal o
	normal /CoreServer-sc.cpp
	normal o
	:set rnu
endfunction

call Main("G:/boyaa/MahjongMatchBackServer")
