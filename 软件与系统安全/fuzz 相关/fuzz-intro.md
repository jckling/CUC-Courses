---
marp: true
---

# Fuzzing

---

## Taxonomy

* White-box
* Grey-box
* Black-box

黑盒/白盒 - 验证测试路径是否满足，代码覆盖率（符号执行）

---

## Categorization

* File Format
    * pdf, mp3, png, ...
* Network Protocol
    * HTTP, SSH, SMTP, ...
* Cloud
    * cloud environments
* Browser
    * html, js, ...
* Web
    * Protocol
* Kernel
    * API
* ......

---

## Method

* Mutation-based
    * 基于变异
    * Smart Fuzz
        * 面向逻辑
        * 面向数据类型
        * 基于样本

* Generation-based
    * 基于生成
    * Blind Fuzz
        * 盲测
        * 在随机位置插入随机数据以生成畸形文件

---

## File Format Fuzz

- [5.1 模糊测试](https://github.com/firmianay/CTF-All-In-One/blob/master/doc/5.1_fuzzing.md)

* 以文件作为程序的主要输入
    * 畸形文件，错误格式
* 异常检测（崩溃）
    * 记录日志、文件
    * 调试器
* 分析是否可利用
---

## 参阅

- [50 CVEs in 50 Days: Fuzzing Adobe Reader](https://research.checkpoint.com/50-adobe-cves-in-50-days/)
- [The Art, Science, and Engineering of Fuzzing: A Survey](https://arxiv.org/pdf/1812.00140.pdf)
- [一张图片让iPhone自动关机](https://xw.qq.com/partner/hwbrowser/20190531A0ML8T/20190531A0ML8T00?ADTAG=hwb&pgv_ref=hwb&appid=hwbrowser&ctype=news)
- [一张图片在微信中点开让苹果手机重启](https://bbs.pediy.com/thread-251582.htm)
- [一张图片在微信中点开让苹果手机重启 的简单分析](https://bbs.pediy.com/thread-251597.htm)
