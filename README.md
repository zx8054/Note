# Note - 移动应用开发大作业

### Note 是一款用于记录的app，主要功能有笔记本与便笺，笔记本中的笔记支持图文混排，便笺用于快速记录事务。二者均可以通过OCR技术对图片中的文字（中文与英文）进行识别来添加内容。

***
## 工程
### 使用cocoapods来对工程进行管理

### 工程所使用的第三方库

* SWRevealViewController (侧滑菜单): https://github.com/John-Lluch/SWRevealViewController
* Tesseract-OCR-iOS (OCR) : https://github.com/gali8/Tesseract-OCR-iOS

***
## 界面及功能介绍

###   主界面(便笺使用瀑布流排版)

* 笔记本用于记录一些具有共性的笔记，便笺用于记录临时性事务
<div align=center>
<img src="./screenshot/1.png" width="200" height="300" alt="笔记本界面"/>
<img src="./screenshot/2.png" width="200" height="300" alt="便笺界面"/></div>

* 编辑界面(可进行删除以及移动,模仿系统app的删除移动)
<div align=center>
<img src="./screenshot/3.png" width="200" height="300" alt="便笺编辑"/>
<img src="./screenshot/4.png" width="200" height="300" alt="自定义顺序"/>
<img src="./screenshot/5.png" width="200" height="300" alt="笔记本编辑"/></div>

### 快速添加

* 选择界面
<div align=center>
<img src="./screenshot/7.png" width="200" height="300" alt="笔记本编辑"/></div>

* 便笺只能添加文字，且有文字限制，笔记本可以添加图片。二者均支持OCR
<div align=center>
<img src="./screenshot/8.png" width="200" height="300" alt="笔记本编辑"/>
<img src="./screenshot/9.png" width="200" height="300" alt="笔记本编辑"/></div>

### 搜索界面

* 搜索结果（高亮显示关键字)
<div align=center>
<img src="./screenshot/11.png" width="200" height="300" alt="笔记本编辑"/>
<img src="./screenshot/12.png" width="200" height="300" alt="笔记本编辑"/></div>

* 显示完整搜索内容

<div align=center><img src="./screenshot/13.png" width="200" height="300" alt="笔记本编辑"/></div>

### 笔记本

* 添加笔记本(可自定义封面图)
<div align=center><img src="./screenshot/6.png" width="200" height="300" alt="笔记本编辑"/></div>

* 主界面显示目录
<div align=center><img src="./screenshot/14.png" width="200" height="300" alt="笔记本编辑"/></div>

* 侧滑显示菜单，缩略图为文中的第一个图像，如果没有，则由系统默认设置一个缩略图
<div align=center><img src="./screenshot/15.png" width="200" height="300" alt="笔记本编辑"/></div>

* 对已存在内容进行实时编辑
<div align=center><img src="./screenshot/17.png" width="200" height="300" alt="笔记本编辑"/></div>

* 在笔记本中添加新笔记

<div align=center><img src="./screenshot/10.png" width="200" height="300" alt="笔记本编辑"/></div>

### 排序

* 根据需求进行排序
<div align=center>
<img src="./screenshot/18.png" width="200" height="300" alt="笔记本编辑"/>
<img src="./screenshot/19.png" width="200" height="300" alt="笔记本编辑"/></div>




