#!/usr/bin/env python
# -*- coding: utf-8 -*-

import cv2
import matplotlib.pyplot as plt
import numpy as np
import os

# 图像尺度调整
def imageresize(img, scale=1.1):
    height ,width = img.shape[:2]
    bigger = cv2.resize(img, dsize=(int(height*scale), int(width*scale)))
    smaller = cv2.resize(img, dsize=(int(height*(2-scale)), int(width*(2-scale))))
    return bigger, smaller

# 图像旋转
def imagerotate(img, angle=90):
    rows, cols = img.shape[:2]
    M = cv2.getRotationMatrix2D((cols / 2, rows / 2), angle, 1)
    dst = cv2.warpAffine(img, M, (cols, rows))
    return dst

# 图像平滑、模糊、高斯滤波、中值滤波
def imagesmooth(img, scale=5):
    kernel = np.ones((scale, scale), np.float32)/(scale**2)
    smooth = cv2.filter2D(img, -1, kernel)
    blur = cv2.blur(img, (scale, scale))
    gauss = cv2.GaussianBlur(img, (scale, scale), 0)
    median = cv2.medianBlur(img, scale)
    return smooth, blur, gauss, median

# 图像直方图均衡化
def imageequal(img):
    return cv2.equalizeHist(img)

# 保存图像
def imgdictory(img):
    bigger, smaller = imageresize(img)
    rotate, equal = imagerotate(img), imageequal(img)
    smooth, blur, gauss, median = imagesmooth(img)
    lst = [bigger, smaller, rotate, smooth, blur, gauss, median, equal]
    name = ['py_resize_1.1', 'py_resize_0.9', 'py_rotate_90', 'py_smooth', 'py_blur', 'py_gauss_filter', 'py_median_filter', 'py_equalization']
    for i,j in zip(lst,name):
        cv2.imwrite('images/'+j+'.bmp', i)
    return dict(zip(name, lst))

# 读取使用matlab处理过的图像
def matlab(path):
    images = os.listdir(path)
    lst, temp = [], []
    for image in images:
        lst.append(cv2.imread('images/'+image, 0))
    for i in images:
        temp.append(i.split('.bmp')[0])
    return dict(zip(temp, lst))

# 基于平均灰度值的感知哈希
def ahash(img):
    resized_img = cv2.resize(img, dsize=(8, 8))
    mean_img = cv2.mean(resized_img)[0]
    # mean = np.mean(gray_img)
    # diff_bool = (gray_img >= mean_img)
    # diff_num = diff_bool.astype(int)
    diff_bool = np.where(resized_img >= mean_img, 1, 0)
    value = hashstream(diff_bool)
    return value

# 基于平均DCT系数的感知哈希
def phash(img):
    resized_img = cv2.resize(img, dsize=(32, 32))
    f_img = np.float32(resized_img)
    dct_img = cv2.dct(f_img)
    collected_dct = dct_img[0:8, 0:8]
    mean_dct = cv2.mean(collected_dct)[0]
    diff_bool = np.where(collected_dct >= mean_dct, 1, 0)
    value = hashstream(diff_bool)
    return value

# 将结果拼接形成比01串
def hashstream(diff):
    return ''.join(str(i) for i in diff.flatten())

# 比较两个矩阵中有多少位是不同的（汉明距离）
def compare(hash1, hash2):
    n = 0
    for i,j in zip(hash1, hash2):
        if i != j:
            n += 1
    return n

# 计算矩阵汉明距离
def hamming(array1, array2):
    diff = np.uint8(array1 - array2)
    return cv2.countNonZero(diff)

# 打印感知哈希结果，并保存到文件中
def show(f, img_dic, seq, h='ahash'):
    dist = []
    if h in ['ahash', 'phash']:
        print('%-20s | %-68s| %-s' % ('image', h, 'hamming distance'), file=f)
        print('-' * 105, file=f)
        for key in seq:
            if h == 'ahash':
                a = ahash(img_dic[key])
                b = compare(a, ahash(img))
            elif h == 'phash':
                a = phash(img_dic[key])
                b = compare(a, phash(img))
            print('%-20s | %-68s| %-4d' % (key, a, b), file=f)
            dist.append(b)
    else:
        print('no such hash function', file=f)
    print('', file=f)
    return dist

# 显示两种感知哈希的折线图
def histogram(imgs, y_ahash, y_phash):
    x = range(len(imgs))
    plt.plot(x, y_ahash, label='ahash')
    plt.plot(x, y_phash, label='phash')
    plt.xticks(x, imgs, rotation=90)
    plt.xlabel('images')
    plt.ylabel('hamming distance')
    plt.title("ahash vs phash")
    for a, b in zip(x, y_ahash):
        plt.text(a, b, b, ha='center', va='bottom', fontsize=7, color='blue')
    for a, b in zip(x, y_phash):
        plt.text(a, b, b, ha='center', va='bottom', fontsize=7, color='orange')
    plt.legend()                # 显示图例
    plt.tight_layout()
    plt.savefig('result.jpg')   # 将折线图保存为图片
    plt.show()

# 测试
if __name__ == '__main__':
    img = cv2.imread('lena512.bmp', 0)          # 读取灰度图像
    # gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img_dic = imgdictory(img)                   # 获取经python处理过的图像列表
    img_dic = dict(img_dic, **matlab('images')) # 扩充图像列表，加入matlab处理过得图像
    seq = sorted(img_dic.keys())

    with open('output.txt', 'w+') as f:         # 将hash结果写入文件
        dis_ahash = show(f, img_dic, seq,'ahash')
        dis_phash = show(f, img_dic, seq,'phash')

    histogram(seq, dis_ahash, dis_phash)        # 绘制折线图