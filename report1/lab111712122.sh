#!/bin/bash

# from root with BFS
# Print all files and folders in the top
# special case:
# a) Special characters in path
# b) the result file not exist:build a new
# c) the folder path store in [] is not absolute path(basename)
# d) get the absolute path fron ../
# handle problem a
SAVEIFS=$IFS
IFS=$(echo -en "\n\b") 

# handle problem d
original=`pwd`
cd $1
root_path=`pwd`
cd $original

result_file=$2

folder_count=0
file_count=0

#------------------------
#define a queue
queue[0]=$root_path
head_index=0
tail_index=1
top=${queue[0]}
function push(){ 
    queue[${tail_index}]=$1
    tail_index=$((${tail_index}+1))
}
function pop(){ 
    head_index=$((${head_index}+1))
}

# -----------------------
# handle probel b
res_path=${result_file%/*}
res_name=${result_file##*/}

if [ -f $result_file ];then
    rm $result_file
else
    if [ ! -d $res_path ];then
        mkdir -p $res_path
    fi
fi
touch $result_file

# -----------------------
while [ ${head_index} -ne $((${tail_index})) ]
do
    top=${queue[head_index]}
    last=$(basename "$top")
    echo "["${last}"]" >>$result_file
    pop
    for var in `ls $top`
    do
        if [ -d $top"/"$var ];then
            folder_count=$(($folder_count+1))
            push $top"/"$var
        else
            file_count=$((${file_count}+1))
        fi
        echo "$top/$var" >>$result_file
    done
    echo "" >>$result_file
done
echo "[Directories Count]:"${folder_count} >>$result_file
echo "[Files Count]:"$file_count >>$result_file
IFS=$SAVEIFS

