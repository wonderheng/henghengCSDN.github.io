---
layout: post
title: "浅谈集合 -- ArrayList 源码分析"
date: 2018-03-19   
tag: java
---

# ArrayList 简介
　　ArrayList 是一个数组队列，相当于 动态数组。与Java中的数组相比，它的容量能动态增长。它继承于AbstractList，实现了List, RandomAccess, Cloneable, java.io.Serializable这些接口。
ArrayList 继承了AbstractList，实现了List。它是一个数组队列，提供了相关的添加、删除、修改、遍历等功能。
ArrayList 实现了RandmoAccess接口，即提供了随机访问功能。RandmoAccess是java中用来被List实现，为List提供快速访问功能的。在ArrayList中，我们即可以通过元素的序号快速获取元素对象；这就是快速随机访问。稍后，我们会比较List的“快速随机访问”和“通过Iterator迭代器访问”的效率。
ArrayList 实现了Cloneable接口，即覆盖了函数clone()，能被克隆。ArrayList 实现java.io.Serializable接口，这意味着ArrayList支持序列化，能通过序列化去传输。

　　和Vector不同，ArrayList中的操作不是线程安全的！所以，建议在单线程中才使用ArrayList，而在多线程中可以选择Vector或者CopyOnWriteArrayList。
     
　　下面让我们翻开ArrayList的源代码，看看一些常用的方法属性，以及一些需要注意的地方

