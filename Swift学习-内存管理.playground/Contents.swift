//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"



//================================================//
//=                                              =//
//=           ======Swift学习-内存管理======       =//
//=                                              =//
//================================================//



//一、析构函数deinit
print("一、析构函数deinit")
/*
与构造函数相反，析构函数deinit是用于释放对象内存。但其实Swift已经通过ARC自动引用计数在帮助我们处理实例的内存管理了，所以实际开发中，我们不需要再手动进行清理。
在实际的开发中，我们通常会在deinit中处理一些特殊的操作，如移除通知或者KVO，销毁定时器等。下面演示一个析构函数的使用：
*/
class Person{
    var name:String
    //构造函数
    init(name:String){
        self.name = name;
        print(name,"is coming")
    }
    
    func doSomething(){
        print(name , "is doing something~")
    }
    
    //析构函数
    //创建析构函数，无需关键字func，也无需参数小括号
    deinit {
        print(name,"is leaving")
    }
}

func testDeinit(){
    let person = Person(name: "小飞")
    person.doSomething()
}

testDeinit()  //执行测试函数

//打印结果：
/*
小飞 is coming
小飞 is doing something~
小飞 is leaving
*/

/*
代码分析:
testDeinit函数的作用域里创建了person对象，函数执行完之后，person将不再被使用，所以被系统清理内存。所以最后打印了"小飞 is leaving"
*/


//二、引用计数
print("\n二、测试引用计数")
var person1:Person? = Person(name: "person1")
var person2 = person1
var person3 = person1
//引用计数变成了3个，每一个指针都赋值为nil，才会调用析构函数
person1 = nil
person2 = nil
person3 = nil



//三、强引用循环与weak
print("\n三、强引用循环与weak")
//即使存在ARC，仍然可能存在内存泄漏，这种情况通常发生在对象之间的强引用循环，即两个对象相互持有对方的引用，比如下面的代码：
class Teacher{
    var name:String
    var student:Student?
    init(name:String) {
        self.name = name
        print(name,"is being initialized!")
    }
    deinit {
        print(name,"is being deinitialized!")
    }
}

class Student{
    var name:String
    //var teacher:Teacher?
    weak var teacher:Teacher?
    init(name:String) {
        self.name = name
        print(name,"is being initialized!")
    }
    deinit {
        print(name,"is being deinitialized!")
    }
}
var teacher:Teacher? = Teacher(name: "teacher")
var student:Student? = Student(name: "student");
teacher?.student = student
student?.teacher = teacher
teacher = nil
student = nil

//代码分析：teacher与student两个对象都各自强引用持有对方，所以通过赋值nil的方法都无法释放这两个对象。解决方法是改强引用为弱引用，在其中的一个类中设置weak属性，如Student中被注释掉的代码
/*
weak使用的条件限制：
1.属性是可选型
2.属性是变量而非常量
*/


//四、unowned
//针对于weak的使用限制，当需要对常量进行设置引用效果时，我们可以使用unowned。相关的测试代码如下：
print("\n四、unowned")
//消费者类
class Customer{
    var name:String
    var creditCard:CreditCard?
    //构造函数
    init(name:String){
        self.name = name;
        print(name,"is being initialized!")
    }
    
    //析构函数
    //创建析构函数，无需关键字func，也无需参数小括号
    deinit {
        print(name,"is being deinitialized!")
    }
}
//信用卡类：每个信用卡的用户都是确定的，所以customer属性用了常量
class CreditCard{
    let number:String
    unowned  let customer:Customer
    
    init(number:String,customer:Customer) {
        self.number = number
        self.customer = customer
        print("Credit Card",number,"is being initialized!")
    }
    deinit {
        print("Credit Card",number,"is being deinitialized!")
    }
}

var customer:Customer? = Customer(name: "human")
var creditCard:CreditCard? = CreditCard(number: "123456789", customer: customer!)
customer?.creditCard = creditCard

//使用了unowned之后，可以成功释放对象
customer = nil
//creditCard?.customer  这里是使用unowned的弊端，提前释放空间之后，造成了程序的不安全
creditCard = nil


//五、隐式可选型
//class Country{
//    let name:String
//    var capital:City!
//
//    init(counryName:String,capitalName:String){
//        self.name = counryName
//    }
//
//}
//
//class City{
//    let name:String
//    unowned let country：Country
//
//}



//六、闭包中的强引用循环问题
/*
1.跟oc一样,使用weak(oc是__weakSelf)
2.简化第一种方法tools?.loadData({[weak self] (jsonData) in}) 这里self需要解包(推荐使用)
 3.简化第一种方法tools?.loadData({[unowned self] (jsonData) in})这种方法当self为空就会崩溃
*/

//七、闭包捕获列表



