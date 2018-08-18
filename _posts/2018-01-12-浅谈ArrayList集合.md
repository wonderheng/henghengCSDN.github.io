---
layout: post
title: 浅谈ArrayList集合
date: 2018-01-12
tag: javaSE学习心得
---

### 1. ArrayList创建变量的步骤
* A: ArrayList创建变量的步骤
	* a: 导入包 java.util包中
	* b: 创建引用类型的变量
		数据类型< 集合存储的数据类型>  变量名 = new 数据类型<集合存储的数据类型>();
   		集合存储的数据类型: 要将数据存储到集合的容器中
   		创建集合引用变量的时候,必须要指定好,存储的类型是什么
	* c: 变量名.方法 
    	注意: 集合存储的数据,8个基本类型对应8个引用类型
 		存储引用类型,不存储基本类型
	
### 2. ArrayList创建变量栗子
* A: ArrayList创建变量的示例代码
```java
import java.util.ArrayList;
public class ArrayListDemo{
	public static void main(String[] args){
		//创建集合容器,指定存储的数据类型
		//存储字符串
		ArrayList<String> array = new ArrayList<String>();
		
		//创建集合容器,存储整数
		ArrayList<Integer> array2 = new ArrayList<Integer>();
		
		//创建集合容器,存储手机类型
		ArrayList<Phone> array3 = new ArrayList<Phone>();
	}
}
```

### 3. ArrayList的常见方法
* A: ArrayList的常见方法
	* a: add(参数) 向集合中添加元素
	* b: get(int index) 取出集合中的元素,get方法的参数,写入索引
	* c: size() 返回集合的长度, 集合存储元素的个数
* B: 栗子
```java
import java.util.ArrayList;
public class ArrayListDemo_1{
	public static void main(String[] args){
		//定义集合,存储字符串元素
		ArrayList<String> array = new ArrayList<String>();
		//调用集合方法add存储元素
		array.add("abc");
		array.add("itcast");
	    array.add("love");
		array.add("java");
		//输出集合的长度,调用集合方法size, size方法的返回值类型 int
		int size = array.size();
		System.out.println(size);
		
		//获取出集合中的一个元素,获取1索引的元素
		//集合的方法get, 获取元素后结果数据类型
		String s = array.get(1);
		System.out.println(s);
		
		
		System.out.println(array.get(0));
		System.out.println(array.get(1));
		System.out.println(array.get(2));
		System.out.println(array.get(3));
	}
}
```

### 4. ArrayList集合的遍历
* A: 举个栗子
```java
/*
   集合的遍历
   实现思想也是索引思想
   集合的索引从0开始,到 size()-1
   方法get(int index)
*/
import java.util.ArrayList;
public class ArrayListDemo_2{
	public static void main(String[] args){
		ArrayList<Integer> array = new ArrayList<Integer>();
		array.add(121);
		array.add(125);
		array.add(123);
		array.add(120);
		array.add(128);
		
		//对集合进行遍历
		//使用方法 size+get组合进行遍历
		for(int i = 0 ; i < array.size(); i++){
			System.out.println( array.get(i) );
		}
	}
}
```

### 5. ArrayList补充方法
* A: ArrayList补充方法
	* a: add(int 索引,存储的元素) 	将元素添加到指定的索引上
	* b: set(int 索引,修改后的元素) 	将指定索引的元素,进行修改
	* c: remove(int 索引) 			删除指定索引上的元素
	* d: clear() 					清空集合中的所有元素
* B: 举个栗子
```java
import java.util.ArrayList;
public class ArrayListDemo_3{
	public static void main(String[] args){
		
		ArrayList<Integer> array = new ArrayList<Integer>();
		array.add(1);
		array.add(2);
		array.add(3);
		array.add(4);
		
		//在索引2上,添加元素7
		array.add(2,7);
		
		//将0索引上的元素,修改成10
		array.set(0,10);
		
		//将4索引上的元素,删除
		array.remove(4);
		
		array.clear();
		
		//使用方法 size+get组合进行遍历
		for(int i = 0 ; i < array.size(); i++){
			System.out.println( array.get(i) );
		}
	}
}
```	 

