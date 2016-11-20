#!/bin/bash
# 创建项目列表支持：1,根据最近打开的时间次序进行排序;2,支持根据关键词进行筛选
# 每次启动项目，都记录一次打开的时间放到一个文件，打开时根据时间的倒序列出项目


# 项目列表
export __PRIORITY_FILE=".prio.launcher.chiyl";
export __USER_INPUT_LETTER="";
declare -a projectlist;

has_in_projectlist()
{ 
    local c=${1};
    local i;
    for i in ${projectlist[@]}; do [[ $i = $c ]] && return 1;
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
    echo "$p" >> $__PRIORITY_FILE && /Applications/MacVim.app/Contents/MacOS/Vim -g -S "$VIMPROJ/$p.vim";
    exit;
}

Select_prj(){
    local oldifs="$IFS";
    IFS=" ";
    local -a arr=($@);
    IFS=$oldifs;
    while true;do
        for(( i=0;i<${#arr[@]};i++)){
            [[ ! -z ${arr[$i]} ]] && printf "%2s) %-20s"   ${i} ${arr[$i]} && i=$(($i+1));
            [[ ! -z ${arr[$i]} ]] && printf "%2s) %-20s"   ${i} ${arr[$i]} && i=$(($i+1));
            [[ ! -z ${arr[$i]} ]] && printf "%2s) %-20s\n" ${i} ${arr[$i]};
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
            [[ -z $prj ]] && echo "invaliable input:$choice" && continue;
            [[ $prj = "EXIT" ]] && echo "exit" && exit;
            [[ $prj = "ALL" ]] && echo "Show Al" && __USER_INPUT_LETTER="" && return 1;
            read -p "Open Project $prj (y/n default:y)?" choice
            case "$choice" in 
                y|Y ) echo "yes" && Open_prj "$prj";;
                n|N ) echo "no" && continue;;
                *) echo "default" && Open_prj "$prj";;
            esac
        fi;
    done;
}

Main_Choice_proj()
{

    if [[ -f $__PRIORITY_FILE ]]; then
        oldifs="$IFS";
        IFS=$'\n';
        pri=( $(cat $__PRIORITY_FILE) );
        IFS="$oldifs";

        #print_arr ${pri[@]};

        for((n=${#pri[@]}-1;n>=0;n--));do i=${pri[$n]};
            [[ $i = "proj/template.vim" ]] && continue; 
            has_in_projectlist $i;
            [[ $? -eq 1 ]] && continue;
            projectlist+=($i);
        done;

        rm -f $__PRIORITY_FILE;
        for((n=${#projectlist[@]}-1;n>=0;n--));do i=${projectlist[$n]};
            echo $i>>$__PRIORITY_FILE;
        done;
    fi

    for i in proj/*.vim;do  i=${i##*/};
        i=${i%%.vim};
        [[ $i = "template" ]] && continue;
        has_in_projectlist $i;
        [[ $? -eq 1 ]] && continue;
        projectlist+=($i);
    done;

    #for ((i=0;i<${#projectlist[@]};i++));do echo ${projectlist[$i]};
    #done

    #print_arr ${projectlist[@]};

    # 选择并启动对应的项目
    while true;do
        local -a my_prjlist=();
        if [[ ${#__USER_INPUT_LETTER} -ne 0 ]];then
            for i in ${projectlist[@]};do
                re='.*'$__USER_INPUT_LETTER'.*';
                [[ $i =~ $re ]] && my_prjlist+=($i);
            done;
            my_prjlist+=("ALL");
        else
            my_prjlist=${projectlist[@]};
        fi
        my_prjlist+=("EXIT");
        Select_prj ${my_prjlist[@]};
    done;

    #select prj in ${projectlist[@]};
    #do [[ $prj = "exit" ]] && exit;
    #    read -p "Open Project $prj (y/n)?" choice
    #    case "$choice" in 
    #        y|Y ) echo "yes" && Open_prj "$prj";;
    #        n|N ) echo "no";;
    #        *) echo "default" && Open_prj "$prj";;
    #    esac
    #done;
}

Main_Choice_proj;

