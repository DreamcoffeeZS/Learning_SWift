//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//================================================//
//=                                              =//
//=           ======Swift学习-集合类型======       =//
//=                                              =//
//================================================//

/*
 Swift语言提供Arrays、Sets和Dictionaries三种基本的集合类型用来存储集合数据。
 数组(Arrays)是有序数据的集；
 集合(Sets)是无序无重复数据的集；
 字典(Dictionaries)是无序的键值对的集；
 
 注意：区别于Objective-C里对应的集合，在Swift中的Arrays、Sets或Dictionaries，如果被分配成一个变量，则这个集合将会是可变的，否则相反。
 */


//一、数组(Arrays)
///*1*.创建数组
//在Swift中创建数组主要有Array<Element> 、[Element]两种形式，在这两种基本形式下创建数组的方法有以下几种：
//通过显式声明创建空数组
var numbers1 = [Int]()      //1.使用构造语法创建特定数据类型的空数组，numbers1的值类型被推断为[Int]
numbers1 = []               //2.上下文可推断的情况下，可以直接使用[]创建空数组
var number2: [Int] = [];
var number3 = Array<Int>()
var number4: Array<Int> = []

//通过默认值隐式推断创建数组
var numbers = [0, 1, 2, 3, 4]
var strings = ["a", "b", "c", "d"]
var chars: [Character] = ["A", "B", "C"]  //创建一个字符数组，必须显式声明，因为被双引号的默认是字符串

//通过指定长度,重复元素创建数组
var array1 = [Int](repeating: 6, count: 3)       //[6,6,6]
var array2 = Array<Int>(repeating: 8, count:5)   //[8,8,8,8,8]


///*2*.数组的基本使用
//Swift数组的基本使用包括数组判空、下标取值、获取长度等，具体用法可参考如下代码：
var nums = [0, 1, 2, 3, 4]
var strs = ["a", "b", "c", "d"]
var emptyArr = [Int]();

//判断数组是否为空
numbers.isEmpty   //false
emptyArr.isEmpty  //true

//获取数组长度
nums.count        //5
strs.count        //4

//根据索引范围，截取子数组
numbers[2..<4]                //返回数组：[2, 3]
numbers[2..<numbers.count]    //返回数组：[2, 3, 4]

//判别某个元素是否存在数组中,得到位置索引
strs.contains("A")            //false
strs.contains("a")            //true
strs.index(of: "a")           //0
strs.index(of: "c")           //2

//判断数组相等，其实swift判断的是两个数组里的值相等
var arr1 = [0, 1, 2, 3, 4]
var arr2 = [0, 1, 2, 3, 4]
arr1 == arr2                  //true



///*3*.数组元素的增删改查
//1.查询数组中的元素
//方法1：索引取值,注意数组越界
nums[1]          //1
strs[2]          //"c"
//strs[4]        //越界错误

//方法2：获取首尾位置的数据，返回可选型
strs.first;      //"a"
strs.last;       //"d"
if let firstStr = strs.first{
    print("The firstStr is " + firstStr)
    //The firstVowel is a
}
strs.first!     //"a"，如果strs是常量数组，数组中数据不会变，可以使用强制解包

//方法3：获取最小值和最大值
strs.min()      //"a"
strs.max()      //"d"


//2.向数组中添加新元素
//方法1：使用append(_:)方法
nums.append(5)               //[0, 1, 2, 3, 4, 5]

//方法2：使用加法赋值运算符(+=)
nums += [6,7]                //[0, 1, 2, 3, 4, 5, 6, 7]
nums

//方法3：指定索引位置，插入新元素insert(_:at:)
nums.insert(8, at: 0)       //[8, 0, 1, 2, 3, 4, 5, 6, 7]

//3.删除数组元素
nums.removeFirst()          //删除第一个元素，返回值8
nums                        //[0, 1, 2, 3, 4, 5, 6, 7]
nums.removeLast()           //删除最后一位元素，返回值7
nums                        //[0, 1, 2, 3, 4, 5, 6]
nums.remove(at: 6)          //删除索引6位置元素，返回值6
nums                        //[0, 1, 2, 3, 4, 5]

//4.修改数组元素
//借助下标修改数组元素,可单个修改也可以范围修改
nums[0] = 8
nums                        //[8, 1, 2, 3, 4, 5]
nums[0..<2] = [88]
nums                        //[88, 2, 3, 4, 5]
nums[0..<2] = [99,99]
nums                        //[99, 99, 3, 4, 5]



///*4*.数组遍历
//1.使用索引遍历
for index in 0..<nums.count{
    print(nums[index])
}
//2.只能获取值,虽然没有指定索引，但是仍然是有序遍历
for number in nums{
    print(number)
}

//3.同时获取元素和索引的遍历
for (index, str) in strs.enumerated(){
    print("\(index)----\(str)")
}


///*4*.二维数组
//Swift中的数组也可以是多维的，如下的二维数组board:
var board = [
    ["0", "1", "3", "4"],
    ["a", "b", "c"],
    ["A", "B","C"]
]
//常见的取值操作
board.count       //3
board[0].count    //4
board[0][0]       //"0"

//测试1：在第一行增加一个元素
board[0].append("5")
//测试2：增加一行
board.append(["hello", "word"])
//测试3：二维数组拼接二维数组
board += [["00","11","22"]]


