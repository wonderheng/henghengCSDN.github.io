---
layout: post
title: 初识JavaScript
date: 2018-09-02
tag: JVM 
--- 

### 1. 为什么要使用JavaScript

* 在网页的发展历程中,发现网页不能对用户的数据进行自动校验,和提供一些特效，造成用户体验极差。
* 使用JavaScript：
  * 可以让网页和用户之间进行直接简单的交互。
  *  可以给网页制作特效和动画。

### 2. JavaScript的声明

* 在head标签中使用script声明js代码域

  ```javascript
  <head>
      ......
      <!--声明js代码域-->
      <script  type="text/javascript">
          function test(){
          	alert("哈哈,js学习起来很简单!!!");
      	}
  	</script>
  </head>
  ```

* 在head标签中使用script引入外部声明的js文件

  ```javascript
  <head>
      ......
      <!--引入外部声明好的js文件-->
      <script src="js/my.js" type="text/javascript" charset="utf-8"></script>
  </head>
  ```

### 3. JavaScript---变量

* js的变量声明

  * 使用var关键字进行变量声明,格式如下:

    * `var 变量名=初始值;`

  * 例如：

    ```javascript
    var a = "呵呵";
    ```

* js变量的特点

  * 变量声明只有var关键字，声明的变量可以存储任意类型的数据。
  * js中的代码可以不适用分号结尾，但是为了提升代码的阅读性，建议使用分号。
  * js中的变量允许出现同名变量，但是后面的会将前面的覆盖。
  * 声明不赋值，默认值是`undefined`。

* js的数据类型

  * 使用换件typeof判断变量的数据类型

    ```javascript
    var a;
    alert(typeof  a);
    ```

  * number:数值类型
  * string:字符类型,注意：在js中字符可以使用单引号也可以使用双引号
  * boolean:布尔类型
  * object:对象类型

* js的变量强转

  * 使用`Number()`函数：将其他数据类型转换为数值类型，转换失败返回`NaN`(not  a  number)。
  * 使用`Boolean()`函数：将其他数据类型转换为布尔类型，有值返回true，无值返回false;

* 特殊的值

  |     null      |    object     |
  | :-----------: | :-----------: |
  | **undefined** | **undefined** |
  |    **NaN**    |  **number**   |

* 举个栗子

  ```javascript
  <!--声明js代码域-->
  <script type="text/javascript">
  	//js的变量声明
  	var a=1;
  	var a1=2.2;
  	
  	var a3='哈哈';
  	
  	var a31='嘿嘿';
  	var a4=false;
  	var a5=new  Date();
  	//alert(a3);
  	
  	var b="hello java";
  	
  	var b="hello js";
  	//alert(b);
  	var c;
  	//alert(a3);
  	
  	//js的数据类型
  	//alert(typeof  a5);
  	
  	//js的变量强转              
  	var a=1;
  	var b="11";
  	
  	var c="哈哈";
  	var d;
  	alert(typeof  null);
  	alert(Boolean(d));
  	if(Boolean(a)){
  	
  	    alert("js学习");
  	}
  </script>
  ```

* 注意：

  * js中变量是没有类型的，但是数据是有类型的，在进行数据处理的时候要注意数据的类型。

### 4. js 的运算符和逻辑结构

* 作用：变量是存储要处理的数据的，运算符和逻辑结构就是用来处理数据的。

* 运算符

  |    类型    |      符号      |
  | :--------: | :------------: |
  | 算术运算符 |  `+,-,*,/,%`   |
  | 关系运算符 | `>,>=,<,<=,!=` |
  |   等值符   |      `==`      |
  |   等同符   |     `===`      |
  | 逻辑运算符 |   `&&,||,!`    |

* 逻辑结构

  * `if(条件一){...}else if(条件二){...} else{...}`
  * `switch(条件){}`
  * `for(){}`
  * `while(){}`
  * `do{}while()`

* 注：js中 判断条件可以直接是变量。

* 举个栗子

  * 打印九九乘法表

    ```javascript
    <script type="text/javascript">
        //九九乘法表
        for(var  i=1;i<=9;i++){
            for(var j=1;j<=i;j++){		       document.write(j+"*"+i+"="+i*j+"&nbsp;&nbsp;&nbsp;&nbsp;");
            }
            document.write("<br   />");
        }
    </script>
    ```

### 5. js的数组

* 问题：

  * 使用变量存储数据，如果数据量比较大的时候，会造成需要声明大量的变量去存储数据，代码整洁度及阅读性极差，数据的完整性得不到保证。
* 解决：

  * 引入数组
* js的数组的声明
  * `var arr1=new  Array();`//声明一个空数组
  * `var arr2=new  Array(长度)`//声明指定长度的数组。
  * `var arr3=[]`//声明一个空数组，也可以在声明时直接赋值