### 6. 随机点名器案例分析
* A: 随机点名器案例分析
	* 全班同学中随机的找出一名同学，打印这名同学的个人信息。
		* 存储全班同学信息（姓名、年龄）
			将容器换成集合，集合中存的是Student类型
		* 打印全班同学每一个人的信息（姓名、年龄）
			 遍历集合
		* 在班级总人数范围内，随机产生一个随机数，查找该随机数所对应的同学信息（姓名、年龄）
		* 随机点名器明确地分为了三个功能。如果将多个独立功能的代码写到一起，则代码相对冗长，我们可以针对不同的功能可以将其封装到一个方法中，将完整独立的功能分离出来。
		* 而在存储同学姓名时，如果对每一个同学都定义一个变量进行姓名存储，则会出现过多孤立的变量，很难一次性将全部数据持有。此时，我们采用ArrayList集合来解决多个学生信息的存储问题

### 7. 随机点名器代码实现
* A: 随机点名器案例代码
```java
/*
   随机点名器,集合改进 (学生的姓名和年龄)
   现实中有学生这个事物,使用定义类的形式,描述学生事物
   属性: 姓名,年龄
   
   姓名存储了数组, 将容器换成是集合
   String[] s = {"",""};
   集合中,存储的是学生的姓名吗?  应该存储Student类型
   
   存储学生:
      学生类型,存储到集合中
   总览: 遍历集合
   随机: 随机数,作为索引,到集合中找到元素
   三个功能,共享的数据,集合容器,
   定义三个方法,必须参数传递集合
*/
import java.util.ArrayList;
import java.util.Random;
public class CallName{
	public static void main(String[] args){
		//定义集合,存储的是StudentName类型变量
		ArrayList <StudentName> array = new ArrayList<StudentName>();
		//调用添加方法
		add (array);
		//调用遍历集合
		printArrayList(array);
		
		randomStudentName(array);
	}
	/*
	  随机数,当作集合的索引,到集合中找到元素
	*/
	public static void randomStudentName(ArrayList<StudentName> array ){
		Random r = new Random();
		int number = r.nextInt( array.size());
		//随机数,索引,到集合中get
		StudentName s = array.get(number);
		System.out.println( s.name +"  "+s.age);
	}
	
	/*
	    总览学生的信息,遍历集合
	*/
	public static void printArrayList(ArrayList<StudentName> array){
		for(int i = 0 ; i < array.size();i++){
			//存储集合的时候, 集合.add(sn1)  sn1 是StudentName类型变量
			//获取的时候,集合.get方法,获取出来的是什么, 还是StudentName类型变量
			StudentName s = array.get(i);
			System.out.println(s.name+"  "+s.age);
		}
	}
	
	/*
	   定义方法,实现存储学生的姓名和年龄
	   创建StudentName类型变量,存储到集合中
	*/
	public static void add (ArrayList<StudentName> array){
		//创建StudentName类型变量
		StudentName sn1 = new StudentName();
		StudentName sn2 = new StudentName();
		StudentName sn3 = new StudentName();
		StudentName sn4 = new StudentName();
		StudentName sn5 = new StudentName();
		
		sn1.name = "张三1";
		sn1.age = 201;
		
		sn2.name = "张三2";
		sn2.age = 202;
		
		sn3.name = "张三3";
		sn3.age = 203;
		
		sn4.name = "张三4";
		sn4.age = 204;
		
		sn5.name = "张三5";
		sn5.age = 205;
		
		//将StudentName变量,存储到集合中
		array.add(sn1);
		array.add(sn2);
		array.add(sn3);
		array.add(sn4);
		array.add(sn5);
	}
}
```

### 8. 库存案例添加商品信息
* A: 栗子代码

