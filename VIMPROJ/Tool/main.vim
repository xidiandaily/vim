"初始化CPP环境
source  $VIMPROJ/Tool/InitCPP.vim
"初始化工作目录
source  $VIMPROJ/Tool/SwitchDir.vim

function! Main(pa)
		"最大化窗口
		:simalt ~x
		let s:path=a:pa
		let s:filename=s:path
		call InitCPP()
		call SwitchDir(s:path)
		call Do_CsTag()
		:silent! Tlist
		:NERDTree
		:set rnu
		call InitWorkSpace()
		"execute "source ".a:initfile
endfunction


