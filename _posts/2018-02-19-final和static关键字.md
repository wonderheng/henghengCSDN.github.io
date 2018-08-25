---
layout: post
title: final和static关键字
date: 2018-02-19
tag: javaSE学习心得 
---

### 1. final关键字概念
* A: 概述
	* 继承的出现提高了代码的复用性，并方便开发。但随之也有问题，有些类在描述完之后，不想被继承，或者有些类中的部分方法功能是固定的，不想让子类重写。可是当子类继承了这些特殊类之后，就可以对其中的方法进行重写，那怎么解决呢？要解决上述的这些问题，需要使用到一个关键字final，final的意思为最终，不可变。
	* final是个修饰符，它可以用来修饰类，类的成员，以及局部变量。

### 2. final 修饰类
* A: final 修饰类的特点
	* final修饰类不可以被继承，但是可以继承其他类。
* B: 案例

```java
class Yy {}
final class Fu extends Yy{} //可以继承Yy类
class Zi extends Fu{} //不能继承Fu类
```

### 3. final修饰方法
* A: final修饰方法的特点
	* final修饰的方法不可以被覆盖,但父类中没有被final修饰方法，子类覆盖后可以加final。
* B: 案例

```java
class Fu {
	// final修饰的方法，不可以被覆盖，但可以继承使用
	public final void method1(){}
	public void method2(){}
}
class Zi extends Fu {
	//重写method2方法
	public final void method2(){}
}
```

### 4. final修饰局部变量
* A:修饰基本数据类型变量
	* final修饰的变量称为常量，这些变量只能赋值一次

* B:举个栗子

```java
final int i = 20;
i = 30; //赋值报错，final修饰的变量只能赋值一次
```	

* C: 修饰引用数据类型
	* 引用类型的变量值为对象地址值，地址值不能更改，但是地址内的对象属性值可以修改

* D: 修饰引用数据类型
```java
final Person p = new Person();
Person p2 = new Person();
p = p2; //final修饰的变量p，所记录的地址值不能改变
p.name = "小明";//可以更改p对象中name属性值
//p不能为别的对象，而p对象中的name或age属性值可更改。
```

### 5. final修饰成员变量
* A: 修饰成员变量
	* 修饰成员变量，需要在创建对象前赋值，否则报错。(当没有显式赋值时，多个构造方法的均需要为其赋值。)

* B: 栗子
```java
class Demo {
	//直接赋值
	final int m = 100;
	
	//final修饰的成员变量，需要在创建对象前赋值，否则报错。
	final int n; 
	public Demo(){
		//可以在创建对象时所调用的构造方法中，为变量n赋值
		n = 2016;
	}
}
```

### 6. static的概念
* A：概念
	* 当在定义类的时候，类中都会有相应的属性和方法。而属性和方法都是通过创建本类对象调用的。
	* 当在调用对象的某个方法时，这个方法没有访问到对象的特有数据时，方法创建这个对象有些多余。
	* 可是不创建对象，方法又调用不了，这时我们可以通过static关键字来实现。static它是静态修饰符，一般用来修饰类中的成员。
	
### 7. static修饰的对象特有数据			
* A：特点:
	* 被static修饰的成员变量属于类，不属于这个类的某个对象。（也就是说，多个对象在访问或修改static修饰的成员变量时，其中一个对象将static成员变量值进行了修改，其他对象中的static成员变量值跟着改变，即多个对象共享同一个static成员变量）
* B: 代码演示
```java
class Demo {
	public static int num = 100;
}

class Test {
	public static void main(String[] args) {
		Demo d1 = new Demo();
		Demo d2 = new Demo();
		d1.num = 200;
		System.out.println(d1.num); //结果为200
		System.out.println(d2.num); //结果为200
	}
}
```

### 8. static的内存图
<div align="center">
	<img src="/images/posts/2018-02-19/1.JPG" height="300" width="600">  
</div>

	
### 9. static注意事项_静态不能直接调用非静态
* A: 注意事项	
	* 被static修饰的成员可以并且建议通过类名直接访问。
		
* B: 访问静态成员的格式：
	* 类名.静态成员变量名
	* 类名.静态成员方法名(参数)
	* 对象名.静态成员变量名    ------不建议使用该方式，会出现警告
	* 对象名.静态成员方法名(参数) 	------不建议使用该方式，会出现警告
		
* C: 代码演示
```java
class Demo {
	//静态成员变量
	public static int num = 100;
	//静态方法
	public static void method(){
		System.out.println("静态方法");
	}
}
class Test {
	public static void main(String[] args) {
		System.out.println(Demo.num);
		Demo.method();
	}
}
```	

### 10. static静态的使用场景
* A: 使用场景
	* static可以修饰成员变量和成员方法。	
	* 什么时候使用static修饰成员变量？
		* 加static修饰成员的时候，这个成员会被类的所有对象所共享。一般我们把共性数据定义为静态的变量
	* 什么时候使用static修饰成员方法？
		* 静态的方法只能访问静态的成员，如果静态方法中引用到了静态的其他成员，那么这个方法需要声明为静态的方法。

### 11. 对象中的静态调用
* A: 对象的静态调用
	* 在多态中，非静态编译看父类，运行看子类，父类没有编译失败。
	* 多态中的静态方法,编译看父类,运行仍然看父类。因为静态和对象没有关系，属于静态绑定。

* B: 举例
```java
public class Test{
	public static void main(String[] args){
		Fu f = new Zi();
		f.show();   //父类的引用和父类的方法绑定,和对象无关,不会在运行时动态的执行子类特有的方法。
	}
}
```

### 12. 定义静态常量
* A: 静态常量
	* 开发中，我们想在类中定义一个静态常量，通常使用`public static final`修饰的变量来完成定义。此时变量名用全部大写，多个单词使用下划线连接。
* B: 定义格式：
	`public static final 数据类型 变量名 = 值;`
	
* C: 如下演示：
```java
	class Company {
		public static final String COMPANY_NAME = "静态常量";
		public static void method(){
			System.out.println("一个静态方法");
		}
	}

	//当我们想使用类的静态成员时，不需要创建对象，直接使用类名来访问即可。
	System.out.println(Company.COMPANY_NAME); //打印
	Company.method(); // 调用一个静态方法
```

* D: 注意：
	* 接口中的每个成员变量都默认使用`public static final`修饰。
	* 所有接口中的成员变量已是静态常量，由于接口没有构造方法，所以必须显示赋值。可以直接用接口名访问。

```java
interface Inter {
	public static final int COUNT = 100;
}
	访问接口中的静态变量
Inter.COUNT
```		

<br>

转载请注明原地址：[wonderheng的博客](http://www.wonderheng.top) » [点击阅读原文](http://www.wonderheng.top/2018/02/final和static关键字+匿名对象等/),谢谢！