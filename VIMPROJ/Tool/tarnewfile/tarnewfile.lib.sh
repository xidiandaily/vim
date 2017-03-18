## Created by lawrencechi 
## Licensed under the GNU GPLv3
## Web: http://blog.chiyl.info
##

function __init() {

	## -- BEGIN YOUR OWN APPLICATION INITIALIZATION CODE HERE --

	## parse command line options
	while getopts 'hxszalf:e:' opt; do
		case "${opt}" in
            ## opton x debug mode
            x)
                export __DebugMode=1 
                __msg debug "declare __DebugMode=${__DebugMode}"
                SetDebugMode;
                ;;
            h)
                export __HelpMode=1
                __msg debug "declare __HelpMode=${__HelpMode}"
                ;;
            s)
                export __SilentMode=1
                __msg debug "declare __SilentMode=${__SilentMode}"
                ;;
            z)
                export __ZlibMode=1
                __msg debug "declare __ZlibMode=${__ZlibMode}"
                ;;
            a)
                export __CompressMode="all"
                __msg debug "declare __ALLFILE=${__ALLFILE}"
                ;;
			## option e exclude
			e)
				__EXCLUDE="${OPTARG}"
                __msg debug "export __EXCLUDE=${__EXCLUDE}"
				;;
			## option f
			f)
				__FILTER="${OPTARG}"
                __msg debug "export __FILTER=${__FILTER}"
				;;
			## option l
			l)
				export __LISTFILE=1
                __msg debug "export __LISTFILE=${__LISTFILE}"
				;;
			## option without a required argument
			:)
				__die 2 "option -${OPTARG} requires an argument" 
				;;
			## unknown option
			\?)
				__die 2 "unknown option -${OPTARG}" 
				;;
			## this should never happen
			*)
				__die 2 "there's an error in the matrix!" 
				;;
		esac
		__msg debug "command line argument: -${opt}${OPTARG:+ '${OPTARG}'}"
	done

	## shift off options + arguments
	let OPTIND--; shift ${OPTIND}; unset OPTIND
	args="${@}"
    if [[ ${#@} = 0 ]];then
        Help;
        exit;
    fi
	set --

	return 0 # success

	## -- END YOUR OWN APPLICATION INITIALIZATION CODE HERE --
}

##
## application main function
##

function __main() {
    if [[ ${__DebugMode:-0} -eq 1 ]];then
        SetDebugMode;
    fi

    if [[ ${__HelpMode:-0} -eq 1 ]];then
        Help;
        exit;
    fi

    handle "${args}"
	return 0 # success

	## -- END YOUR OWN APPLICATION MAIN CODE HERE --

}

function Help(){
    echo "Usage: ${__ScriptFile}  [OPTION...] src [dst]"
    echo ""
    echo " [OPTION]"
    echo "   -f ;Exclude File "
    echo "   -e ;Exclude Dir "
    echo "   -x ;Set Debug Mode "
    echo "   -h ;show help info "
    echo "   -a ;whole dirtory [default  latest modify file]"
    echo "   -z ;zlib compress "
    echo "   -l ;list tar file name"
    echo "   -s ;Silent Mode "
    echo ""
    echo " [EXAMPLE]"
    echo "   ${__ScriptFile} -e '.svn .git' -f 'cscope.out tags' "
    echo "   ${__ScriptFile} -x -e '.svn .git' -f 'cscope.out tags' "
    echo ""
    echo " [AUTHOR]"
    echo "   lawrencechi 2017.03.17"
}

function SetDebugMode(){
    export __PrintPrefixScriptNamePid=1 # default: 1
    export __PrintPrefixTimestamp=1     # default: 1
    export __PrintPrefixSeverity=1      # default: 1
    export __PrintPrefixSource=1        # default: 1

    export __PrintDebug=1   # default: 0
    export __PrintInfo=1    # default: 1
    export __PrintNotice=1  # default: 1
    export __PrintWarning=1 # default: 1
    export __PrintErr=1     # default: 1
    export __PrintCrit=1    # default: 1
    export __PrintAlert=1   # default: 1
    export __PrintEmerg=1   # default: 1
}

function MissParam(){
    __msg err "$1 empty,please check params";
    echo "";
    echo "";
    Help;
    exit;
}

function MissPath(){
    __msg err "path:'$1' Not Found,please check params";
    echo "";
    echo "";
    Help;
    exit;
}

function InterActive(){
    if [[ ${__ZlibMode:-0} -eq 0 ]];then
        zlibtip="tar"
    else
        zlibtip="tar And compress"
    fi

    if [[ ${__CompressMode} = 'newer' ]];then
        dirtorytip="latest modify file"
    else
        dirtorytip="whole dirtory"
    fi

    __msg info "path              : ${__SRCDIR}"
    __msg info "zlib              : ${zlibtip}"
    __msg info "exclude           : ${__EXCLUDE:-'[empty]'}"
    __msg info "filterfile        : ${__FILTER:-'[empty]'}"
    __msg info "dirtory           : ${dirtorytip}"
    __msg info "compress filename : ${__DSTFILENAME}"
    read -p "compress? Yy/N:" n
    case $n in
        Y|y) 
            return
            ;;
        *) 
            __msg warning "operation abort"
            exit
            ;;
    esac
}

