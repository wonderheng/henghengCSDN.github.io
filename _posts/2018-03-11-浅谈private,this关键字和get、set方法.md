---
layout: post
title: 浅谈private、this关键字和get、set方法
date: 2018-03-11
tag: javaSE学习心得
---

### 1. private关键字
* A.private概述
	* private可以修饰成员内容包括成员方法和成员变量
	* 被private修饰的内容不能在其他类访问
* B.使用步骤
	* 1、通过private修饰属性
* C.完整代码
```java
class Person {
	private int age;
	private String name;

	public void show() {
		System.out.println("age=" + age + ",name" + name);
	}
}
```

### 2. get和set方法
* A.get和set方法
	* 年龄已被私有，错误的值无法赋值，可是正确的值也赋值不了，这样还是不行，那肿么办呢？按照之前所学习的封装的原理，隐藏后，还需要提供访问方式。只要对外提供可以访问的方法，让其他程序访问这些方法。同时在方法中可以对数据进行验证。一般对成员属性的访问动作：赋值(设置 set)，取值(获取 get)，因此对私有的变量访问的方式可以提供对应的 setXxx或者getXxx的方法。

```java
class Person {
	// 私有成员变量
	private int age;
	private String name;

	// 对外提供设置成员变量的方法
	public void setAge(int a) {
		// 由于是设置成员变量的值，这里可以加入数据的验证
		if (a < 0 || a > 130) {
			System.out.println(a + "不符合年龄的数据范围");
			return;
		}
		age = a; 
	}

	// 对外提供访问成员变量的方法
	public void getAge() {
		return age;
	}
}
```

* 总结
	* 类中不需要对外提供的内容都私有化，包括属性和方法。以后再描述事物，属性都私有化，并提供setXxx getXxx方法对其进行访问
* 注意
	* 私有仅仅是封装的体现形式而已

### 3. 私有化Person类带get,set
* 标准代码

```java
/*
 *   类描述人:
 *     属性: 姓名和年龄
 *     方法: 说话
 *   
 *   私有化所有的属性 (成员变量) ,必须写对应的get/set方法
 *   凡是自定义的类,自定义成员变量,应该私有化,提供get/set
 *   
 *   this关键字:
 *     区分成员变量和局部变量同名情况
 *     方法中,方位成员变量,写this.
 */
public class Person {
	private String name;
	private int age;

	// set方法,变量name,age赋值
	public void setAge(int age) {
		this.age = age;
	}

	public void setName(String name) {
		this.name = name;
	}

	// get方法,变量name,age获取值
	public int getAge() {
		return age;
	}

	public String getName() {
		return name;
	}

	public void speak() {
		String  name = "哈哈";
		int age = 16;
		
		System.out.println("人在说话  " + this.name + "..." + this.age);
	}
}
```

* 标准测试代码

```java
public class PersonTest {
	public static void main(String[] args) {
		Person p = new Person();
		//调用set方法,对成员变量赋值
		p.setAge(18);
		p.setName("旺财");
		p.speak();
		
		
		//调用get方法,获取成员变量的值
//		System.out.println(p.getName());
//		System.out.println(p.getAge());
	}
}
```

### 4. this关键字_区分成员变量和局部变量的同名
* A.什么时候用
	* 当类中存在成员变量和局部变量同名的时候为了区分，就需要使用this关键字
* B.代码

```java
class Person {
	private int age;
	private String name;
	
	public void speak() {
		this.name = "小强";
		this.age = 18;
		System.out.println("name=" + this.name + ",age=" + this.age);
	}
}

class PersonDemo {
	public static void main(String[] args) {
		Person p = new Person();
		p.speak();
	}
}
```

### 5. this的年龄比较
* A.需求：在Person类中定义功能，判断两个人是否是同龄人
* B.代码

```java
class Person {
	private int age;
	private String name;
	
	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void speak() {
		System.out.println("name=" + this.name + ",age=" + this.age);
	}

	// 判断是否为同龄人
	public boolean equalsAge(Person p) {
		// 使用当前调用该equalsAge方法对象的age和传递进来p的age进行比较
		// 由于无法确定具体是哪一个对象调用equalsAge方法，这里就可以使用this来代替
		/*
		 * if(this.age == p.age) { return true; } return false;
		 */
		return this.age == p.age;
	}
}
```

### 6. 举个栗子-随机点名器
* A.需求：随机点名器，即在全班同学中随机的找出一名同学，打印这名同学的个人信息
	它具备以下3个内容：
	存储所有同学姓名
	总览全班同学姓名
	随机点名其中一人，打印到控制台
* B.代码

```java
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

/*
 * 思路：
 * 第一步：存储全班同学信息
 * 第二步：打印全班同学每一个人的信息
 * 第三部：随机对学生点名，打印学生信息
 */
public class Test {
	public static void main(String[] args) {
		ArrayList<Student> list = new ArrayList<Student>(); //1.1创建一个可以存储多个同学名字的容器
		 //1.存储全班同学信息
		addStudent(list);
		 //2.打印全班同学每一个人的信息（姓名、年龄）
		printStudent(list);
		 //3.随机对学生点名，打印学生信息
		randomStudent(list);
	}
	public static void addStudent(ArrayList<Student> list) {
		//键盘输入多个同学名字存储到容器中
		Scanner sc = new Scanner(System.in);
		for (int i = 0; i < 3; i++) {
			//创建学生
			Student s = new Student();
			System.out.println("存储第"+i+"个学生姓名：");
			String name = sc.next();
			s.setName(name);
			System.out.println("存储第"+i+"个学生年龄：");
			int age = sc.nextInt();
			s.setAge(age);
			//添加学生到集合
			list.add(s);
		}
	}
	/*
	 * 2.打印全班同学每一个人的信息（姓名、年龄）
	 */
	public static void printStudent (ArrayList<Student> list) {
		for (int i = 0; i < list.size(); i++) {
			Student s = list.get(i);
			System.out.println("姓名："+s.getName() +",年龄："+s.getAge());
		}
	}
	/*
	 3.随机对学生点名，打印学生信息
	 */
	public static void randomStudent (ArrayList<Student> list) {
		//在班级总人数范围内，随机产生一个随机数
		int index = new Random().nextInt(list.size());
		//在容器（ArrayList集合）中，查找该随机数所对应的同学信息（姓名、年龄）
		Student s = list.get(index);
		System.out.println("被随机点名的同学："+s.getName() + "，年龄:" + s.getAge());
	}
}

/*
 * 学生信息类
 */
public class Student {
	private String name; // 姓名
	private int age; // 年龄

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}
}	
```


<br>

转载请注明原地址：[wonderheng的博客](http://www.wonderheng.top) » [点击阅读原文](http://www.wonderheng.top/2018/03/%E6%B5%85%E8%B0%88private,this%E5%85%B3%E9%94%AE%E5%AD%97%E5%92%8Cget-set%E6%96%B9%E6%B3%95/),谢谢！