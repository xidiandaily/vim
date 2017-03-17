## Created by lawrencechi 
## Licensed under the GNU GPLv3
## Web: http://blog.chiyl.info
##

export __ScriptFile=${0##*/} # evaluates to "win2mnet.sh"
export __ScriptName=${__ScriptFile%.sh} # evaluates to "win2mnet"
export __ScriptPath=${0%/*}; __ScriptPath=${__ScriptPath%/} # evaluates to /path/to/win2mnet/win2mnet.sh
export __ScriptHost=$(hostname -f) # evaluates to the current hostname, e.g. host.win2mnet.com

export __BashinatorConfig="${__BashinatorConfig:-${__ScriptPath}/bashinator.cfg.sh}"
export __BashinatorLibrary="${__BashinatorLibrary:-${__ScriptPath}/bashinator.lib.0.sh}" # APIv0
if ! source "${__BashinatorConfig}"; then
    echo "!!! FATAL: failed to source bashinator config '${__BashinatorConfig}'" 1>&2
    exit 2
fi
if ! source "${__BashinatorLibrary}"; then
    echo "!!! FATAL: failed to source bashinator library '${__BashinatorLibrary}'" 1>&2
    exit 2
fi

__boot

export ApplicationConfig="${ApplicationConfig:-${__ScriptPath}/${__ScriptName}.cfg.sh}"
export ApplicationLibrary="${ApplicationLibrary:-${__ScriptPath}/${__ScriptName}.lib.sh}"
__requireSource "${ApplicationConfig}"
__requireSource "${ApplicationLibrary}"

__dispatch "${@}"