function handle()
{
    set -- $args
    export __SRCDIR=`realpath $1`
    export __TMPDIR='/tmp/'
    export __DSTFILENAME=${__TMPDIR}${__SRCDIR##*\/}.tarnewfile.tar${__ZlibMode:+.gz}
    export __TIMESTAMEFILE=${__TMPDIR}${__SRCDIR##*\/}'_lastcompress_time'
    if [[ -d $(realpath $2) ]];then
        export __DSTFILENAME=$(realpath $2)/${__SRCDIR##*\/}.tarnewfile.tar${__ZlibMode:+.gz}
    fi

    if [[ $(uname) = 'CYGWIN_NT-6.1' ]];then
        export __SRCDIR=`cygpath ${__SRCDIR}`
        export __TMPDIR=`cygpath ${__TMPDIR}`
        export __DSTFILENAME=`cygpath ${__DSTFILENAME}`
    fi

    # params check
    [[ -z ${__SRCDIR} ]] && MissParam src;
    [[ ! -d ${__SRCDIR} ]] && MissPath "${__SRCDIR}";
    [[ ! -d ${__TMPDIR} ]] && MissPath "${__TMPDIR}";
    __requireCommand 'find';
    __requireCommand 'tar';
    __requireCommand 'touch';

    # interactive mode
    [[ ${__CompressMode} = 'newer' ]] && [[ ! -f ${__TIMESTAMEFILE} ]] && export __CompressMode='all';
    [[ ${__SilentMode:-0} -eq 0 ]] && InterActive ;

    beforepath=$(pwd)
    cd ${__SRCDIR};
    export __SRCDIR=$(pwd)

    if [[ ${__CompressMode} = 'all' ]];then

        if [[ ${__LISTFILE:-0} -eq 1 ]];then
            _optlistfile=" -v "
        else
            _optlistfile=''
        fi

        if [[ ${__ZlibMode:-0} -eq 0 ]];then
            _optcompress=" -cf "
        else
            _optcompress=" -czf "
        fi

        for i in ${__EXCLUDE};do
            _optexclude=${_optexclude}' --exclude='$i;
        done

        for i in ${__FILTER};do
            _optexclude=${_optexclude}' --exclude='$i;
        done

        cmd="tar ${_optlistfile} ${_optcompress} ${__DSTFILENAME} ${_optexclude}  ./ "
        [[ ${__SilentMode:-0} -eq 0 ]] && echo $cmd
        [[ -f ${__DSTFILENAME} ]] && rm -f ${__DSTFILENAME}
        $cmd
        [[ -f ${__DSTFILENAME} ]] && echo ${__DSTFILENAME}
    elif [[  ${__CompressMode} = 'newer' ]];then
        if [[ ${__LISTFILE:-0} -eq 1 ]];then
            _optlistfile=" -v "
        else
            _optlistfile=''
        fi

        if [[ ${__ZlibMode:-0} -eq 0 ]];then
            _optcompress=" -cf "
        else
            _optcompress=" -czf "
        fi

        for i in ${__EXCLUDE};do
            _optexclude=${_optexclude}' --exclude='${i};
        done

        for i in ${__FILTER};do
            _optexclude=${_optexclude}' --exclude='$i;
        done

        compress_cmd="tar ${_optlistfile} ${_optcompress} ${__DSTFILENAME} ${_optexclude} --newer-mtime-than=${__TIMESTAMEFILE} ./ "
        [[ ${__SilentMode:-0} -eq 0 ]] && echo $compress_cmd
        [[ -f ${__DSTFILENAME} ]] && rm -f ${__DSTFILENAME}
        #fix:修复文件时候，只有直属文件夹 mtime 有改动,导致压缩命令 --newer-mtime-than 出错
        oldifs=IFS
        find ./ -type d -newer ${__TIMESTAMEFILE} -print0 | while ISF= read -r -d '' file;do
            cd "$file"
            while true; do
                touch ./ 
                [[ $(pwd) = ${__SRCDIR} ]] && break;
                cd ../
            done
        done
        unset IFS

        $compress_cmd
        [[ -f ${__DSTFILENAME} ]] && echo ${__DSTFILENAME}
    fi
    touch ${__TIMESTAMEFILE}

    [[ -f ${__DSTFILENAME} ]] && echo ${__DSTFILENAME} > /tmp/tarnewfile.compressfilename
    __msg info "compress done!"
    cd ${beforepath};
}

