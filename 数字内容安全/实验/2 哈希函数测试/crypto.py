#!/usr/bin/env python
# -*- coding: utf-8 -*-

import timeit
import hashlib
from PIL import Image
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes

# 读取图片
IMAGE_NAME = 'lena512.bmp'
f = open(IMAGE_NAME, 'rb')
img = Image.open(f)
t_bytes = img.tobytes(encoder_name='raw')

# 改变一个字节，再次进行哈希函数测试
t_bytes_arr = bytearray(t_bytes)
t_bytes_arr[0] += 1
t_bytes_changed = bytes(t_bytes_arr)
    
def hashlibSHA256(t_bytes):
    m = hashlib.sha256()
    m.update(t_bytes)
    return m.hexdigest()

def hashlibSHA512(t_bytes):
    m = hashlib.sha512()
    m.update(t_bytes)
    return m.hexdigest()

def hashlibMD5(t_bytes):
    m = hashlib.md5()
    m.update(t_bytes)
    return m.hexdigest()

def cryptoSHA256(t_bytes):
    digest = hashes.Hash(hashes.SHA256(), backend=default_backend())
    digest.update(t_bytes)
    m = digest.finalize()
    return m.hex()

def cryptoSHA512(t_bytes):
    digest = hashes.Hash(hashes.SHA512(), backend=default_backend())
    digest.update(t_bytes)
    m = digest.finalize()
    return m.hex()

def cryptoMD5(t_bytes):
    digest = hashes.Hash(hashes.MD5(), backend=default_backend())
    digest.update(t_bytes)
    m = digest.finalize()
    return m.hex()

def Digest(t_bytes):
    d1 = hashlibSHA256(t_bytes)
    d2 = hashlibSHA512(t_bytes)
    d3 = hashlibMD5(t_bytes)
    d4 = cryptoSHA256(t_bytes)
    d5 = cryptoSHA512(t_bytes)
    d6 = cryptoMD5(t_bytes)
    return [d1, d2, d3, d4, d5, d6]


if __name__ == '__main__':
    # 哈希函数运行时间测试
    number = 100
    t1 = timeit.timeit(stmt="crypto.hashlibSHA256(crypto.t_bytes)", setup='import crypto', number=number)
    t2 = timeit.timeit(stmt="crypto.hashlibSHA512(crypto.t_bytes)", setup='import crypto', number=number)
    t3 = timeit.timeit(stmt="crypto.hashlibSHA512(crypto.t_bytes)", setup='import crypto', number=number)
    t4 = timeit.timeit(stmt="crypto.cryptoSHA256(crypto.t_bytes)", setup='import crypto', number=number)
    t5 = timeit.timeit(stmt="crypto.cryptoSHA512(crypto.t_bytes)", setup='import crypto', number=number)
    t6 = timeit.timeit(stmt="crypto.cryptoSHA512(crypto.t_bytes)", setup='import crypto', number=number)

    t7 = timeit.timeit(stmt="crypto.hashlibSHA512(crypto.t_bytes_changed)", setup='import crypto', number=number)
    t8 = timeit.timeit(stmt="crypto.hashlibSHA512(crypto.t_bytes_changed)", setup='import crypto', number=number)
    t9 = timeit.timeit(stmt="crypto.hashlibSHA512(crypto.t_bytes_changed)", setup='import crypto', number=number)
    t10 = timeit.timeit(stmt="crypto.cryptoSHA256(crypto.t_bytes_changed)", setup='import crypto', number=number)
    t11 = timeit.timeit(stmt="crypto.cryptoSHA512(crypto.t_bytes_changed)", setup='import crypto', number=number)
    t12 = timeit.timeit(stmt="crypto.cryptoSHA512(crypto.t_bytes_changed)", setup='import crypto', number=number)

    test_time = [t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12]
    func_name = ['hashlib SHA256', 'hashlib SHA512', 'hashlib MD5', 'cryptography SHA256', 'cryptography SHA512', 'cryptography MD5']
    results_before = Digest(t_bytes)
    results_after = Digest(t_bytes_changed)
    results = results_before + results_after
    print('%-20s%-10s%s' % ('函数库-算法', '运行耗时（秒）', '十六进制哈希值'))

    for i in range(len(test_time)):
        if i%6 == 0 and i != 0:
            print('')
            print('将第1个字节的值进行加一改变后')
            print('')
        print('%-24s%-16f%s' % (func_name[i%len(func_name)], test_time[i], results[i]))