# ArrayList 源码
```
/** 
 * ArrayList
 * - 继承：抽象类 java.util.AbstractList<E> 
 * - 实现：java.util.List<E>，java.util.List<E>，java.util.List<E>，java.io.Serializable 
 * - 本类的实现中，大量调用了 System.arraycopy()  和 Arrays.copyOf() 方法 
 * 
 * 几个工具类：System、Arrays、Objects 
 * @author johnnie 
 * @time 2016年5月15日 
 * @param <E> 
 */
public class ArrayList<E>  extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable {  

1、ArrayList 的属性 

    /** 
     * 序列号 
     */  
    private static final long serialVersionUID = 8683452581122892189L;  
  
    /** 
     * 默认初始容量 
     */  
    private static final int DEFAULT_CAPACITY = 10;  
  
    /** 
     * 一个空数组 
     * - 当用户指定该 ArrayList 容量为 0 时，返回该空数组 
     * - ArrayList(int initialCapacity) 
     */  
    private static final Object[] EMPTY_ELEMENTDATA = {};  
  
    /** 
     * 一个空数组实例 
     * - 当用户没有指定 ArrayList 的容量时(即调用无参构造函数)，返回的是该数组==>刚创建一个 ArrayList 时，其内数据量为 0。 
     * - 当用户第一次添加元素时，该数组将会扩容，变成默认容量为 10(DEFAULT_CAPACITY) 的一个数组===>通过  ensureCapacityInternal() 实现 
     *  
     * 它与 EMPTY_ELEMENTDATA 的区别就是：该数组是默认返回的，而后者是在用户指定容量为 0 时返回 
     */  
    private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};  
  
    /** 
     * ArrayList基于数组实现，用该数组保存数据, ArrayList 的容量就是该数组的长度 
     * - 该值为 DEFAULTCAPACITY_EMPTY_ELEMENTDATA 时，当第一次添加元素进入 ArrayList 中时，数组将扩容值 DEFAULT_CAPACITY(10) 
     */  
    transient Object[] elementData; // non-private to simplify nested class access  
  
    /** 
     * ArrayList实际存储的数据数量 
     */  
    private int size;  
  
    /** 
     * 创建一个初试容量的、空的ArrayList 
     * - 可能报错： java.lang.OutOfMemoryError: Requested array size exceeds VM limit 
     * @param  initialCapacity  初始容量 
     * @throws IllegalArgumentException 当初试容量值非法(小于0)时抛出 
     */

2、ArrayList 的构造方法

    public ArrayList(int initialCapacity) {  
        if (initialCapacity > 0) {  
            this.elementData = new Object[initialCapacity];  
        } else if (initialCapacity == 0) {  
            // 数组缓冲区为 EMPTY_ELEMENTDATA，注意与 DEFAULTCAPACITY_EMPTY_ELEMENTDATA 的区别  
            this.elementData = EMPTY_ELEMENTDATA;  
        } else {  
            throw new IllegalArgumentException("Illegal Capacity: "+ initialCapacity);  
        }  
    }  
      
    /** 
     * 无参构造函数： 
     * - 创建一个 空的 ArrayList，此时其内数组缓冲区 elementData = {}, 长度为 0 
     * - 当元素第一次被加入时，扩容至默认容量 10 
     */  
    public ArrayList() {  
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;  
    }  
  
    /** 
     * Constructs a list containing the elements of the specified 
     * collection, in the order they are returned by the collection's 
     * iterator. 
     *  
     * 创建一个包含collection的ArrayList 
     * 
     * @param c 要放入 ArrayList 中的集合，其内元素将会全部添加到新建的 ArrayList 实例中 
     * @throws NullPointerException 当参数 c 为 null 时抛出异常 
     */  
    public ArrayList(Collection<? extends E> c) {  
        elementData = c.toArray();                      // 集合转 Object[] 数组  
        // 将转换后的 Object[] 长度赋值给当前 ArrayList 的 size，并判断是否为 0  
        if ((size = elementData.length) != 0) {  
            // c.toArray might (incorrectly) not return Object[] (see 6260652)  
            // 这句话意思是：c.toArray 可能不会返回 Object[]，可以查看 java 官方编号为 6260652 的 bug  
            if (elementData.getClass() != Object[].class)  
                // 若 c.toArray() 返回的数组类型不是 Object[]，则利用 Arrays.copyOf(); 来构造一个大小为 size 的 Object[] 数组  
                elementData = Arrays.copyOf(elementData, size, Object[].class);  
        } else {  
            // 换成空数组  
            this.elementData = EMPTY_ELEMENTDATA;  
        }  
    }

3、trimToSize 方法

    /** 
     * 将数组缓冲区大小调整到实际 ArrayList 存储元素的大小，即 elementData = Arrays.copyOf(elementData, size); 
     * - 该方法由用户手动调用，以减少空间资源浪费的目的 
     */  
    public void trimToSize() {  
        // modCount 是 AbstractList 的属性值：protected transient int modCount = 0;  
        // [问] modCount 有什么用？  
        modCount++;                               
        // 当实际大小 < 数组缓冲区大小时  
        // 如调用默认构造函数后，刚添加一个元素，此时 elementData.length = 10，而 size = 1  
        // 通过这一步，可以使得空间得到有效利用，而不会出现资源浪费的情况  
        if (size < elementData.length) {  
            // 注意这里：这里的执行顺序不是 (elementData = (size == 0) ) ? EMPTY_ELEMENTDATA : Arrays.copyOf(elementData, size);  
            // 而是：elementData = ((size == 0) ? EMPTY_ELEMENTDATA : Arrays.copyOf(elementData, size));  
            // 这里是运算符优先级的语法  
            // 调整数组缓冲区 elementData，变为实际存储大小 Arrays.copyOf(elementData, size)  
            elementData = (size == 0) ? EMPTY_ELEMENTDATA : Arrays.copyOf(elementData, size);  
        }  
    }  

4、ensureCapacity 方法

    /** 
     * 指定 ArrayList 的容量 
     * @param   minCapacity   指定的最小容量 
     */  
    public void ensureCapacity(int minCapacity) {  
        // 最小扩充容量，默认是 10  
        int minExpand = (elementData != DEFAULTCAPACITY_EMPTY_ELEMENTDATA) ? 0 : DEFAULT_CAPACITY;  
          
        // 若用户指定的最小容量 > 最小扩充容量，则以用户指定的为准，否则还是 10  
        if (minCapacity > minExpand) {  
            ensureExplicitCapacity(minCapacity);      
        }  
    }  

5、ensureCapacityInternal 方法（私有）

    /** 
     * 私有方法：明确 ArrarList 的容量，提供给本类使用的方法 
     * - 用于内部优化，保证空间资源不被浪费：尤其在 add() 方法添加时起效 
     * @param minCapacity    指定的最小容量 
     */  
    private void ensureCapacityInternal(int minCapacity) {  
        // 若 elementData == {}，则取 minCapacity 为 默认容量和参数 minCapacity 之间的最大值  
        // 注：ensureCapacity() 是提供给用户使用的方法，在 ArrayList 的实现中并没有使用  
        if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {  
            minCapacity = Math.max(DEFAULT_CAPACITY, minCapacity);  
        }  
  
        ensureExplicitCapacity(minCapacity);      
    }  

6、ensureExplicitCapacity 方法（私有）

    /** 
     * 私有方法：明确 ArrayList 的容量 
     * - 用于内部优化，保证空间资源不被浪费：尤其在 add() 方法添加时起效 
     * @param minCapacity    指定的最小容量 
     */  
    private void ensureExplicitCapacity(int minCapacity) {  
        // 将“修改统计数”+1，该变量主要是用来实现fail-fast机制的   
        modCount++;  
  
        // 防止溢出代码：确保指定的最小容量 > 数组缓冲区当前的长度  
        if (minCapacity - elementData.length > 0)  
            grow(minCapacity);  
    }  

    /** 
     * 数组缓冲区最大存储容量 
     * - 一些 VM 会在一个数组中存储某些数据--->为什么要减去 8 的原因 
     * - 尝试分配这个最大存储容量，可能会导致 OutOfMemoryError(当该值 > VM 的限制时) 
     */  
    private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;  

7、grow 方法（私有）

    /** 
     * 私有方法：扩容，以确保 ArrayList 至少能存储 minCapacity 个元素 
     * - 扩容计算：newCapacity = oldCapacity + (oldCapacity >> 1);  
     * @param minCapacity    指定的最小容量 
     */  
    private void grow(int minCapacity) {  
        // 防止溢出代码  
        int oldCapacity = elementData.length;  
        // 运算符 >> 是带符号右移. 如 oldCapacity = 10,则 newCapacity = 10 + (10 >> 1) = 10 + 5 = 15  
        int newCapacity = oldCapacity + (oldCapacity >> 1);     
        if (newCapacity - minCapacity < 0)     // 若 newCapacity 依旧小于 minCapacity  
            newCapacity = minCapacity;  
        if (newCapacity - MAX_ARRAY_SIZE > 0)    // 若 newCapacity 大于最大存储容量，则进行大容量分配  
            newCapacity = hugeCapacity(minCapacity);  
        // minCapacity is usually close to size, so this is a win:  
        elementData = Arrays.copyOf(elementData, newCapacity);  
    }  

8、hugeCapacity 方法（私有）

    /** 
     * 私有方法：大容量分配，最大分配 Integer.MAX_VALUE 
     * @param minCapacity 
     * @return 
     */  
    private static int hugeCapacity(int minCapacity) {  
        if (minCapacity < 0) // overflow  
            throw new OutOfMemoryError();  
        return (minCapacity > MAX_ARRAY_SIZE) ? Integer.MAX_VALUE : MAX_ARRAY_SIZE;  
    }  

9、size 方法

    /** 
     * 获取该 list 所实际存储的元素个数 
     * @return list 所实际存储的元素个数 
     */  
    public int size() {  
        return size;  
    }  

10、isEmpty 方法

    /** 
     * 判断 list 是否为空 
     * @return ture？空：非空 
     */  
    public boolean isEmpty() {  
        return size == 0;     // 直接看 size 是否为 0，没有先调用 size() 然后判断  
    }  

11、contains 方法

    /** 
     * 判断该 ArrayList 是否包含指定对象(Object 类型) 
     * - 面对抽象编程，向上转型是安全的 
     * @param o  
     * @return <tt>true</tt>？包含：不包含 
     */  
    public boolean contains(Object o) {  
        // 根据 indexOf() 的值(索引值)来判断，大于等于 0 就包含  
        // 注意：等于 0 的情况不能漏，因为索引号是从 0 开始计数的  
        return indexOf(o) >= 0;  
    }  

12、indexOf 方法

    /** 
     * 顺序查找，返回元素的最低索引值(最首先出现的索引位置) 
     * @return 存在？最低索引值：-1 
     */  
    public int indexOf(Object o) {  
        if (o == null) {    // 注意：元素为 null 并非表示这是非法操作。空值也可以作为元素放入 ArrayList  
            for (int i = 0; i < size; i++)   // 顺序查找数组缓冲区。注意：Arrays 工具类提供了二分搜索，但没有提供顺序查找  
                if (elementData[i]==null)  
                    return i;  
        } else {  
            for (int i = 0; i < size; i++)  
                if (o.equals(elementData[i]))  
                    return i;  
        }  
        return -1;  
    }  

13、lastIndexOf 方法

    /** 
     * 反向查找(从数组末尾向开始查找)，返回元素的最高索引值 
     * @return 存在？最高索引值：-1 
     */  
    public int lastIndexOf(Object o) {  
        if (o == null) {  
            for (int i = size-1; i >= 0; i--)     // 逆序查找  
                if (elementData[i]==null)  
                    return i;  
        } else {  
            for (int i = size-1; i >= 0; i--)  
                if (o.equals(elementData[i]))  
                    return i;  
        }  
        return -1;  
    }  

14、clone 方法

    /** 
     * 深度复制：对拷贝出来的 ArrayList 对象的操作，不会影响原来的 ArrayList 
     * @return 一个克隆的 ArrayList 实例(深度复制的结果) 
     */  
    public Object clone() {  
        try {  
            // Object 的克隆方法：会复制本对象及其内所有基本类型成员和 String 类型成员，但不会复制对象成员、引用对象  
            ArrayList<?> v = (ArrayList<?>) super.clone();  
            // 对需要进行复制的引用变量，进行独立的拷贝：将存储的元素移入新的 ArrayList 中  
            v.elementData = Arrays.copyOf(elementData, size);  
            v.modCount = 0;  
            return v;  
        } catch (CloneNotSupportedException e) {  
            throw new InternalError(e);  
        }  
    }  
      
15、toArray 方法

    /** 
     * 返回 ArrayList 的 Object 数组 
     * - 包含 ArrayList 的所有储存元素 
     * - 对返回的该数组进行操作，不会影响该 ArrayList（相当于分配了一个新的数组）==>该操作是安全的 
     * - 元素存储顺序与 ArrayList 中的一致 
     * @return  
     */  
    public Object[] toArray() {  
        return Arrays.copyOf(elementData, size);  
    }  

    /** 
     * 返回 ArrayList 元素组成的数组 
     * @param a 需要存储 list 中元素的数组 
     * 若 a.length >= list.size，则将 list 中的元素按顺序存入 a 中，然后 a[list.size] = null, a[list.size + 1] 及其后的元素依旧是 a 的元素 
     * 否则，将返回包含list 所有元素且数组长度等于 list 中元素个数的数组 
     * 注意：若 a 中本来存储有元素，则 a 会被 list 的元素覆盖，且 a[list.size] = null 
     * @return  
     * @throws ArrayStoreException 当 a.getClass() != list 中存储元素的类型时 
     * @throws NullPointerException 当 a 为 null 时 
     */  
    @SuppressWarnings("unchecked")  
    public <T> T[] toArray(T[] a) {  
        // 若数组a的大小 < ArrayList的元素个数,则新建一个T[]数组，数组大小是"ArrayList的元素个数",并将“ArrayList”全部拷贝到新数组中  
        if (a.length < size)  
            return (T[]) Arrays.copyOf(elementData, size, a.getClass());  
          
        // 若数组a的大小 >= ArrayList的元素个数,则将ArrayList的全部元素都拷贝到数组a中。  
        System.arraycopy(elementData, 0, a, 0, size);  
        if (a.length > size)  
            // a[list.size] = null  
            a[size] = null;  
        return a;  
    }  
  
16、elementData 方法
      
    /** 
     * 返回在索引为 index 的元素：数组的随机访问  
     * - 默认包访问权限 
     *  
     * 封装力度很强，连数组随机取值都封装为一个方法。 
     * 主要是避免每次取值都要强转===>设置值就没有封装成一个方法，因为设置值不需要强转 
     * @param index 
     * @return 
     */  
    @SuppressWarnings("unchecked")  
    E elementData(int index) {  
        return (E) elementData[index];  
    }  

17、get 方法

    /** 
     * 获取指定位置的元素：从 0 开始计数 
     * @param  index 元素索引 
     * @return 存储在 index 位置的元素 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     */  
    public E get(int index) {  
        rangeCheck(index);   // 检查是否越界  
  
        return elementData(index);   // 随机访问  
    }  

18、set 方法

    /** 
     * 设置 index 位置元素的值 
     * @param index 索引值 
     * @param element 需要存储在 index 位置的元素值 
     * @return 替换前在 index 位置的元素值 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     */  
    public E set(int index, E element) {  
        rangeCheck(index);    //  数组越界检查  
  
        E oldValue = elementData(index);    // 取出旧值  
        elementData[index] = element;     // 替换成新值  
        return oldValue;  
    }  

19、add 方法

    /** 
     * 添加新值到 list 末尾 
     * @param e 添加的值 
     * @return <tt>true</tt> 
     */  
    public boolean add(E e) {  
        // 确定ArrayList的容量大小---严谨  
        // 注意：size + 1，保证资源空间不被浪费，按当前情况，保证要存多少个元素，就只分配多少空间资源  
        ensureCapacityInternal(size + 1);  // Increments modCount!!  
        // 添加 e 到 ArrayList 中，然后 size 自增 1  
        elementData[size++] = e;  
        return true;  
    }  
  
    /** 
     * 插入方法，其实应该命名为 insert() 比较合理 
     * - 在指定位置插入新元素，原先在 index 位置的值往后移动一位 
     * @param 要插入的位置 
     * @param 要插入的元素 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     */  
    public void add(int index, E element) {  
        rangeCheckForAdd(index);  
  
        ensureCapacityInternal(size + 1);  // Increments modCount!!  
        System.arraycopy(elementData, index, elementData, index + 1,  
                         size - index);  
        elementData[index] = element;  
        size++;  
    }  

20、remove 方法	

    /** 
     * 移除指定索引位置的元素：index 之后的所有元素依次左移一位 
     * @param index  
     * @return 被移出的元素 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     */  
    public E remove(int index) {  
        rangeCheck(index); // 越界检查  
  
        modCount++;  
        E oldValue = elementData(index); // 旧值  
  
        int numMoved = size - index - 1; // 需要左移的元素个数  
        if (numMoved > 0)  
            // 左移：利用 System.arraycopy() 进行左移一位的操作  
            // 将 elementData（源数组）从下标为 index+1 开始的元素，拷贝到 elementData（目标数组）下标为 index 的位置，总共拷贝 numMoved 个  
            System.arraycopy(elementData, index+1, elementData, index, numMoved);  
        elementData[--size] = null; // 将最后一个元素置空  
  
        return oldValue;  
    }  
  
    /** 
     * 删除 ArrayList 中的一个指定元素（符合条件的索引最低） 
     * - 只会删除一个 
     * - 删除的那个元素，是符合条件的结果中索引号最低的那个 
     * - 若不包含要删除的元素，则返回 false 
     *  
     * 相比 remove(index)：该方法并没有进行越界检查，即调用 rangeCheck()  
     *  
     * @param o 要删除的元素 
     * @return <tt>true</tt> ? ArrayList中包含该元素，删除成功：不包含该元素，删除失败 
     */  
    public boolean remove(Object o) {  
        if (o == null) {  
            for (int index = 0; index < size; index++)  
                if (elementData[index] == null) {     // 判断是否存储了 null   
                    fastRemove(index);  
                    return true;  
                }  
        } else {  
             // 遍历ArrayList，找到“元素o”，则删除，并返回true  
            for (int index = 0; index < size; index++)  
                if (o.equals(elementData[index])) {     // 利用 equals 判断两对象值是否相等（equals 比较值，== 比较引用）  
                    fastRemove(index);  
                    return true;  
                }  
        }  
          
        return false;  
    }  

21、fastRemove 方法（私有）

    /* 
     * 私有方法：快速删除第 index 个元素 
     * - 该方法会跳过越界检查 
     */  
    private void fastRemove(int index) {  
        modCount++;  
        int numMoved = size - index - 1;  
        // 左移操作  
        if (numMoved > 0)  
            System.arraycopy(elementData, index+1, elementData, index,  
                             numMoved);  
          
        elementData[--size] = null;   //  将最后一个元素设为null  
    }  

22、clear 方法

    /** 
     * 清空所有存储元素 
     * - 它会将数组缓冲区所以元素置为 null 
     * - 清空后，我们直接打印 list，却只会看见一个 [], 而不是 [null, null, ....] ==> toString() 和 迭代器进行了处理 
     */  
    public void clear() {  
        modCount++;  
  
        // clear to let GC do its work  
        for (int i = 0; i < size; i++)  
            elementData[i] = null;  
  
        size = 0;  
    }  

23、addAll 方法	

    /**  
     * 将一个集合的所有元素顺序添加（追加）到 lits 末尾 
     * - ArrayList 是线程不安全的。 
     * - 该方法没有加锁，当一个线程正在将 c 中的元素加入 list 中，但同时有另一个线程在更改 c 中的元素，可能会有问题 
     * @param c collection containing elements to be added to this list 
     * @return <tt>true</tt> ？ list 元素个数有改变时，成功：失败 
     * @throws NullPointerException 当 c 为 null 时 
     */  
    public boolean addAll(Collection<? extends E> c) {  
        Object[] a = c.toArray();   // 若 c 为 null，此行将抛出空指针异常  
        int numNew = a.length;    // 要添加的元素个数  
        ensureCapacityInternal(size + numNew);  // 扩容，Increments modCount  
        System.arraycopy(a, 0, elementData, size, numNew);  // 添加  
        size += numNew;  
          
        return numNew != 0;  
    }  
  
    /** 
     * 从 index 位置开始，将集合 c 中的元素添加到ArrayList 
     * - 并不会覆盖掉在 index 位置原有的值 
     * - 类似于 insert 操作，在 index 处插入 c.length 个元素（原来在此处的 n 个元素依次右移） 
     * @param index 插入位置 
     * @param c  
     * @return <tt>true</tt> ？ list 元素个数有改变时，成功：失败 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     * @throws NullPointerException 当 c 为 null 时 
     */  
    public boolean addAll(int index, Collection<? extends E> c) {  
        rangeCheckForAdd(index);   // 越界检查  
  
        Object[] a = c.toArray();   // 空指针异常抛出点  
        int numNew = a.length;  
        ensureCapacityInternal(size + numNew);  // 扩容，Increments modCount  
  
        int numMoved = size - index;    // 要移动的元素个数  
        /*  
         * 先元素移动，在拷贝，以免被覆盖 
         */  
        if (numMoved > 0)                                      
            System.arraycopy(elementData, index, elementData, index + numNew,  
                             numMoved);  
  
        System.arraycopy(a, 0, elementData, index, numNew);  
        size += numNew;  
        return numNew != 0;  
    }  

24、removeRange 方法（受保护）
	
    /** 
     * Removes from this list all of the elements whose index is between 
     * {@code fromIndex}, inclusive, and {@code toIndex}, exclusive. 
     * Shifts any succeeding elements to the left (reduces their index). 
     * This call shortens the list by {@code (toIndex - fromIndex)} elements. 
     * (If {@code toIndex==fromIndex}, this operation has no effect.) 
     *  
     * 删除fromIndex到toIndex之间的全部元素 
     *  
     * @throws IndexOutOfBoundsException if {@code fromIndex} or 
     *         {@code toIndex} is out of range 
     *         ({@code fromIndex < 0 || 
     *          fromIndex >= size() || 
     *          toIndex > size() || 
     *          toIndex < fromIndex}) 
     */  
    protected void removeRange(int fromIndex, int toIndex) {  
        modCount++;  
        int numMoved = size - toIndex;  
        /* 
         * 利用 System.arraycopy() 进行元素拷贝，再让失去价值的元素置为 null 
         */  
        System.arraycopy(elementData, toIndex, elementData, fromIndex,  
                         numMoved);  
  
        // clear to let GC do its work  
        int newSize = size - (toIndex-fromIndex);  // 删除后，list 的长度  
        for (int i = newSize; i < size; i++) {    // 清除失去价值的元素  
            elementData[i] = null;  
        }  
        size = newSize;  
    }  

25、rangeCheck 方法（私有）

    /** 
     *  
     * - 提供给 get()、remove() 等方法：检查给出的索引值 index 是否越界(大于或等于 list.size) 
     * 注：该方法并没有检查 index 是否合法（如小于 0，这个是由数组类型自己检查的） 
     */  
    private void rangeCheck(int index) {  
        if (index >= size)  
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));  
    }  

26、rangeCheckForAdd 方法（私有）

    /** 
     * 提供给 add() 和 add() 进行数组越界检查的方法 
     */  
    private void rangeCheckForAdd(int index) {  
        if (index > size || index < 0)  
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));  
    }  

27、outOfBoundsMsg 方法（私有）

    /** 
     * 返回异常消息，用于传给 IndexOutOfBoundsException 
     */  
    private String outOfBoundsMsg(int index) {  
        return "Index: "+index+", Size: "+size;  
    }  

28、removeAll 方法

    /** 
     * 移除 list 中和 c 中共有的元素 
     * - 若实例化 Collection 的类不是 ArrayList，则删除肯定失败 
     *  
     * @param c  
     * @return true ？ 若 c 和 list 有公有元素，删除成功(或list元素个数有改变) ： 没有公有元素，删除失败 
     * @throws ClassCastException 
     * @throws NullPointerException 若 c 为 null 时 
     * @see Collection#contains(Object) 
     */  
    public boolean removeAll(Collection<?> c) {  
        Objects.requireNonNull(c);   // 当 c == null，则改行抛出空指针异常  
        return batchRemove(c, false);  
    }  

29、retainAll 方法

    /** 
     * 只保留 list 和 集合 c 中公有的元素：和 removeAll() 功能相反 
     * @param c  
     * @return true ？ list 元素个数有改变 
     * @throws ClassCastException  
     * @throws NullPointerException  
     * @see Collection#contains(Object) 
     */  
    public boolean retainAll(Collection<?> c) {  
        Objects.requireNonNull(c);  
        return batchRemove(c, true);  
    }  

30、batchRemove 方法（私有）
	
    /** 
     * 批量删除 
     * @param c 
     * @param complement 是否取补集 
     * @return 
     */  
    private boolean batchRemove(Collection<?> c, boolean complement) {  
        final Object[] elementData = this.elementData;  
        int r = 0, w = 0;  
        boolean modified = false;  
        try {  
            for (; r < size; r++)  
                if (c.contains(elementData[r]) == complement)  
                    elementData[w++] = elementData[r];  
        } finally {  
            // Preserve behavioral compatibility with AbstractCollection,  
            // even if c.contains() throws.  
            if (r != size) {  
                System.arraycopy(elementData, r,  
                                 elementData, w,  
                                 size - r);  
                w += size - r;  
            }  
            if (w != size) {  
                // clear to let GC do its work  
                for (int i = w; i < size; i++)  
                    elementData[i] = null;  
                modCount += size - w;  
                size = w;  
                modified = true;  
            }  
        }  
        return modified;  
    }  

31、writeObject 方法（私有）

    /** 
     * 序列化函数 
     * @serialData  
     */  
    private void writeObject(ObjectOutputStream s) throws IOException{  
        int expectedModCount = modCount;  
        s.defaultWriteObject();  
  
        // 写入ArrayList大小   
        s.writeInt(size);  
  
        // 写入存储的元素  
        for (int i=0; i<size; i++) {  
            s.writeObject(elementData[i]);  
        }  
  
        if (modCount != expectedModCount) {  
            throw new ConcurrentModificationException();  
        }  
    }  

32、readObject 方法（私有）
	
    /** 
     * 先将ArrayList的“容量”读出，然后将“所有的元素值”读出 
     */  
    private void readObject(java.io.ObjectInputStream s)  
        throws java.io.IOException, ClassNotFoundException {  
        elementData = EMPTY_ELEMENTDATA;  
  
        // Read in size, and any hidden stuff  
        s.defaultReadObject();  
  
        // 从输入流中读取ArrayList的size   
        s.readInt(); // ignored  
  
        if (size > 0) {  
            ensureCapacityInternal(size);  
  
            Object[] a = elementData;  
            // 从输入流中将“所有的元素值”读出  
            for (int i=0; i<size; i++) {  
                a[i] = s.readObject();  
            }  
        }  
    }  

33、listIterator 方法

    /** 
     * 返回一个 ListIterator 
     * @index 元素的索引位置 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     */  
    public ListIterator<E> listIterator(int index) {  
        if (index < 0 || index > size)  
            throw new IndexOutOfBoundsException("Index: "+index);  
        return new ListItr(index);  
    }  
  
    /** 
     * 返回一个 ListIterator 迭代器，该迭代器是 fail-fast 机制的 
     */  
    public ListIterator<E> listIterator() {  
        return new ListItr(0);  
    }  

34、iterator 方法	

    /** 
     * 返回一个 Iterator 迭代器，该迭代器是 fail-fast 机制的 
     * @return 
     */  
    public Iterator<E> iterator() {  
        return new Itr();  
    }  

/*------------------------------------- 内部类 Itr -------------------------------------------*/ 

    /** 
     * AbstractList.Itr 的优化版本 
     */  
    private class Itr implements Iterator<E> {  
        int cursor;     // 下一个返回元素的索引，默认值为 0  
        int lastRet = -1;    // 上一个返回元素的索引，若没有上一个元素，则为 -1。每次调用 remove()，lastRet 都会重置为 -1  
        int expectedModCount = modCount;  
  
        public boolean hasNext() {  
            return cursor != size;  // 是否有下一元素的判断  
        }  
  
        @SuppressWarnings("unchecked")  
        public E next() {  
            checkForComodification();  
            // 临时变量 i，指向游标当前位置。  
            // 此处并没有让 lastRet 直接等于 cursor 进行操作  
            int i = cursor;                                                               
            if (i >= size)    //  第一次检查  
                throw new NoSuchElementException();  
            Object[] elementData = ArrayList.this.elementData;  
            if (i >= elementData.length)       // 第二次检查  
                throw new ConcurrentModificationException();  
            cursor = i + 1;  
            return (E) elementData[lastRet = i];     // 注意这里的取值  
        }  
  
        public void remove() {  
            if (lastRet < 0)  
                throw new IllegalStateException();  
            checkForComodification();  
  
            try {  
                ArrayList.this.remove(lastRet);   // 移除元素  
                cursor = lastRet;    // 指针回移  
                // 注意此处：上一元素指针直接重置为 -1。因此 lastRet 不一定就等于 cursour - 1  
                lastRet = -1;                                                                 
                expectedModCount = modCount;  
            } catch (IndexOutOfBoundsException ex) {  
                throw new ConcurrentModificationException();  
            }  
        }  
  
        /** 
         * jdk1.8 使用，进行函数式编程 
         * 注：Consumer 是 1.8 开始有的。Since:1.8 
         * @param consumer 动作，让集合每一个元素都执行该动作 
         */  
        @Override  
        @SuppressWarnings("unchecked")  
        public void forEachRemaining(Consumer<? super E> consumer) {  
            Objects.requireNonNull(consumer);    // 非空判断  
            final int size = ArrayList.this.size;  
            int i = cursor;  
            if (i >= size) {  
                return;  
            }  
            final Object[] elementData = ArrayList.this.elementData;  
            if (i >= elementData.length) {  
                throw new ConcurrentModificationException();  
            }  
            while (i != size && modCount == expectedModCount) {  
                consumer.accept((E) elementData[i++]);  
            }  
            // update once at end of iteration to reduce heap write traffic  
            cursor = i;  
            lastRet = i - 1;  
            checkForComodification();  
        }  
  
        final void checkForComodification() {  
            if (modCount != expectedModCount)  
                throw new ConcurrentModificationException();  
        }  
    }
	
/*---------------------------------------- Itr 结束 ---------------------------------------------*/  


/*-------------------------------------内部类 ListItr -------------------------------------------*/ 

    /** 
     * AbstractList.ListItr 的优化版本 
     * ListIterator 与普通的 Iterator 的区别： 
     * - 它可以进行双向移动，而普通的迭代器只能单向移动 
     * - 它可以添加元素(有 add() 方法)，而后者不行 
     */  
    private class ListItr extends Itr implements ListIterator<E> {  
        ListItr(int index) {  
            super();  
            cursor = index;   // cursor 还是指向下一个返回元素的索引位置  
        }  
          
        /** 
         * 是否有上一个元素 
         * @return true ？ 有：无 
         */  
        public boolean hasPrevious() {                        
            return cursor != 0;  
        }  
  
        /** 
         * 获取下一个元素的索引 
         */  
        public int nextIndex() {  
            return cursor;  
        }  
  
        /** 
         * 获取 cursor 前一个元素的索引 
         * - 是 cursor 前一个，而不是当前元素前一个的索引。 
         * - 若调用 next() 后马上调用该方法，则返回的是当前元素的索引。 
         * - 若调用 next() 后想获取当前元素前一个元素的索引，需要连续调用两次该方法。 
         */  
        public int previousIndex() {  
            return cursor - 1;  
        }  
  
        /** 
         * 返回 cursor 前一元素 
         *注意事项同 previousIndex 
         */  
        @SuppressWarnings("unchecked")  
        public E previous() {  
            checkForComodification();  
            int i = cursor - 1;  
            if (i < 0)  
                throw new NoSuchElementException();  
            Object[] elementData = ArrayList.this.elementData;  
            if (i >= elementData.length)  
                throw new ConcurrentModificationException();  
            cursor = i;  
            return (E) elementData[lastRet = i];  
        }  
  
        public void set(E e) {  
            if (lastRet < 0)  
                throw new IllegalStateException();  
            checkForComodification();  
  
            try {  
                ArrayList.this.set(lastRet, e);  
            } catch (IndexOutOfBoundsException ex) {  
                throw new ConcurrentModificationException();  
            }  
        }  
          
        /** 
         * 添加元素：在游标当前指向的索引位置插入一个元素 
         */  
        public void add(E e) {  
            checkForComodification();  
  
            try {  
                int i = cursor;  
                ArrayList.this.add(i, e);  
                cursor = i + 1;  
                lastRet = -1;  
                expectedModCount = modCount;  
            } catch (IndexOutOfBoundsException ex) {  
                throw new ConcurrentModificationException();  
            }  
        }  
    }

/*------------------------------------- ListItr 结束 -------------------------------------------*/  

35、subList 方法

    /** 
     * 获取从 fromIndex 到 toIndex 之间的子集合(左闭右开区间) 
     * - 若 fromIndex == toIndex，则返回的空集合 
     * - 对该子集合的操作，会影响原有集合 
     * - 当调用了 subList() 后，若对原有集合进行删除操作(删除subList 中的首个元素)时，会抛出异常 java.util.ConcurrentModificationException 
     * - 该子集合支持所有的集合操作 
     *  
     * 原因看 SubList 内部类的构造函数就可以知道 
     * @throws IndexOutOfBoundsException {@inheritDoc} 
     * @throws IllegalArgumentException {@inheritDoc} 
     */  
    public List<E> subList(int fromIndex, int toIndex) {  
        subListRangeCheck(fromIndex, toIndex, size);   // 合法性检查  
        return new SubList(this, 0, fromIndex, toIndex);  
    }  

36、subListRangeCheck 方法（静态）

    static void subListRangeCheck(int fromIndex, int toIndex, int size) {  
        /* 
         * 越界检查 
         */  
        if (fromIndex < 0)  
            throw new IndexOutOfBoundsException("fromIndex = " + fromIndex);  
        if (toIndex > size)  
            throw new IndexOutOfBoundsException("toIndex = " + toIndex);  
        /*  
         * 非法参数检查 
         */  
        if (fromIndex > toIndex)  
            throw new IllegalArgumentException("fromIndex(" + fromIndex +  
                                               ") > toIndex(" + toIndex + ")");  
    }  

/*------------------------------------- 内部类 SubList -------------------------------------------*/

    /** 
     * 嵌套内部类：也实现了 RandomAccess，提供快速随机访问特性 
     * @title ArrayList.java  
     * @package com.johnnie.jsca.source  
     * @author johnnie 
     * @time 下午7:50:04 
     * @version v1.0 
     */  
    private class SubList extends AbstractList<E> implements RandomAccess {  
        private final AbstractList<E> parent;  
        private final int parentOffset;   // 相对于父集合的偏移量，其实就是 fromIndex  
        private final int offset;    // 偏移量，默认是 0  
        int size;   // SubList 存储元素个数  
  
        SubList(AbstractList<E> parent,  
            int offset, int fromIndex, int toIndex) {  
            // 看到这部分，就理解为什么对 SubList 的操作，会影响父集合---> 因为子集合的处理，仅仅是给出了一个映射到父集合相应区间的引用  
            // 再加上 final，的修饰，就能明白为什么进行了截取子集合操作后，父集合不能删除 SubList 中的首个元素了--->offset 不能更改  
            this.parent = parent;  
            this.parentOffset = fromIndex;  
            this.offset = offset + fromIndex;  
            this.size = toIndex - fromIndex;  
            this.modCount = ArrayList.this.modCount;  
        }  
  
        // 设置新值，返回旧值  
        public E set(int index, E e) {  
            rangeCheck(index);      // 越界检查  
            checkForComodification();  
            E oldValue = ArrayList.this.elementData(offset + index);  
            ArrayList.this.elementData[offset + index] = e;  
            return oldValue;  
        }  
  
        // 取值  
        public E get(int index) {  
            rangeCheck(index);   // 越界检查：设计到 ArrayList 中利用 index 进行访问，就需要进行越界检查  
            checkForComodification();  
            return ArrayList.this.elementData(offset + index);  
        }  
  
        public int size() {  
            checkForComodification();  
            return this.size;  
        }  
  
        // 添加元素  
        public void add(int index, E e) {  
            rangeCheckForAdd(index);  
            checkForComodification();  
            parent.add(parentOffset + index, e);   // 对子类添加元素，是直接操作父类添加的  
            this.modCount = parent.modCount;  
            this.size++;  
        }  
  
        // 删除元素  
        public E remove(int index) {  
            rangeCheck(index);  
            checkForComodification();  
            E result = parent.remove(parentOffset + index); // 对子类删除元素，是直接操作父类删除的  
            this.modCount = parent.modCount;  
            this.size--;  
            return result;  
        }  
  
        // 范围删除  
        protected void removeRange(int fromIndex, int toIndex) {  
            checkForComodification();  
            parent.removeRange(parentOffset + fromIndex,  
                               parentOffset + toIndex);  
            this.modCount = parent.modCount;  
            this.size -= toIndex - fromIndex;  
        }  
  
        public boolean addAll(Collection<? extends E> c) {  
            return addAll(this.size, c);  
        }  
  
        public boolean addAll(int index, Collection<? extends E> c) {  
            rangeCheckForAdd(index);  
            int cSize = c.size();  
            if (cSize==0)  
                return false;  
  
            checkForComodification();  
            parent.addAll(parentOffset + index, c);  
            this.modCount = parent.modCount;  
            this.size += cSize;  
            return true;  
        }  
  
        // SubList 的方法：返回一个迭代器，虽说是返回抽象的 Iterator，但具体实现是 ListIterator  
        public Iterator<E> iterator() {  
            return listIterator();  
        }  
          
        // SubList 的方法：返回一个 ListIterator  
        public ListIterator<E> listIterator(final int index) {  
            checkForComodification();  
            rangeCheckForAdd(index);  // 越界检查，这个地方有点晕，rangeCheckForAdd() 按说只是提供给 Add() 进行越界检查的  
            final int offset = this.offset;  
  
            // 匿名内部类  
            return new ListIterator<E>() {  
                int cursor = index;  
                int lastRet = -1;  
                int expectedModCount = ArrayList.this.modCount;  
  
                public boolean hasNext() {  
                    return cursor != SubList.this.size;  
                }  
  
                @SuppressWarnings("unchecked")  
                public E next() {  
                    checkForComodification();  
                    int i = cursor;  
                    if (i >= SubList.this.size)  
                        throw new NoSuchElementException();  
                    Object[] elementData = ArrayList.this.elementData;  
                    if (offset + i >= elementData.length)  
                        throw new ConcurrentModificationException();  
                    cursor = i + 1;  
                    return (E) elementData[offset + (lastRet = i)];  
                }  
  
                public boolean hasPrevious() {  
                    return cursor != 0;  
                }  
  
                @SuppressWarnings("unchecked")  
                public E previous() {  
                    checkForComodification();  
                    int i = cursor - 1;  
                    if (i < 0)  
                        throw new NoSuchElementException();  
                    Object[] elementData = ArrayList.this.elementData;  
                    if (offset + i >= elementData.length)  
                        throw new ConcurrentModificationException();  
                    cursor = i;  
                    return (E) elementData[offset + (lastRet = i)];  
                }  
  
                @SuppressWarnings("unchecked")  
                public void forEachRemaining(Consumer<? super E> consumer) {  
                    Objects.requireNonNull(consumer);  
                    final int size = SubList.this.size;  
                    int i = cursor;  
                    if (i >= size) {  
                        return;  
                    }  
                    final Object[] elementData = ArrayList.this.elementData;  
                    if (offset + i >= elementData.length) {  
                        throw new ConcurrentModificationException();  
                    }  
                    while (i != size && modCount == expectedModCount) {  
                        consumer.accept((E) elementData[offset + (i++)]);  
                    }  
                    // update once at end of iteration to reduce heap write traffic  
                    lastRet = cursor = i;  
                    checkForComodification();  
                }  
  
                public int nextIndex() {  
                    return cursor;  
                }  
  
                public int previousIndex() {  
                    return cursor - 1;  
                }  
  
                public void remove() {  
                    if (lastRet < 0)  
                        throw new IllegalStateException();  
                    checkForComodification();  
  
                    try {  
                        SubList.this.remove(lastRet);  
                        cursor = lastRet;  
                        lastRet = -1;  
                        expectedModCount = ArrayList.this.modCount;  
                    } catch (IndexOutOfBoundsException ex) {  
                        throw new ConcurrentModificationException();  
                    }  
                }  
  
                public void set(E e) {  
                    if (lastRet < 0)  
                        throw new IllegalStateException();  
                    checkForComodification();  
  
                    try {  
                        ArrayList.this.set(offset + lastRet, e);  
                    } catch (IndexOutOfBoundsException ex) {  
                        throw new ConcurrentModificationException();  
                    }  
                }  
  
                public void add(E e) {  
                    checkForComodification();  
  
                    try {  
                        int i = cursor;  
                        SubList.this.add(i, e);  
                        cursor = i + 1;  
                        lastRet = -1;  
                        expectedModCount = ArrayList.this.modCount;  
                    } catch (IndexOutOfBoundsException ex) {  
                        throw new ConcurrentModificationException();  
                    }  
                }  
  
                final void checkForComodification() {  
                    if (expectedModCount != ArrayList.this.modCount)  
                        throw new ConcurrentModificationException();  
                }  
            };  
        }  
  
        public List<E> subList(int fromIndex, int toIndex) {  
            subListRangeCheck(fromIndex, toIndex, size);  
            return new SubList(this, offset, fromIndex, toIndex);  
        }  
  
        private void rangeCheck(int index) {  
            if (index < 0 || index >= this.size)  
                throw new IndexOutOfBoundsException(outOfBoundsMsg(index));  
        }  
  
        private void rangeCheckForAdd(int index) {  
            if (index < 0 || index > this.size)  
                throw new IndexOutOfBoundsException(outOfBoundsMsg(index));  
        }  
  
        private String outOfBoundsMsg(int index) {  
            return "Index: "+index+", Size: "+this.size;  
        }  
  
        private void checkForComodification() {  
            if (ArrayList.this.modCount != this.modCount)  
                throw new ConcurrentModificationException();  
        }  
  
        public Spliterator<E> spliterator() {  
            checkForComodification();  
            return new ArrayListSpliterator<E>(ArrayList.this, offset,  
                                               offset + this.size, this.modCount);  
        }  
    }
	
/*------------------------------------- SubList 结束 -------------------------------------------*/  

37、forEach 方法

    // 同样是 1.8 的方法，用于函数式编程  
    @Override  
    public void forEach(Consumer<? super E> action) {  
        Objects.requireNonNull(action);  
        final int expectedModCount = modCount;  
        @SuppressWarnings("unchecked")  
        final E[] elementData = (E[]) this.elementData;  
        final int size = this.size;  
        for (int i=0; modCount == expectedModCount && i < size; i++) {  
            action.accept(elementData[i]);  
        }  
        if (modCount != expectedModCount) {  
            throw new ConcurrentModificationException();  
        }  
    }  

38、spliterator 方法

    /** 
     * 获取一个分割器 
     * - fail-fast 
     * - late-binding：后期绑定 
     * - java8 开始提供 
     *  
     * @return a {@code Spliterator} over the elements in this list 
     * @since 1.8 
     */  
    @Override  
    public Spliterator<E> spliterator() {  
        return new ArrayListSpliterator<>(this, 0, -1, 0);  
    }  
  
    /** Index-based split-by-two, lazily initialized Spliterator */  
    // 基于索引的、二分的、懒加载的分割器  
    static final class ArrayListSpliterator<E> implements Spliterator<E> {  
  
        private final ArrayList<E> list;  
        private int index; // current index, modified on advance/split  
        private int fence; // -1 until used; then one past last index  
        private int expectedModCount; // initialized when fence set  
  
        /** Create new spliterator covering the given  range */  
        ArrayListSpliterator(ArrayList<E> list, int origin, int fence,  
                             int expectedModCount) {  
            this.list = list; // OK if null unless traversed  
            this.index = origin;  
            this.fence = fence;  
            this.expectedModCount = expectedModCount;  
        }  
  
        private int getFence() { // initialize fence to size on first use  
            int hi; // (a specialized variant appears in method forEach)  
            ArrayList<E> lst;  
            if ((hi = fence) < 0) {  
                if ((lst = list) == null)  
                    hi = fence = 0;  
                else {  
                    expectedModCount = lst.modCount;  
                    hi = fence = lst.size;  
                }  
            }  
            return hi;  
        }  
  
        public ArrayListSpliterator<E> trySplit() {  
            int hi = getFence(), lo = index, mid = (lo + hi) >>> 1;  
            return (lo >= mid) ? null : // divide range in half unless too small  
                new ArrayListSpliterator<E>(list, lo, index = mid,  
                                            expectedModCount);  
        }  
  
        public boolean tryAdvance(Consumer<? super E> action) {  
            if (action == null)  
                throw new NullPointerException();  
            int hi = getFence(), i = index;  
            if (i < hi) {  
                index = i + 1;  
                @SuppressWarnings("unchecked") E e = (E)list.elementData[i];  
                action.accept(e);  
                if (list.modCount != expectedModCount)  
                    throw new ConcurrentModificationException();  
                return true;  
            }  
            return false;  
        }  
  
        public void forEachRemaining(Consumer<? super E> action) {  
            int i, hi, mc; // hoist accesses and checks from loop  
            ArrayList<E> lst; Object[] a;  
            if (action == null)  
                throw new NullPointerException();  
            if ((lst = list) != null && (a = lst.elementData) != null) {  
                if ((hi = fence) < 0) {  
                    mc = lst.modCount;  
                    hi = lst.size;  
                }  
                else  
                    mc = expectedModCount;  
                if ((i = index) >= 0 && (index = hi) <= a.length) {  
                    for (; i < hi; ++i) {  
                        @SuppressWarnings("unchecked") E e = (E) a[i];  
                        action.accept(e);  
                    }  
                    if (lst.modCount == mc)  
                        return;  
                }  
            }  
            throw new ConcurrentModificationException();  
        }  
  
        public long estimateSize() {  
            return (long) (getFence() - index);  
        }  
  
        public int characteristics() {  
            return Spliterator.ORDERED | Spliterator.SIZED | Spliterator.SUBSIZED;  
        }  
    }  

39、removeIf 方法

    @Override  
    public boolean removeIf(Predicate<? super E> filter) {  
        Objects.requireNonNull(filter);  
        // figure out which elements are to be removed  
        // any exception thrown from the filter predicate at this stage  
        // will leave the collection unmodified  
        int removeCount = 0;  
        final BitSet removeSet = new BitSet(size);  
        final int expectedModCount = modCount;  
        final int size = this.size;  
        for (int i=0; modCount == expectedModCount && i < size; i++) {  
            @SuppressWarnings("unchecked")  
            final E element = (E) elementData[i];  
            if (filter.test(element)) {  
                removeSet.set(i);  
                removeCount++;  
            }  
        }  
        if (modCount != expectedModCount) {  
            throw new ConcurrentModificationException();  
        }  
  
        // shift surviving elements left over the spaces left by removed elements  
        final boolean anyToRemove = removeCount > 0;  
        if (anyToRemove) {  
            final int newSize = size - removeCount;  
            for (int i=0, j=0; (i < size) && (j < newSize); i++, j++) {  
                i = removeSet.nextClearBit(i);  
                elementData[j] = elementData[i];  
            }  
            for (int k=newSize; k < size; k++) {  
                elementData[k] = null;  // Let gc do its work  
            }  
            this.size = newSize;  
            if (modCount != expectedModCount) {  
                throw new ConcurrentModificationException();  
            }  
            modCount++;  
        }  
  
        return anyToRemove;  
    }  

40、replaceAll 方法

    @Override  
    @SuppressWarnings("unchecked")  
    public void replaceAll(UnaryOperator<E> operator) {  
        Objects.requireNonNull(operator);  
        final int expectedModCount = modCount;  
        final int size = this.size;  
        for (int i=0; modCount == expectedModCount && i < size; i++) {  
            elementData[i] = operator.apply((E) elementData[i]);  
        }  
        if (modCount != expectedModCount) {  
            throw new ConcurrentModificationException();  
        }  
        modCount++;  
    }  

41、sort 方法

    @Override  
    @SuppressWarnings("unchecked")  
    public void sort(Comparator<? super E> c) {  
        final int expectedModCount = modCount;  
        Arrays.sort((E[]) elementData, 0, size, c);  
        if (modCount != expectedModCount) {  
            throw new ConcurrentModificationException();  
        }  
        modCount++;  
    }  
      
}
```

