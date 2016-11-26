#!/bin/bash
# 创建项目列表支持：1,根据最近打开的时间次序进行排序;2,支持根据关键词进行筛选
# 每次启动项目，都记录一次打开的时间放到一个文件，打开时根据时间的倒序列出项目


# 项目列表
export __PRIORITY_FILE=".prio.launcher.chiyl";
export __USER_INPUT_LETTER="";
export __USER_CHOICE_PROJ="";
export __USER_PROJ_NEWNAME="";
export __RED='\033[0;31m'
export __NC='\033[0m' # No Color
export __VERSION="1.0";
export __CHOICE_TIPS="";
export __SUPPORT_TYPES=(cpp php empty);
export __OSTYPE=$OSTYPE;
export __VIMPROJ=$VIMPROJ;
declare -a __PROJLIST;

Init(){
    [[ $__OSTYPE = "cygwin" ]] && export __VIMPROJ=${VIMPROJ//\\/\/};
    [[ -z $__VIMPROJ ]] && echo -e "${__RED}VIMPROJ EMPTY${__NC}"&& exit;
    [[ -d $__VIMPROJ ]] && cd $__VIMPROJ;
    [[ $? -eq 1 ]] && "cd vimproj:$__VIMPROJ Failed" && exit;
}


has_in_projectlist()
{ 
    local c=${1};
    local i;
    for i in ${__PROJLIST[@]}; do [[ $i = $c ]] && return 1;
    done;

    return 0;
}

print_arr(){
    local oldifs="$IFS";
    IFS=" ";
    local -a arr=($@);
    IFS=$oldifs;
    for ((i=0;i<${#arr[@]};i++));do
        echo "[$i] ${arr[$i]}";
    done
}

Open_prj(){
    local p=${1};
    local reg='.*darwin.*';
    [[ ! -f "$__VIMPROJ/$p.vim" ]] && echo -e "${__RED}$p not found ${__NC}" && exit;
    echo "$p" >> $__PRIORITY_FILE;
    if [[ $__OSTYPE = "cygwin" ]];then
        run env HOME=/cygdrive/c/Users/lawrencechi/ VIMPROJ=D:/Vim/VIMPROJ CYGWINPATH=C:/cygwin64/bin gvim -wait -S "$__VIMPROJ/$p.vim" &
        sleep 10;
    elif [[ $__OSTYPE =~ $reg ]];then
        /Applications/MacVim.app/Contents/MacOS/Vim -g -S "$__VIMPROJ/$p.vim";
    else
        echo "$__OSTYPE not support";
    fi  
    exit;
}

Rename_prj(){
    local old_projname=${1};
    local proj_name=${2};
    [[ -z $old_projname ]] || [[ -z $proj_name ]] && echo -e "old_projname:$old_projname or proj_name:$proj_name EMPTY" && exit;
    [[ ! -f "$__VIMPROJ/$old_projname.vim" ]] && echo -e "${__RED} ${__VIMPROJ}/$old_projname.vim NOT FOUND!!${__NC}" && exit;
    [[ -f "$__VIMPROJ/$proj_name.vim" ]] && echo -e "${__RED} ${__VIMPROJ}/$proj_name.vim EXIT!!${__NC}" && exit;

    mv "${__VIMPROJ}/$old_projname.vim" "${__VIMPROJ}/$proj_name.vim";
    cat $__PRIORITY_FILE | grep -v -w "$old_projname" > $__PRIORITY_FILE;
    [[ -f $__VIMPROJ/PROJ/$p.sh ]] && rm -f "$__VIMPROJ/PROJ/$p.sh";
    [[ -f $__VIMPROJ/PROJ/$p.bat ]] && rm -f "$__VIMPROJ/PROJ/$p.bat";
    echo -e "${__RED} Rename $old_projname to $proj_name DONE";
    exit;
}

Add_prj(){
    set -- ${@};
    local proj_name=${1};
    local proj_path=${2};
    local proj_type=${3};
    echo "new:"$proj_name $proj_path $proj_type;
    [[ -d $__VIMPROJ ]] && cd $__VIMPROJ; 
    [[ $? -eq 1 ]] && echo "create failed!" &&exit;
    cp template.vim $proj_name.vim;
    [[ ! -f "$proj_name.vim" ]] && echo "copy template failed!" && exit;
    perl -pi.bak -ne 's/.*proj_type="cpp"/    let g:proj_type="cpp"/' $proj_name.vim;
    perl -pi.bak -ne 's/call Main.*/call Main('\\\"${proj_path//\//\\\/}\\\"')/' $proj_name.vim;
    #echo "call Main(\"$proj_path\")" >> $proj_name.vim;
    [[ -f $proj_name.vim.bak ]] && rm -f $proj_name.vim.bak;

    echo -e "Create Project ${__RED} $proj_name ${__NC} Sucessed";
}

Del_prj(){
    local p=${1};
    echo "handle delete $p";
    [[ -f $__VIMPROJ/$p.vim ]] && rm -f "$__VIMPROJ/$p.vim";
    [[ $? -eq 1 ]] && echo -e "${__RED}delete project($p) failed!${__NC}" && exit;

    [[ -f $__VIMPROJ/PROJ/$p.sh ]] && rm -f "$__VIMPROJ/PROJ/$p.sh";
    [[ -f $__VIMPROJ/PROJ/$p.bat ]] && rm -f "$__VIMPROJ/PROJ/$p.bat";
    cat $__PRIORITY_FILE | grep -v -w "$p" > $__PRIORITY_FILE;
    echo -e "${__RED}delete $p done${__NC}";
    exit;
}

Select_prj()
{
    local oldifs="$IFS";
    IFS=" ";
    local -a arr=($@);
    IFS=$oldifs;
    while true;do
        for(( i=0;i<${#arr[@]};i++)){
            [[ ! -z ${arr[$i]} ]] && printf "%2s) %-50s"   ${i} ${arr[$i]} && i=$(($i+1));
            [[ ! -z ${arr[$i]} ]] && printf "%2s) %-50s"   ${i} ${arr[$i]} && i=$(($i+1));
            [[ ! -z ${arr[$i]} ]] && printf "%2s) %-50s\n" ${i} ${arr[$i]};
        }
        echo "";
        read -p "Select Project[Default 0]:" choice;
        [[ -z $choice ]] && choice=0;

        re='^[0-9]+$';
        if [[ ! $choice =~ $re ]]; then
            __USER_INPUT_LETTER=$choice;
            return 1;
        else
            local prj=${arr[$choice]};
            [[ -z $prj ]] && echo -e "${__RED}invaliable input:$choice${__NC}" && continue;
            [[ $prj = "EXIT" ]] && echo -e "${__RED}exit${__NC}" && exit;
            [[ $prj = "ALL" ]] && echo -e "${__RED}Show Al${__NC}" && __USER_INPUT_LETTER="" && return 1;
            echo -e "${__CHOICE_TIPS} ${__RED}$prj${__NC}?";
            read -p "choice(y/n default:y):" choice;
            case "$choice" in 
                y|Y ) echo -e "${__RED}yes${__NC}" && __USER_CHOICE_PROJ="$prj" && return 0;;
                n|N ) echo -e "${__RED}no${__NC}" && continue;;
                *) echo -e "${__RED}default y${__NC}" &&__USER_CHOICE_PROJ="$prj" && return 0;;
            esac
        fi;
    done;
}

List_prj()
{
    if [[ -f $__PRIORITY_FILE ]]; then
        oldifs="$IFS";
        IFS=$'\n';
        pri=( $(cat $__PRIORITY_FILE) );
        IFS="$oldifs";

        for((n=${#pri[@]}-1;n>=0;n--));do i=${pri[$n]};
            has_in_projectlist $i;
            [[ $? -eq 1 ]] && continue;
            __PROJLIST+=($i);
        done;

        rm -f $__PRIORITY_FILE;
        for((n=${#__PROJLIST[@]}-1;n>=0;n--));do i=${__PROJLIST[$n]};
            echo $i>>$__PRIORITY_FILE;
        done;
    fi

    for i in "$__VIMPROJ"/*.vim;do  i=${i##*/};
        i=${i%%.vim};
        [[ $i = "template" ]] && continue;
        has_in_projectlist $i;
        [[ $? -eq 1 ]] && continue;
        __PROJLIST+=($i);
    done;
}

Main_Choice_proj()
{
    List_prj;
    # 选择并启动对应的项目
    while true;do
        local -a my_prjlist=();
        if [[ ${#__USER_INPUT_LETTER} -ne 0 ]];then
            for i in ${__PROJLIST[@]};do
                echo "$i" | grep -i "$__USER_INPUT_LETTER" >/dev/null 2>&1 ;
                [[ "$?" -eq 1 ]] && continue;
                my_prjlist+=($i);
            done;
            my_prjlist+=("ALL");
        else
            my_prjlist=${__PROJLIST[@]};
        fi
        my_prjlist+=("EXIT");
        Select_prj ${my_prjlist[@]};
        if [[ $? -eq 0 ]];then
            return 0;
        fi;
    done;
}

Main_Add_proj(){
    local proj_name="";
    local proj_path="";
    local proj_type="";
    while true;do
        read -p "PROJ PATH:" proj_path;
        [[ ! -d $proj_path ]] && echo "PATH Not Found" && continue;
        break;
    done;

    declare -a types=${__SUPPORT_TYPES[@]};
    select i in ${types[@]};do
        [[ -z $i ]] && echo "invalid input" && continue;
        proj_type=$i;
        break;
    done;

    while true;do
        read -p "PROJ NAME:" proj_name;
        [[ -z "$proj_name" ]] && continue;
        echo "$proj_name" | grep -e '|' -e '/' -e ' ' -e '*' -e '\\' && echo -e "${__RED}format error${__NC}" && continue;
        [[ -f "$__VIMPROJ/$proj_name.vim" ]] && "PROJ Exists" && continue;
        break;
    done;

    echo -e "${__RED}----CONFIRM---${__NC}";
    echo -e "PROJ NAME:  ${__RED}$proj_name${__NC}";
    echo -e "PROJ PATH:  ${__RED}$proj_path${__NC}";
    echo -e "PROJ TYPES: ${__RED}$proj_type${__NC}";
    read -p "CREATE Project(y/n)[Default n]:" choice;
    declare -a newproj=($proj_name $proj_path $proj_type);
    case "$choice" in 
        y|Y ) echo -e "${__RED}yes${__NC}" && Add_prj ${newproj[@]} && exit;;
        n|N ) echo -e "${__RED}no${__NC}" && exit;;
        *) echo -e "${__RED}default no${__NC}" &&exit;;
    esac
}

Main_Rename(){
    local proj_name="";
    while true;do
        read -p "NEW PROJ NAME:" proj_name;
        [[ -z "$proj_name" ]] && continue;
        echo "$proj_name" | grep -e '|' -e '/' -e ' ' -e '*' -e '\\' && echo -e "${__RED}format error${__NC}" && continue;
        [[ -f "$__VIMPROJ/$proj_name.vim" ]] && "PROJ Exists" && continue;
        break;
    done;

    export __USER_PROJ_NEWNAME=$proj_name;
}

Main_Showproj(){
    List_prj;
    for i in ${__PROJLIST[@]};do
        echo $i;
    done
}

Main_help(){
    echo "${0#.*/} version:$__VERSION author by lawrencechi";
    echo "email: codeforfuture{AT}126.com";
    echo "";
    echo "manual:";
    echo "$0                                  display all project and choice ";
    echo "$0 -r                               display all project and choice ";
    echo "$0 -l                               list all project";
    echo "$0 -a                               create proj";
    echo "$0 -m                               rename proj";
    echo "$0 -m [projname] [newprojectname]   rename proj";
    echo "$0 -d                               delete proj";
    echo "$0 -v                               display version";
    echo "$0 -h                               display help";
}

Init;
[[ $__OSTYPE = "cygwin" ]] && [[ $# -eq 0 ]] && echo "Press Alt+Enter FullScreen" && read;
if [[ $# -eq 0 ]] || [[ ${1} = "-r" ]];then
    export __USER_CHOICE_PROJ=${2};
    if [[ -z $__USER_CHOICE_PROJ ]];then
        export __CHOICE_TIPS="Open Project:";
        Main_Choice_proj;
    fi
    if ! [[ -z $__USER_CHOICE_PROJ ]];then
        Open_prj "$__USER_CHOICE_PROJ";
    fi
elif [[ ${1} = "-a" ]];then
    echo "Create New Proj";
    Main_Add_proj;
elif [[ ${1} = "-m" ]];then
    export __USER_CHOICE_PROJ=${2};
    export __USER_PROJ_NEWNAME=${3};
    if [[ -z $__USER_PROJ_NEWNAME ]] || [[ -z $__USER_CHOICE_PROJ ]];then
        echo "Rename Proj";
        export __CHOICE_TIPS="Rename Project:";
        Main_Choice_proj;
        if [[ $? -eq 0 ]];then
            Main_Rename;
        fi
    fi
    Rename_prj "$__USER_CHOICE_PROJ" "$__USER_PROJ_NEWNAME";
elif [[ ${1} = "-d" ]];then
    export __CHOICE_TIPS="Delete Project:";
    echo "Choice Delete Proj";
    Main_Choice_proj;
    if [[ $? -eq 0 ]];then
        Del_prj "$__USER_CHOICE_PROJ";
    fi
elif [[ ${1} = "-l" ]];then
    Main_Showproj;
elif [[ ${1} = "-v" ]];then
    echo "version:"$__VERSION;
else
    Main_help;
fi