*  数组的赋值
  * `数组名[角标]=值;`
  * 注意：js中赋值可以跳跃角标赋值，不存在的角标也可以赋值，会对数组的大小进行改变。
*  数组的取值
  * `var 变量名=数组名[角标名]`
  * 注意：如果获取的角标没有数据，则返回`undefined`;

* js的数组的特点
  * js中的数组可以存储任意类型的数据。
  *  js的数组可以通过length属性动态的改变长度。可以增加，也可以缩短。
  * 注：
    * 如果是增加，则使用逗号进行占位
    * 如果是缩减则从后往前减少存储的数据。

* js的数组的遍历

  * 普通for循环
  * 增强for循环
  * 注意：增强for循环中，循环条件声明的变量记录的是角标。

* js的数组的常用操作方法

  *  数组名.pop()//移除并返回最后一个元素。
  * 数组名.push(要添加的数据)//在数组最后追加数据，并返回新的长度。

* 举个栗子

  ```javascript
  <script type="text/javascript">
      //创建数组
  
      //第一种方式
      var  arr1=new  Array();
  	
  	arr1[0]="哈哈";
  	
  	arr1[1]="嘿嘿";
  	//alert(typeof  arr1);              	 //alert(arr1.length);
  	
  	//第二种声明方式
  	var arr2=new  Array(5);
  	var arr4=new  Array([5,7,8]);
  	//alert(arr4);
  	
  	//第三种声明方式
  	var arr3=["a","b","c"];
  	//alert(arr3);
  	
  	//使用数组
  	var arr=[];
  	
  	//给数组的赋值
  	
  	arr[0]="张三";
  	
  	arr[1]="李四";
  	
  	arr[10]="王五";
  	//alert(arr)
  	
  	//获取数组中的数据
  	var a=arr[0];
  	var b=arr[100];
  	//alert(b);
  	
  	//数组的特点
  	
  	//可以存储任意类型的数据
  	var arr5=[1,"a",new   Date()];
  	//alert(arr5.length);
  	arr5.length=10;
  	//alert(arr5);
  	arr5.length=2;
  	//alert(arr5);
  	
  	//数组的遍历
  	var arr=[1,2,3,4,5];
  	
  	//第一种：普通for循环
  	//for(var i=0;i<arr.length;i++){
  	//    alert(arr[i]);            
  	//}
  	
  	//第二种：高级for
  	//for(var i  in arr){
  	//    alert(arr[i]);
  	//}
  	
  	//常用的操作方法:
  	var arr=["a","b","c","d"];
  	var str=arr.pop();
  	alert(str);
  	alert(arr);
  	
  	var str2=arr.push("哈哈");
  	alert(str2);
  	alert(arr);
  </script>
  ```

### 6. js 的函数

* 问题：

  * 其实开发就是对现实生活中的问题使用代码进行解决，同类型的问题非常多，这样就需要每次都将代码重新声明一遍，造成代码过于冗余。

* 解决：

  * 封装成函数，不用重复声明，调用即可。

* 函数的声明

  * `function  函数名(形参1,形参2,...){函数体....}`
  * `var 变量名=new Function("形参名1","形参名2",....,"函数体");`
  * `var 变量名=function()(形参1,形参2,...){函数体....}`

* 函数的形参

  * 在js中函数的形参在调用的时候可以不赋值，不报错，但是默认为undefined。
  * 在js中函数的形参在调用的时候可以不完全赋值，依次赋值。

* 函数的返回值

  * 在函数内部直接使用return语句返回即可，不需要返回值类型
  * 默认返回`undefined`;

*  函数的调用

  * 1、在加上代码域中直接调用(主要进行页面资源初始化)
  * 2、使用事件机制(主要实现和用户之间的互动)
  * 3、作为实参传递(主要是动态的调用函数)
  * **注：小括号为函数的执行符，函数名()才会被执行，直接函数名则作为对象使用。**

* 注：

  - 在js中函数是作为对象存在的。
  - js中没有函数重载，只有函数覆盖。
  - js的代码区域只有一个,包括引入的js代码，浏览器会将引入的js文件和内部声明的js代码解析成一个文件执行。
  -  js代码的调用和声明都在一个区域内。

