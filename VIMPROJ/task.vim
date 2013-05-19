"³õÊ¼»¯Mainº¯Êý
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal gg
	normal /src
	normal o
	normal /MainServer.cpp
	normal o
	"normal /GameTable-gb.cpp
	"normal o
	:set rnu
endfunction

call Main("G:/boyaa/Task")
