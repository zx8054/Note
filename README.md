# Note - 移动应用开发大作业

### Note 是一款用于记录以及对记录进行管理的app，主要功能有笔记本与便笺，笔记本中的笔记支持图文混排，便笺用于快速记录事务。二者均可以通过OCR技术对图片中的文字（中文与英文）进行识别来添加内容。

***
## 工程
### 使用cocoapods对工程进行管理

### 工程所使用的第三方库

* SWRevealViewController (侧滑菜单): https://github.com/John-Lluch/SWRevealViewController
* Tesseract-OCR-iOS (OCR) : https://github.com/gali8/Tesseract-OCR-iOS

***
## 界面及功能介绍

###   主界面(便笺使用瀑布流排版)

* 笔记本用于记录一些具有共性的笔记，便笺用于记录临时性事务

![image3](https://github.com/zx8054/Note/blob/master/screenshot/1.png)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/2.png)

* 编辑界面(可进行删除以及移动,模仿系统app的删除移动)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/3.png)

![image4](https://github.com/zx8054/Note/blob/master/screenshot/4.png)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/5.png)

### 快速添加

* 选择界面

![image3](https://github.com/zx8054/Note/blob/master/screenshot/7.png)

* 便笺只能添加文字，且有文字限制，笔记本可以添加图片。二者均支持OCR

![image3](https://github.com/zx8054/Note/blob/master/screenshot/8.png)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/9.png)

### 搜索界面

* 搜索结果（高亮显示关键字)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/11.png)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/12.png)

* 显示完整搜索内容

![image3](https://github.com/zx8054/Note/blob/master/screenshot/13.png)

### 笔记本

* 添加笔记本(可自定义封面图)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/6.png)

* 主界面显示目录

![image3](https://github.com/zx8054/Note/blob/master/screenshot/14.png)

* 侧滑显示菜单，缩略图为文中的第一个图像，如果没有，则由系统默认设置一个缩略图

![image3](https://github.com/zx8054/Note/blob/master/screenshot/15.png)

* 对已存在内容进行实时编辑

![image3](https://github.com/zx8054/Note/blob/master/screenshot/17.png)

* 在笔记本中添加新笔记

![image3](https://github.com/zx8054/Note/blob/master/screenshot/10.png)

### 排序

* 根据需求进行排序

![image3](https://github.com/zx8054/Note/blob/master/screenshot/18.png)

![image3](https://github.com/zx8054/Note/blob/master/screenshot/19.png)

***
## 项目总结

### 总的来说，我个人认为这个app实用性并不高。因为其中大部分的代码用在实现界面的设计，一些动画的实现，以及数据的维护上(包括内存的数据以及core data的数据)，而且由于我的不熟练导致了部分代码的冗余。核心功能中比较有趣的OCR技术是使用的第三方库，本来想要实现的更为复杂的富文本格式的输入和存储，最后也仅仅是添加图片和文字的混排就草草了事。

### 当然，从项目开发过程来看，尝试新的东西(不管是自己写的还是引用第三方库)还是比较有趣的，但是为了应用的完整性，却又不得不写一些无趣的代码。




