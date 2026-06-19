#!/usr/bin/env python 
# -*- coding: utf-8 -*-
# @Time    : 2024/10/27 17:16
# @Author  : 兵
# @email    : 1747193328@qq.com
import numpy as np
from ase.io import read as ase_read
from calorine.nep import get_descriptors
from matplotlib import pyplot as plt
from sklearn.decomposition import PCA

config=[
    #(文件名,图例,图例颜色)
    #("./train.xyz", "train", "#1F78B4"),  # 蓝色
    ("./Electrolyte.xyz", "Electrolyte", "#16068A"),  # 深蓝色
    ("./Interface system.xyz", "Interface system", "#FF0000"),  # 红色
    ("./Na metal.xyz", "Na metal", "#ED7954"),  # 橙色
    ("./Na alloys.xyz", "Na alloys", "#6A3D9A"),  # 紫色
    ("./Sodium carbonate.xyz", "Sodium carbonate", "#33A02C"),  # 绿色
    # 使用主题配色方案中的浅蓝色 (#90BEE0) 替代重复的绿色
    ("./Sodium hexafluorophosphate.xyz", "Sodium hexafluorophosphate", "#90BEE0"),  # 浅蓝色
    ("./Sodium oxide.xyz", "Sodium oxide", "#FFDF33"),  # 黄色
    # 使用主题配色方案中的橙色 (#FC8C5A) 替代重复的黄色
    ("./Sodium phosphide.xyz", "Sodium phosphide", "#FC8C5A"),  # 橙色
    ("./test-Interface.xyz", "Test-interface", "#FF983E"),  # 橙红色
    # 使用主题配色方案中的紫色 (#56285A) 替代重复的橙红色
    ("./test-Electrolyte.xyz", "Test-electrolyte", "#FFB8B8"),  # 粉红色
]
fit_data=[]
for info in config:
    atoms_list = ase_read(info[0],":", format="extxyz", do_not_split_by_at_sign=True)

    atoms_list_des = np.vstack([ get_descriptors(i, "nep.txt")   for i in atoms_list])
    fit_data.append(atoms_list_des)
reducer = PCA(n_components=2)
reducer.fit(np.vstack(fit_data))
fig = plt.figure()
ax = fig.add_subplot(111)  # 创建坐标轴对象
for index,array in enumerate(fit_data):
    proj = reducer.transform(array)
    plt.scatter(proj[:, 0], proj[:, 1], label=config[index][1], c=config[index][2])
ax.set_xlabel('PC-1')  # 设置X轴标签
ax.set_ylabel('PC-2')  # 设置Y轴标签
ax.set_title('PCA Projection of Data')  # 设置标题
#ax.legend(frameon=False)  # 显示图例

plt.savefig("./distribution.png", dpi=1200)
