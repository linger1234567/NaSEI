#!/bin/bash

# 设置输出文件名
output_file="train.xyz"
log_file="mergetrainlog.txt"

# 删除已存在的输出文件和日志文件
if [ -f "$output_file" ]; then
    rm "$output_file"
fi
if [ -f "$log_file" ]; then
    rm "$log_file"
fi

# 函数用于记录日志（同时输出到屏幕和日志文件）
log_message() {
    echo "$1"
    echo "$1" >> "$log_file"
}

# 初始化帧数计数器
total_frames=0
current_frame=1

log_message "开始合并XYZ文件..."
log_message "=========================================="

# 使用临时文件来存储文件夹列表
folder_list=$(mktemp)
find . -type d -name "[0-9]*" | sort -n > "$folder_list"

# 处理每个文件夹
while read dir; do
    log_message "正在处理文件夹: $dir"
    
    # 使用临时文件来存储文件列表
    file_list=$(mktemp)
    find "$dir" -maxdepth 1 -type f -name "[0-9]*.xyz" | sort -n > "$file_list"
    
    # 处理每个文件
    while read file; do
        # 计算当前文件中的帧数
        frames_in_file=$(grep -c '^[0-9][0-9]*$' "$file")
        
        # 记录结构范围信息
        start_frame=$current_frame
        end_frame=$((current_frame + frames_in_file - 1))
        log_message "  文件: $(basename "$file") - 帧范围: $start_frame 到 $end_frame"
        log_message "  对应结构: $dir/$(basename "$file")"
        
        # 将文件内容追加到输出文件中
        cat "$file" >> "$output_file"
        
        # 更新帧数计数器
        current_frame=$((current_frame + frames_in_file))
        total_frames=$((total_frames + frames_in_file))
    done < "$file_list"
    
    rm "$file_list"
done < "$folder_list"

rm "$folder_list"

log_message "=========================================="
log_message "合并完成！"
log_message "总帧数: $total_frames"
log_message "结果保存在 $output_file 中"
log_message "详细信息已记录到 $log_file 中"