```java
/*
   定义,.描述商品的类
   商品 4个属性
     商品名字  大小     价格    库存
	  String    double   double  int
	  
	定义类,类名Goods
	这个类型的变量,存储到集合中
*/
public class Goods{
	//定义商品名字
	String brand ;
	//大小属性
	double size ;
	// 价格属性
	double price ;
	//库存属性
	int count ;
}
```
<br>
```java
/*
    实现库存管理案例:
	  1.存储商品信息
	    存储商品类型变量
		将商品类型的变量,存储到集合中
*/
import java.util.*;
public class Shopp{
	public static void main(String[] args){
		//创建ArrayList集合,存储Goods类型
		ArrayList<Goods> array = new ArrayList<Goods>();
		//调用添加商品信息的方法
		addGoods(array);
	}
	
	/*
	   定义方法,将商品的信息存储到集合中
	   集合是所有方法的共享数据,参数传递
	*/
	public static void addGoods (ArrayList<Goods> array){
		//创建商品类型变量 Goods类型的变量
		Goods g1 = new Goods();
		Goods g2 = new Goods();
		g1.brand = "MacBook";
		g1.size = 13.3;
		g1.price = 9999.99;
		g1.count = 3;
		
		g2.brand = "Thinkpad";
		g2.size = 15.6;
		g2.price = 7999.99;
		g2.count = 1;
		
		//Goods类型的变量,存储到集合中
		array.add(g1);
		array.add(g2);
	}
}
```

### 9. 库存案例查看库存清单
* A: 栗子代码
```java
/*
    实现库存管理案例:
	  1.存储商品信息
	    存储商品类型变量
		将商品类型的变量,存储到集合中
		
      2.查看库存清单
	    将集合进行遍历, 获取出集合中存储的Goods类型变量
		输出每一个Goods类型的属性
		计算求和: 总库存,总金额
*/
//import java.util.ArrayList;
import java.util.*;
public class Shopp{
	public static void main(String[] args){
		//创建ArrayList集合,存储Goods类型
		ArrayList<Goods> array = new ArrayList<Goods>();
		//调用添加商品信息的方法
		addGoods(array);
	}

	/*
	   定义方法,查看库存清单,遍历集合
	*/
	public static void printStore(ArrayList<Goods> array){
		//输出表头
		System.out.println("----------商场库存清单----------");
		System.out.println("品牌型号     尺寸    价格    库存数");
		//定义变量,保存总库存数,和总金额
		int totalCount = 0 ;
		double totalMoney = 0;
		//遍历集合
		for(int i = 0 ; i < array.size(); i++){
			//get(索引)获取出集合中的元素,存储的是Goods类,获取的也是Goods类型
			//使用Goods类型变量,接受get方法结果
			Goods g = array.get(i);
			System.out.println(g.brand+"   "+g.size+"    "+g.price+"    "+g.count);
			totalCount = totalCount+g.count;
			totalMoney = totalMoney + g.count*g.price;
		}
		System.out.println("总库存数: "+totalCount);
		System.out.println("商品库存总金额: "+totalMoney);
	}
	
	/*
	   定义方法,将商品的信息存储到集合中
	   集合是所有方法的共享数据,参数传递
	*/
	public static void addGoods (ArrayList<Goods> array){
		//创建商品类型变量 Goods类型的变量
		Goods g1 = new Goods();
		Goods g2 = new Goods();
		g1.brand = "MacBook";
		g1.size = 13.3;
		g1.price = 9999.99;
		g1.count = 3;
		
		g2.brand = "Thinkpad";
		g2.size = 15.6;
		g2.price = 7999.99;
		g2.count = 1;
		
		//Goods类型的变量,存储到集合中
		array.add(g1);
		array.add(g2);
	}
}
```

