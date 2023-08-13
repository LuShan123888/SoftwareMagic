#! /bin/bash
baseDir=~/Code/SoftwareMagic/source/_posts; # 根目录
function front_matter(){
    for file in `ls $1` #注意此处这是两个反引号，表示运行系统命令
    do
        {
        if [ -d $1"/"$file ] #注意此处之间一定要加上空格，否则会报错
        then
            front_matter $1"/"$file
        else
            dir=$1 # 当前目录
            fullPath=$1"/"$file
            createdTime=$(GetFileInfo -d $fullPath) # 获取文件创建时间
            modifiedTime=$(GetFileInfo -m $fullPath) # 获取文件修改时间
            echo $fullPath # 输出正在处理的文件
            path=${dir:${#baseDir}+1} # 截取相对路径
            categories=(${path//// }) # 根据路径生成目录数组
            gsed -i '1h;1G' $fullPath # 复制标题行
            gsed -i '1 s/^# /title: /' $fullPath # 将其中的一个标题行转为front-matter的title
            gsed -i "1 i\---" $fullPath
            gsed -i "2 a\categories:" $fullPath
            gsed -i "3 a\---" $fullPath    
            for(( i=${#categories[@]}-1;i>=0;i--)) # 写入目录数组
            do
                gsed -i "4 i\- ${categories[i]}" $1"/"$file
            done
            SetFile -d "$createdTime" $fullPath # 写入文件创建时间
            SetFile -m "$modifiedTime" $fullPath # 获取文件修改时间
        fi
        }

    done
}

# 替换post文件夹
rm -rf ~/Code/SoftwareMagic/source/_posts/*
cp -rfp ~/Documents/Notes/Software ~/Code/SoftwareMagic/source/_posts/Software
cp -rfp ~/Documents/Notes/Hardware ~/Code/SoftwareMagic/source/_posts/Hardware
cp -rfp ~/Documents/Notes/Internet ~/Code/SoftwareMagic/source/_posts/Internet

front_matter $baseDir;