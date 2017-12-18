---
layout: post
title: "Git教程"
date: 2017-12-6   
tag: 工具 
---

### 介绍       

　　Git是做项目的版本管理，你也可以称它们为版本管理工具。假如现在你有一个文件夹，里面可以是项目，也可以是你的个人笔记(如我这个博客)，或者是你的简历、毕业设计等等，都可以使用git来管理。

　　目前常用的版本控制器有Git和SVN，即使这两个你没有全用过，至少也会听过，我这里以Git为例，个人比较喜欢Git，你也可以看看这篇文章：[为什么Git比SVN好](http://www.worldhello.net/2012/04/12/why-git-is-better-than-svn.html)。我使用的是Mac，Mac上没自带Git环境，但是作为iOS开发者，我安装Xcode的时候，Xcode里是有自带Git的，所以我不需要考虑怎么去安装Git了。          

### 安装Git

**在Mac OS X上安装Git**      

提供两种方法参考：      

> 1、通过homebrew安装Git，具体方法请参考[homebrew的文档](http://brew.sh/)      
> 2、直接从AppStore安装Xcode，Xcode集成了Git，不过默认没有安装，你需要运行Xcode。     

**在Windows上安装Git**      

> 从[https://git-for-windows.github.io](https://git-for-windows.github.io) 下载，然后按默认选项安装即可，安装完成后，在开始菜单里找到“Git”->“Git Bash”，蹦出一个类似命令行窗口的东西，就说明Git安装成功！


### 配置Git      

安装完成后，还需要最后一步设置，在命令行输入：

>* $ git config --global user.name "Your Name"
>* $ git config --global user.email "email@example.com"

"Your Name"： 是每次提交时所显示的用户名，因为Git是分布式版本控制系统，当我们push到远端时，就需要区分每个提交记录具体是谁提交的，这个"Your Name"就是最好的区分。          

"email@example.com"： 是你远端仓库的email       

--global：用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然我们也可以对某个仓库指定不同的用户名和Email地址。         



### 开始使用-建立仓库：

你在目标文件夹下使命令：    

>* git init  （创建.git文件）      

就会创建一个 `.git` 隐藏文件，相当于已经建立了一个本地仓库。

**添加到暂存区：**      

>* git add .   （全部添加到暂存区）    
>* git commit -m "first commit"  （提交暂存区的记录到本地仓库）//双引号里面是注释，可随意写     
>* git push origin (branch name)   （将文件push到远程库）

### 其它   

git branch 查看时如出现

>*  (HEAD detached at analytics_v2)   
>*  dev
>*  master

代表现在已经进入一个临时的HEAD，可以使用 `git checkout -b temp` 创建一个 temp branch，这样临时HEAD上修改的东西就不会被丢掉了。
然后切换到 dev 分支上，在使用 git branch merge temp，就可以把 temp 分支上的代码合并到 dev 上了。

### 最后附一些 git常用的指令

**创建版本库**

>* git init     初始化本地版本库
>* git clone   克隆远程版本库

**修改和提交**

>* git status   			查看状态
>* git add .    			跟踪所有改动过的文件
>* git add <file>			跟踪指定文件
>* git mv <old> <new>		文件改名
>* git rm <file>			删除文件
>* git rm --cached <file>	停止跟踪但不删除
>* git commit -m “注释”		提交跟新过的文件
>* git commit --amend		修改最后一次提交

**查看提交历史**

>* git log					查看提交历史
>* git log -p <file>		查看指定文件的历史
>* git blame <file>			以列表方式查看指定文件的提交历史

**撤销**

>* git reset --hard HEAD	撤销工作目录所有的未提交文件的修改内容
>* git revert <commit>		撤销指定的提交

**分支与标签**

>* git branch  					显示所有的本地分支
>* git checkout <branch/tag>	切换指定的分支或标签
>* git branch <new branch>		创建新分支
>* git branch -D <branch>		删除新分支
>* git tag						列出所有本地标签
>* git tag <tagname>			基于最新提交创建标签
>* git tag -D <tag name >		删除标签

**合并**

>* git merge <branch>		合并指定分支到当前分支
>* git rebase <branch>		衍合指定分支到当前分支

**远程操作**

>* git remote -v					查看远程版本库的信息
>* git remote show <remote>	 		查看指定远程版本库的信息
>* git remote add <remote> <url>	添加远程版本库
>* git fatch <remote>				从远程库获取代码
>* git pull <remote> <branch>		下载代码及快速合并
>* git push <remote> <branch> 		上传代码及合并
>* git push <remote> :<branch/tag-name>		删除远程分支或标签
>* git push --tags							上传所有标签

<br>

转载请注明：[豌豆恒的博客](http://www.hengheng520.club)  