### 10. 库存案例修改库存清单及测试代码的实现
* A: 栗子代码
```java
/*
    实现库存管理案例:
	  1.存储商品信息
	    存储商品类型变量
		将商品类型的变量,存储到集合中
		
      2.查看库存清单
	    将集合进行遍历, 获取出集合中存储的Goods类型变量
		输出每一个Goods类型的属性
		计算求和: 总库存,总金额
	
     3.修改商品的库存
	    集合遍历 ,获取出集合中存储的Goods类型变量
		变量调用Goods类的属性count,值进行修改 (键盘输入)
*/
//import java.util.ArrayList;
import java.util.*;
public class Shopp{
	public static void main(String[] args){
		//创建ArrayList集合,存储Goods类型
		ArrayList<Goods> array = new ArrayList<Goods>();
		//调用添加商品信息的方法
		addGoods(array);
		//进入死循环中
		while(true){
			//调用选择功能的方法,获取到用户输入的功能序号
			int number = chooseFunction();
			//对序号判断,如果=1 进入查看库存功能  = 2 进入修改库存功能  =3 结束
			switch(number){
				case 1:
				//进入查看库存,调用查看库存的方法,传递存储商品信息的集合
				printStore(array);
				break;
				
				case 2:
				//进入修改库存功能,调用修改库存的方法,传递集合
				update(array);
				break;
				
				case 3:
				return ;
				
				default:
				 System.out.println("无此功能");
				 break;
			}
		}
	}
	/*
	  方法定义,修改库存
	  键盘的输入,将Goods中的属性值,修改
	*/
	public static void update(ArrayList<Goods> array){
		Scanner sc = new Scanner(System.in);
		//遍历集合,获取集合中的每个元素
		for(int i = 0 ;  i < array.size(); i++){
			//集合方法get获取的是集合的元素,元素类型Goods
			Goods g = array.get(i);
			System.out.println("请输入"+g.brand+"的库存数");
			//Goods属性,count进行修改
			g.count = sc.nextInt();
		}
	}
	/*
	   定义方法,实现选择菜单,用户根据功能选择菜单
	*/
	public static int chooseFunction(){
		System.out.println("-------------库存管理------------");
		System.out.println("1.查看库存清单");
		System.out.println("2.修改商品库存数量");
		System.out.println("3.退出");
		System.out.println("请输入要执行的操作序号：");
		Scanner sc = new Scanner(System.in);
		int number = sc.nextInt();
		return number;
	}
	
	/*
	   定义方法,查看库存清单,遍历集合
	*/
	public static void printStore(ArrayList<Goods> array){
		//输出表头
		System.out.println("----------商场库存清单----------");
		System.out.println("品牌型号     尺寸    价格    库存数");
		//定义变量,保存总库存数,和总金额
		int totalCount = 0 ;
		double totalMoney = 0;
		//遍历集合
		for(int i = 0 ; i < array.size(); i++){
			//get(索引)获取出集合中的元素,存储的是Goods类,获取的也是Goods类型
			//使用Goods类型变量,接受get方法结果
			Goods g = array.get(i);
			System.out.println(g.brand+"   "+g.size+"    "+g.price+"    "+g.count);
			totalCount = totalCount+g.count;
			totalMoney = totalMoney + g.count*g.price;
		}
		System.out.println("总库存数: "+totalCount);
		System.out.println("商品库存总金额: "+totalMoney);
	}
	
	/*
	   定义方法,将商品的信息存储到集合中
	   集合是所有方法的共享数据,参数传递
	*/
	public static void addGoods (ArrayList<Goods> array){
		//创建商品类型变量 Goods类型的变量
		Goods g1 = new Goods();
		Goods g2 = new Goods();
		g1.brand = "MacBook";
		g1.size = 13.3;
		g1.price = 9999.99;
		g1.count = 3;
		
		g2.brand = "Thinkpad";
		g2.size = 15.6;
		g2.price = 7999.99;
		g2.count = 1;
		
		//Goods类型的变量,存储到集合中
		array.add(g1);
		array.add(g2);
	}
}
```

<br>

转载请注明原地址：[wonderheng的博客](http://www.wonderheng.top) » [点击阅读原文](https://www.wonderheng.top/2018/01/浅谈ArrayList集合/)谢谢！