* 举个栗子

  ```javascript
  <script type="text/javascript">
      //函数的声明
  
      //第一种声明方式
      function test1(a,b){
      	alert("我是第一种声明方式"+(a+b));
  	}
  
  	//调用
  	test1(1,2);
  	
  	//第二种声明方式
  	var test2=new  Function("a","b","alert(a+b);");
  	
  	test2("哈哈","嘿嘿");
  	
  	//第三种声明方式
  	var test3=function(a,b){
  	    alert("我是第三种声明方式"+a+b);
  	}
  	
  	var test3=function(a,b,c){
  	    alert("我是第三种声明方式"+a+b);
  	}
  	test3("6666","3333");
  	
  	//函数的形参
  	
  	//声明函数
  	function demo(a,b){
  	    alert("函数的形参学习"+a+b);
  	}
  	demo();
  	demo("哈哈");          
  	//函数的返回值
  	
  	//声明函数
  	function demo2(a,b){
  
  	}
  	
  	var str=demo2("js","的返回值");
  	alert(str);
  	
  	//函数的调用
  	
  	//声明函数
  	var demo3=function(a,b){
  	    alert("函数的调用")
  	}
  	
  	//1.js代码域中直接调用
  	demo3();
  	
  	//2.使用事件机制(可以根据用户在页面的不同操作来触发不同的函数执行)
  	
  	//3.作为实参传递
  	function demo4(a){
  	    a();
  	    alert(a);
  	}
  	demo4(demo3);
  </script>
  ```

### 7. js的事件机制

* 使用：
  * 事件是作为HTML标签的属性来使用的。
  * 一个HTML元素可以同时使用多个事件，但是注意事件之间的相互干扰。

* 常用事件

  | 事件类型     | 代码描述    |
  | ------------ | ----------- |
  | 单双击事件   | onclick     |
  | 双击事件     | ondblclick  |
  | 鼠标悬停事件 | onmouseover |
  | 鼠标移出事件 | onmouseout  |
  | 键盘下压事件 | onkeydown   |
  | 键盘弹起事件 | onkeyup     |
  | 获取焦点     | onfocus     |
  | 失去焦点     | onblur      |

* 特殊
  * 专门给select标签使用   =>   `onchange`  :   当下拉框的值改变时触发
  * 专门给body标签使用    =>   `onload` :  当页面加载成功后触发  

* 举个栗子

  ```html
  <html>
      <head>
  
          <title>js的事件机制学习</title>
          <meta charset="UTF-8"/>
          <script type="text/javascript">
  
              //单双击事件
  
              //创建函数
              function  testCilck(){
  
                  alert("我是单击");
              }
  
              function  testDbClick(){
  
                  alert("我是双击");
              }
  
              //鼠标移动事件
              function  testMouseOver(){
  
                  alert("我进来啦");
              }
              function  testMouseOut(){
  
                  alert("我出来啦");
              }
  
              //键盘事件
              function  testKeyDown(){
  
                  alert("我被按下啦");
              }
              function  testKeyUp(){
  
                  alert("我起来啦");
              }
  
              //焦点事件
              function  testFocus(){
  
                  alert("我获取焦点啦");
              }
              function  testBlur(){              alert("我失去焦点啦");
                                  }
  
              //值改变事件
              function  testChange(){
  
                  alert("我被改变啦");
              }
  
              //页面加载事件
              function  testLoad(){
  
                  alert("我加载成功啦");
              }
          </script>
  
          <!--声明css代码域-->
          <style type="text/css">
  
              #div01{
                  border: solid  1px;
                  width: 200px;
                  height: 200px;
                  background-color:  orange;
              }
          </style>
      </head>
      <body  onload="testLoad()">
  
          <h3>js的事件机制</h3>
          <hr />
  
          <input type="button"    value="测试单击"
                 onclick="testCilck()"/>
  
          <input type="button"    value="测试双击"
                 ondblclick="testDbClick()"   />
          <hr />
  
          <h4>鼠标事件:</h4>
          <div id="div01"  onmouseover="testMouseOver()"
               onmouseout="testMouseOut()">       </div>
          <hr />
  
          <h4>键盘事件：</h4>
  
          下压事件：<input      type="text"  name=""  id=""  value=""
                      onkeydown="testKeyDown()"/><br    />
  
          弹起事件：      <input type="text"  name=""  id=""  value=""
                            onkeyup="testKeyUp()"/>
  
          <h4>焦点事件:</h4>
  
          获取焦点:<input     type="text"   name="" id=""  value=""
                      onfocus="testFocus()"/><br   />
  
          失去焦点:     <input type="text"   name="" id=""  value=""
                           onblur="testBlur()"/>
  
          <h4>值改变事件</h4>
          <select name=""  id=""  onchange="testChange()">
  
              <option  value="">北京</option>
  
              <option  value="">上海</option>
  
              <option  value="">商丘</option>
          </select>
      </body>
  </html>
  ```

<br>

转载请注明原地址：[wonderheng的博客](http://www.wonderheng.top) » [点击阅读原文](http://www.wonderheng.top/2018/09/初识JavaScript/)，谢谢！