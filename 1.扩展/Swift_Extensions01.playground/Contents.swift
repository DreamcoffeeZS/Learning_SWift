//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
扩展：
1."扩展就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即 逆向建模 ）。
2.扩展和Objective-C 中的分类类似。（与 Objective-C 不同的是，Swift 的扩展没有名字。)"
3."扩展可以为一个类型添加新的功能，但是不能重写已有的功能"

扩展功能：
1、添加计算型实例属性和计算型类型属性。
2、定义实例方法和类型方法
3、提供新便利构造器和便利析构器
4、定义下标
5、定义和使用新的嵌套类型
6、使一个已有类型符合某个协议”


使用注意：
1.不可以添加存储属性，也不可以为已有属性添加属性观察器
2.扩展中不能为类添加新的指定构造器，因为指定构造器和析构器必须由原始的类来实现
*/

//1.添加计算型属性
//提供与距离单位协作的基本支持
extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let aMarathon = 42.mm + 80.km
print("A marathon is \(aMarathon) meters")
//扩展可以添加新的计算型属性，但是不可以添加存储属性，也不可以为已有的属性添加属性观察器

//2.添加便利构造器和析构器
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

/*
 注意：1.扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供。
    2.如果你使用扩展为一个值类型添加构造器，同时该值类型的原始实现中未定义任何定制的构造器且所有存储属性提供了默认值，那么我们就可以在扩展中的构造器里调用默认构造器和逐一成员构造器。
*/

//3.为已有类型添加及新的实例方法和类型方法
extension Int {
    //实例方法
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    
    //可变实例方法
    mutating func square(){
        self = self * self
        
    }
}

3.repetitions { 
    print("hello world");
}

var someInt = 9
someInt.square()


//4.下标
//下标 [n] 返回十进制数字从右向左数的第 n 个数字：
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]


