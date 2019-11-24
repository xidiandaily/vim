#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import os
import argparse
import termcolor
import subprocess
import re
import fileinput

template_cpp='''
"这个文件试图使得创建 VIM 项目更加简单方便。
"①常用的全局设置已经在 _vimrc中设置了
"②常用的CPP设置在InitCPP.vim中设置
"③还有一些每个项目私有的设置，比如说项目的根目录，启动时需要打开的文件，一键上传的目录配置等
"③‘项目的私有设置在这个文件进行设置。
"

"初始化Main函数
source  $VIMPROJ/Tool/main.vim
function! InitWorkSpace()
    let g:proj_type="{}"
    "let g:tarmodifyfile_path="$Your Comparess Project_ROOTDIR"
endfunction

"Main函数中的参数是项目所在的根目录
call Main("{}")
'''

def check_proj_exists(proj_name):
    return os.path.exists(os.path.join(PROJ_DIR,proj_name))

def get_proj_list(key):

    proj=[]
    #优先级
    if os.path.exists(PRIORITY_FILE):
        fh = open(PRIORITY_FILE, "r").readlines()
        for line in fh:
            line=line.strip()+".vim"
            if re.search(".*"+key+".*\.vim$",line,re.IGNORECASE):
                proj.append(line)
    proj.reverse()

    #文件夹
    indir=[]
    exclude=proj
    for dirpath,dirnames,filenames in os.walk(PROJ_DIR):
        for file in filenames:
            if re.search(".*"+key+".*\.vim$",file,re.IGNORECASE) and not file in exclude:
                indir.append(file)
        break
    return {"proj":proj,"indir":sorted(indir)}

def choice_proj(tip):
    key_reg=''
    bWrongNum=-1
    while True:
        pj=get_proj_list(key_reg)
        alllist=pj['proj']+pj['indir']
        idx=0
        maxlen=0
        for i in alllist:
            if maxlen<len(i):
                maxlen=len(i)
        result=[]
        for i in alllist:
            idx+=1
            text="{}.{}".format(idx,i.replace(".vim",""))
            ctext=termcolor.colored(text)
            if i in pj['proj']:
                ctext=termcolor.colored(text,color="green")
            result.append(ctext)
        itemCnt=len(result)
        idx=0
        while idx<(3-itemCnt%3):
            result.append("")
            idx+=1
        idx=0
        defaulttext=""
        while idx < itemCnt:
            text="{:<50}{:<50}{:<50}".format(result[idx],result[idx+1],result[idx+2])
            if defaulttext=="":
                defaulttext=result[idx]
            idx=idx+3
            print(text)
        print(30*"-")
        if bWrongNum!=-1:
                termcolor.cprint("ID:'{}' not found,retry agin".format(bWrongNum),color="red")
        sys.stdout.write("input name OR id OR exit (default {}):".format(termcolor.colored(defaulttext,color="blue")))
        key_reg=raw_input("")
        if key_reg=="":
            key_reg='1'
        bWrongNum=-1
        if key_reg.isdigit():
            if int(key_reg)>itemCnt or int(key_reg)<=0:
                bWrongNum=key_reg
                key_reg=''
                continue
            else:
                proj_name=alllist[int(key_reg)-1]
                sys.stdout.write(tip+" {} Yy/N(default:Y):".format(termcolor.colored(proj_name,color="blue")))
                bOpen=raw_input("")
                if bOpen=='N' or bOpen=='n':
                    sys.exit('exit')
                else:
                    return proj_name
        elif key_reg=='exit':
            sys.exit('exit')

def open_proj(fname):
    if not check_proj_exists(fname):
        sys.exit("open faile, {} not found!".format(fname))

    with open(PRIORITY_FILE,"a") as myfile:
        myfile.write(fname.replace(".vim",""))
        myfile.write("\n")

    filelist=[]
    fh = open(PRIORITY_FILE, "r").readlines()
    for line in fh:
        filelist.append(line)
    result=[]
    for i in reversed(filelist):
        if not i in result:
            result.append(i)
        if len(result)>=6:
            break
    with open(PRIORITY_FILE,"w") as myfile:
        for i in reversed(result):
            myfile.write(i)
    #subprocess.call(cmd, shell=True)
    process=subprocess.Popen([os.environ.get('EDITOR', 'gvim'),'-g','-S',os.path.join(PROJ_DIR,fname)])
    sys.exit()

def del_proj(fname,is_exit):
    if not check_proj_exists(fname):
        sys.exit("delete faile, {} not found!".format(fname))
    subprocess.call(["rm","-f",os.path.join(PROJ_DIR,fname)], shell=False)

    with open(PRIORITY_FILE,"a") as myfile:
        myfile.write(fname.replace(".vim",""))
        myfile.write("\n")

    filelist=[]
    fh = open(PRIORITY_FILE, "r").readlines()
    for line in fh:
        if fname!=line.strip()+".vim":
            filelist.append(line)
    with open(PRIORITY_FILE,"w") as myfile:
        for i in filelist:
            myfile.write(i)
    if is_exit:
        sys.exit("delete {} success".format(fname))

