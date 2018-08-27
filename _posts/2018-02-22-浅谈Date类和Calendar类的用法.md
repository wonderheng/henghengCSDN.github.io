---
layout: post
title: 浅谈Date类和Calendar类的用法
date: 2018-02-22
tag: javaSE学习心得 
---

### 1. 毫秒值概念 
* A: 毫秒值概念
	* a: 时间和日期类
		* `java.util.Date`
	* b: 毫秒概念
		* 1000毫秒=1秒
	* c: 毫秒的0点
		 * `System.currentTimeMillis()` 返回值long类型参数
		 * 获取当前日期的毫秒值   3742769374405    
		 * 时间原点; 公元1970年1月1日,午夜0:00:00 英国格林威治  毫秒值就是0
		 * 时间2088年8月8日    
		 * 时间和日期的计算，必须依赖毫秒值

### 2. Date类的构造方法
* A: Date类的构造方法
	* a: 空参构造
		* `public Date()`
	* b: 带参构造
		* `public Date(long times)`

### 3. Date类的get和set方法			
* A：Date类的get和set方法
	* public long getTime()	
		* 将当前的日期对象，转为对应的毫秒值
	* public void setTime(long times);
		* 根据给定的毫秒值，生成对应的日期对象

### 4. 日期格式化`SimpleDateFormat`
* a: 对日期进行格式化(自定义)
	* 对日期格式化的类 `java.text.DateFormat` 抽象类, 普通方法,也有抽象的方法
	* 实际使用是子类 `java.text.SimpleDateFormat` 可以使用父类普通方法,重写了抽象方法
* b: 对日期进行格式化的步骤
	* 1: 创建`SimpleDateFormat`对象
		* 在类构造方法中,写入字符串的日期格式 (自己定义)
	* 2: `SimpleDateFormat`调用方法`format`对日期进行格式化
		* `public String format(Date date)` 传递日期对象,返回字符串
		* 日期模式:
			* `yyyy`    年份
			* `MM`     月份
		* `dd`      月中的天数
		* `HH`       0-23小时
		* `mm`      小时中的分钟
		* `ss`      秒
		* `yyyy年MM月dd日 HH点mm分钟ss秒`  汉字修改,: -  字母表示的每个字段不可以随便写

### 5. 字符串转成日期对象
* 使用步骤
	* 1: 创建`SimpleDateFormat`的对象
		* 构造方法中,指定日期模式
	* 2: 子类对象,调用方法 `parse()` 传递String,返回Date
		* 注意: 时间和日期的模式yyyy-MM-dd, 必须和字符串中的时间日期匹配

### 6. Calendar类
* A: Calendar类_1
	* a: 日历类(抽象类)
		* `java.util.Calendar`
	* b: 创建对象
		* Calendar类写了静态方法 `getInstance()` 直接返回了子类的对象
		* 不需要直接new子类的对象,通过静态方法直接获取

* B: Calendar类_2
	* a: 成员方法
		* getTime() 把日历对象,转成Date日期对象
		* get(日历字段) 获取指定日历字段的值
	* b: 举个栗子

```java
Calendar c = Calendar.getInstance();
// 获取年份
int year = c.get(Calendar.YEAR);
// 获取月份
int month = c.get(Calendar.MONTH) + 1;
// 获取天数
int day = c.get(Calendar.DAY_OF_MONTH);
System.out.println(year + "年" + month + "月" + day + "日");
```		

* C: Calendar类_3
	* a: 成员方法
		* `set(int field,int value)`  设置指定的时间
	* b: 代码演示

```java
/*
 * Calendar类的set方法 设置日历 set(int field,int value) field 设置的是哪个日历字段 value
 * 设置后的具体数值
 * 
 * set(int year,int month,int day) 传递3个整数的年,月,日
 */
public static void function_1() {
	Calendar c = Calendar.getInstance();
	// 设置,月份,设置到10月分
	// c.set(Calendar.MONTH, 9);

	// 设置年,月,日
	c.set(2099, 4, 1);

	// 获取年份
	int year = c.get(Calendar.YEAR);
	// 获取月份
	int month = c.get(Calendar.MONTH) + 1;
	// 获取天数
	int day = c.get(Calendar.DAY_OF_MONTH);
	System.out.println(year + "年" + month + "月" + day + "日");
}
```

* D: Calendar类_4
	* a: 成员方法
		* `add(int field, int value)` 进行整数的偏移
		* `int get(int field)` 获取指定字段的值
	* b: 举个栗子

```java
/*
 * Calendar类方法add 日历的偏移量,
 * 可以指定一个日历中的字段,
 * 进行整数的偏移 add(int field, int value)
 */
public static void function_2() {
	Calendar c = Calendar.getInstance();
	// 让日历中的天数,向后偏移280天
	c.add(Calendar.DAY_OF_MONTH, -280);
	// 获取年份
	int year = c.get(Calendar.YEAR);
	// 获取月份
	int month = c.get(Calendar.MONTH) + 1;
	// 获取天数
	int day = c.get(Calendar.DAY_OF_MONTH);
	System.out.println(year + "年" + month + "月" + day + "日");
}
```

### 7. 日期练习--计算活了多少天

```java
/*
 *  计算活了多少天
 *   生日  今天的日期
 *   两个日期变成毫秒值,减法
 */
public static void function() throws Exception {
	System.out.println("请输入出生日期 格式 YYYY-MM-dd");
	//获取出生日期,键盘输入
	String birthdayString = new Scanner(System.in).next();
	//将字符串日期,转成Date对象
	//创建SimpleDateFormat对象,写日期模式
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	//调用方法parse,字符串转成日期对象
	Date birthdayDate = sdf.parse(birthdayString);
	
	//获取今天的日期对象
	Date todayDate = new Date();
	
	//将两个日期转成毫秒值,Date类的方法getTime
	long birthdaySecond = birthdayDate.getTime();
	long todaySecond = todayDate.getTime();
	long secone = todaySecond-birthdaySecond;
	
	if(secone < 0){
		System.out.println("还没出生呢");
	}
	else{
	System.out.println(secone/1000/60/60/24);
	}
	
}
```

### 18日期练习_闰年计算

```java
/*
 *  闰年计算
 *  2000 3000
 *  高级的算法: 日历设置到指定年份的3月1日,add向前偏移1天,获取天数,29闰年
 */
public static void function_1(){
	Calendar c = Calendar.getInstance();
	//将日历,设置到指定年的3月1日
	c.set(2088, 2, 1);
	//日历add方法,向前偏移1天
	c.add(Calendar.DAY_OF_MONTH, -1);
	//get方法获取天数
	int day = c.get(Calendar.DAY_OF_MONTH);
	System.out.println(day);
}
```

<br>

转载请注明原地址：[wonderheng的博客](http://www.wonderheng.top) » [点击阅读原文](http://www.wonderheng.top/2018/02/正则表达式+Date类和Calendar类的用法/),谢谢！