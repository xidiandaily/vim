"³õÊ¼»¯Mainº¯Êý
source  $VIMPROJ/Tool/main.vim

function! InitWorkSpace()
	normal gg
	normal /Logic
	normal o
	normal /GameServer.cpp
	normal o
	"normal /GameTable-gb.cpp
	"normal o
	:set rnu
endfunction

call Main("G:/boyaa/Redis2Log")
