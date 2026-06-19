#!/bin/bash

# 设置输出文件名
output_file="test.xyz"

# 删除已存在的输出文件
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

# 查找所有以数字开头的文件夹，并按数字顺序处理
find . -type d -name "[0-9]*" | sort -n | while read dir; do
    echo "正在处理文件夹: $dir"
    
    # 查找当前文件夹中以数字开头的.xyz文件，并按数字顺序处理
    find "$dir" -maxdepth 1 -type f -name "test*.xyz" | sort -n | while read file; do
        # 将文件内容追加到输出文件中
        cat "$file" >> "$output_file"
        echo "  已合并文件: $(basename "$file")"
    done
done

echo "合并完成！结果保存在 $output_file 中"
