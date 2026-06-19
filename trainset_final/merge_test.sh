#!/bin/bash
# 合并所有以test开头的.xyz文件，排除自身，防止递归合并
find . -type f -name 'test*.xyz' ! -name 'test.xyz' -exec cat {} + > test.xyz