///4.NSArray
/*
//此时swift不能对端，默认为NSArray类型
var array1 = []
//一种方法，创建一个NSArray数组
var array2 = [1, 2, 3, 4] as NSArray
//NSArray类型的数组可以承载多种类型数据
var array3: NSArray = [1, "Hello", 3.0]
//swift的数组也可以装多种类型数据，因为数据默认为NSObjct类型
var array4  = [1, "Hello", 4.0]
var array5: [NSObject] = [1, "Hello", 4.0]
//cocoaTouch中NS类，包括在Foundation而类库中
//而UIkitl类库中引用了Foundation类库
*/




//二、集合(Sets)
/*
集合(Set)用来存储相同类型并且没有确定顺序的值。当集合元素顺序不重要时或者希望确保每个元素只出现一次时可以使用集合而不是数组。
*/

///*1.*创建和构造一个集合
//Swift中的Set类型被写为Set<Element>，这里的Element表示Set中允许存储的类型。一般可通过此形式创建集合
//方法1：通过构造器语法创建空集合
var set1 = Set<String>()  //Set([])
set1 = ["Swift", "Java"]  //{"Java", "Swift"}

var set2:Set<Int> = []    //Set([])

//方法2：通过数组创建集合
var set3 = Set<Int>([1, 2, 3 , 4])  //{2, 3, 1, 4}
var set4 = Set(["a", "b", "c"])     //{"b", "a", "c"}


//*2.*访问和修改集合
var languagesSet:Set<String> = ["Swift","OC","OC"]

//获取集合中元素数量
languagesSet.count              //2,集合中不存在重复元素

//判断集合是否为空
languagesSet.isEmpty            //false

//判断集合中是否包含某一个元素
languagesSet.contains("Swift")  //true
languagesSet.contains("Html")   //false

//两个集合的比较：值比较，忽略重复元素，无序
var languagesSet2:Set<String> = ["OC","Swift"]
languagesSet == languagesSet2  //true

//增加集合元素,集合无序所以没有索引值
languagesSet.insert("JAVA")
languagesSet                    //{"OC", "JAVA", "Swift"}

//删除集合元素，删除指定源
languagesSet.remove("OC")       //成功删除元素，会返回删除的元素"OC"
languagesSet.remove("Html")     //删除不存在的元素，返回可选型nil


 ///*3.*集合遍历
var numberSet :Set<Int> = [1,2,3,4,5,6]
//方法1：无序打印，使用for-in循环
for num in numberSet {
    print("\(num)")   //无序打印：5，6，2，3，1，4
}
//方法2:有序打印,使用sorted()函数
//Swift的Set类型没有确定的顺序，为了按照特定顺序来遍历一个Set中的值可以使用sorted()方法，它将返回一个有序数组，这个数组的元素排列顺序由操作符'<'对元素进行比较的结果来确定.
for num in numberSet.sorted(){
    print("\(num)")   //有序打印：1，2，3，4，5，6
}


//三、字典(Dictionary)
/*
 Swift字典中存放键值对形式的数据，其中的每个值(value)对应唯一的键(key)。字典中的数据项没有具体的顺序，我们是通过key键来访问数据。
 
 Swift的字典使用Dictionary<Key, Value>定义，其中Key是字典中键的数据类型，Value是字典中对应于这些键所存储值的数据类型。
*/

///*1.*创建字典
//1.字面量推断的方式创建字典
var dict = ["one": "第一名", "two": "第二名", "three" : "第三名"]
//2.显式声明的方式创建字典
var dict1: [String: String] = ["one": "第一名", "two": "第二名", "three" : "第三名"]
//3.泛型格式创建字典
var dict2:Dictionary<String, String> = ["one": "第一名", "two": "第二名", "three" : "第三名"]
//4.创建空字典的几种方法
var emptyDict: [String: String] = [:]
var emptyDict2: Dictionary<String, Int> = [:]
var emttyDict3 = [String: Int]()
var emtypDict4 = Dictionary<Int, Int>()


///*2.*字典常用操作
var numsDic = ["1":"one"]
//2.1判断字典数据个数
numsDic.count                  //1

//2.2判断字典是否为空
numsDic.isEmpty                //false


//2.3从字典中取值:返回的是可选型
numsDic["one"]

if let tempValue = numsDic["4"]{
    print(tempValue)
}

//2.4增加和修改元素
//通过以下方法增加元素时，若字典中已经存在key，则原来的元素会被更新；若不存在key，则会增加一个新的键值对。
//下标法
numsDic["2"]  = "two"
numsDic                      //["2": "two", "1": "one"]
numsDic["2"]  = "twotwo"
numsDic                      //["2": "twotwo", "1": "one"]
//updateValue(_:forkey)方法
numsDic.updateValue("three", forKey: "3")
numsDic                      //["2": "twotwo", "1": "one", "3": "three"]
numsDic.updateValue("threethree", forKey: "3")
numsDic                      //"2": "twotwo", "1": "one", "3": "threethree"]

//2.5移除字典元素
//方法1：使用下标语法将key对应的value赋值为nil
numsDic["3"] = nil
numsDic                           //["2": "twotwo", "1": "one"]
//方法2：使用removeValue(forkey:)
numsDic.removeValue(forKey: "2")  //["1": "one"]
numsDic


///*3.*字典遍历
//方法1：for-in循环遍历字典中的键值对
for (key,value) in numsDic{
    print(key + ":" + value)
}

//方法2：遍历keys或者values属性
for key in numsDic.keys{
    print(key + "-" + numsDic[key]! )
}

for value in numsDic.values{
    print(value)
}

//注意：Swift的字典类型是无序集合类型。为了以特定的顺序遍历字典的键或值，可以对字典的keys或values属性使用sorted()方法，参考上节中集合的用法。