# 小结
ArrayList总体来说比较简单，不过ArrayList还有以下一些特点：

    ① ArrayList自己实现了序列化和反序列化的方法，因为它自己实现了 private void writeObject(java.io.ObjectOutputStream s)和 private void readObject(java.io.ObjectInputStream s) 方法
    
	② ArrayList基于数组方式实现，无容量的限制（会扩容）
    
	③ 添加元素时可能要扩容（所以最好预判一下），删除元素时不会减少容量（若希望减少容量，trimToSize()），删除元素时，将删除掉的位置元素置为null，下次gc就会回收这些元素所占的内存空间。线程不安全
    
	④ add(int index, E element)：添加元素到数组中指定位置的时候，需要将该位置及其后边所有的元素都整块向后复制一位
    
	⑥ get(int index)：获取指定位置上的元素时，可以通过索引直接获取（O(1)）
    
	⑦ remove(Object o)需要遍历数组
    
	⑧ remove(int index)不需要遍历数组，只需判断index是否符合条件即可，效率比remove(Object o)高
    
	⑨ contains(E)需要遍历数组
    
	⑩ 使用iterator遍历可能会引发多线程异常
<br>

转载请注明原地址：[wonderheng的博客](http://www.wonderheng.top) » [点击阅读原文](http://www.wonderheng.top/2018/03/ArrayList%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90/)，谢谢！