def remove_empty_proj():
    deletefiles=[]
    print(PROJ_DIR)
    for root,dirs,files in os.walk(PROJ_DIR):
        for f in files:
            if f == "template.vim":
                continue
            if not re.search("\.vim$",f):
                continue
            for line in fileinput.input(os.path.join(root,f)):
                result = re.search(r'call\s*?Main\s*\(\s*\"(.*?)\"\)',line)
                if result:
                    cur_proj_dir=result.group(1)
                    if not os.path.exists(cur_proj_dir):
                        deletefiles.append(f)
        break
    for i in deletefiles:
        print("remove empty proj:"+termcolor.colored(i,color="red"))
        del_proj(i,0)


def list_proj():
    pj=get_proj_list('')
    alllist=pj['proj']+pj['indir']
    for i in alllist:
        print(i)

def create_proj(path,type,name):
    content=template_cpp.format(type,path.replace("\\","/"))
    with open(os.path.join(PROJ_DIR,name+".vim"),"w") as myfile:
        myfile.write(content)
        sys.exit("create project({}) done!".format(termcolor.colored("{}".format(name),color="red")))

def new_proj():
    proj_path=raw_input("project path:")

    if os.path.isfile(proj_path):
        proj_path=os.path.dirname(proj_path)

    if not os.path.exists(proj_path):
        sys.exit("{} path not found",proj_path)
    idx=0
    while idx < len(SUPPORT_TYPES):
        print("{}.{}".format(int(idx)+1,SUPPORT_TYPES[idx]))
        idx+=1
    choice=raw_input("choice project type({}):".format(termcolor.colored("{}.{}".format(1,SUPPORT_TYPES[0]),color="blue")))
    if choice=='':
        choice='1'
    if not choice.isdigit() or not int(choice) in range(1,len(SUPPORT_TYPES)+1):
        sys.exit("'{}' project type not found".format(proj_path))
    proj_type=SUPPORT_TYPES[int(choice)-1]
    dir1=os.path.split(proj_path)
    proj_name=dir1[1]
    if os.path.exists(os.path.join(PROJ_DIR,proj_name+".vim")):
        #如果工程存在，则名称加上父目录
        dir2=os.path.split(dir1[0])
        proj_name=dir2[1][:5].upper()+"_"+dir1[1]

    if os.path.exists(os.path.join(PROJ_DIR,proj_name+".vim")):
        #如果还存在，那就加数字吧
        idx=0
        tmp_proj_name=proj_name
        while os.path.exists(os.path.join(PROJ_DIR,tmp_proj_name+".vim")):
            tmp_proj_name="{}{}".format(proj_name,idx)
            idx+=1
        proj_name=tmp_proj_name
    tmpName=raw_input("input project name(default name:"+termcolor.colored("{}".format(proj_name),color="blue")+"):")
    if tmpName:
        proj_name=tmpName

    if os.path.exists(os.path.join(PROJ_DIR,proj_name+".vim")):
        sys.exit("proj_name exists:"+proj_name)

    print(30*'-')
    print("PATH: "+termcolor.colored(proj_path,color="blue"))
    print("TYPE: "+termcolor.colored(proj_type,color="blue"))
    print("NAME: "+termcolor.colored(proj_name,color="blue"))
    print(30*'-')
    choice=raw_input("create project? Yy/Nn"+termcolor.colored("(default:N):",color="blue"))
    if choice!='Y' and choice!='y':
        sys.exit("exit")
    create_proj(proj_path,proj_type,proj_name)



# argument
description='''
show OR create vimproject

author :lawrencechi
version:1.0
'''
args_parser = argparse.ArgumentParser(description=description,formatter_class=argparse.RawTextHelpFormatter)
args_parser.add_argument('-c','--choice',action='store_true', help='list all project and choice')
args_parser.add_argument('-l','--list',action='store_true', help='display all project')
args_parser.add_argument('-n','--new',action='store_true', help='create proj')
args_parser.add_argument('-d','--delete',action='store_true', help='delete proj')
args_parser.add_argument('-r','--remove',action='store_true', help='remove empty proj')
args = args_parser.parse_args()

if not args.choice and not args.list and not args.new and not args.delete:
    #args_parser.print_help()
    args.choice=True

# init
VIMPROJ=os.getenv("VIMPROJ")
PROJ_DIR=VIMPROJ
PRIORITY_FILE=os.path.join(PROJ_DIR,".prio.launcher.chiyl")
SUPPORT_TYPES=["empty","cpp","php","python"]

if not os.path.exists(VIMPROJ):
    sys.exit("VIMPROJ EMPTY")

if args.remove:
    remove_empty_proj()
    sys.exit("remove all empty proj")

if args.new:
    new_proj()

if args.list:
    list_proj()
if args.delete:
    del_proj(choice_proj("delete proj"),1)

if args.choice:
    open_proj(choice_proj("open proj"))

