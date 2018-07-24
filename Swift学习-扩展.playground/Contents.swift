//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//================================================//
//=                                              =//
//=           ======Swift学习-扩展======          =//
//=                                              =//
//================================================//



//一、理解扩展
/*
扩展特点：
1.扩展就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即 逆向建模 ）。
2.扩展和 Objective-C 中的分类类似。（与 Objective-C 不同的是，Swift 的扩展没有名字。）
3.扩展可以为一个类型添加新的功能，但是不能重写已有的功能

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
3.扩展可以为一个类型添加新的功能，但是不能重写已有的功能。
4.通过扩展为一个已有类型添加新功能，那么新功能对该类型的所有已有实例都是可用的，即使它们是在这个扩展定义之前创建的。
*/

struct  Point{
    var x = 0.0
    var y = 0.0
}

struct Size{
    var width = 0.0
    var height = 0.0
}

class Rectangle {
    var origin:Point = Point()
    var size = Size()
    init (origin:Point, size: Size){
        self.origin = origin
        self.size = size
    }
}




//二、扩展的基本使用
//1.扩展属性
//扩展可以添加新的计算型属性，但是不可以添加存储型属性，也不可以为已有属性添加属性观察器
extension Rectangle{
    //注意：扩展不能扩展存储型属性
    //var center:Point = Point() //报错
    //只能扩展计算型属性
    var center: Point {
        get {
            let center_x = origin.x + size.width/2
            let center_y = origin.y + size.height/2
            return Point(x: center_x, y: center_y)
        }
        set{
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }
}

let rect1 = Rectangle(origin: Point(x:0,y:0), size: Size(width: 100, height: 100))
print(rect1.center)              //Point(x: 50.0, y: 50.0)
rect1.center = Point(x: 0, y: 0)
print(rect1.center)              //Point(x: 0.0, y: 0.0)





//2.扩展方法
//扩展可以为已有类型添加新的实例方法和类型方法。
extension Rectangle{
    //注意：这里直接修改了属性，如果是结构体Struct，不能直接这样修改
    //func之前需要使用 mutating
    func translate(x:Double , y:Double){
        self.origin.x += x
        self.origin.y += y
    }
}

let rect2  = Rectangle(origin: Point(x:0,y:0), size: Size(width: 100, height: 100))
rect2.translate(x: 100, y: 100)
print(rect2.center)     //Point(x: 150.0, y: 150.0)


//3.扩展构造器
//扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供.
extension Rectangle{
    //注意：在扩展中添加了构造函数，必须是便利构造函数，其中调用指定构造函数
    convenience init(center:Point, size:Size) {
        let origin_x = center.x - size.width/2
        let origin_y = center.y - size.height/2
        //便利构造函数必须调用指定构造函数
        self.init(origin:Point(x: origin_x, y: origin_y),size:size)
    }
}
let rect3 = Rectangle(center: Point(x:200, y:200), size: Size(width: 100, height: 100))

//注意：如果你使用扩展提供了一个新的构造器，你依旧有责任确保构造过程能够让实例完全初始化。

//注意：如果你使用扩展为一个值类型添加构造器，同时该值类型的原始实现中未定义任何定制的构造器且所有存储属性提供了默认值，那么我们就可以在扩展中的构造器里调用默认构造器和逐一成员构造器。


//4.扩展下标
//扩展可以为已有类型添加新下标。下面的例子为Swift内建类型Int添加了一个整型下标。该下标 [n] 返回十进制数字从右向左数的第n个数字：
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

print(746381295[3]) //1
print(746381295[6]) //6




//三、嵌套类型
//扩展可以为已有的类、结构体和枚举添加新的嵌套类型;下面的示例中，Rectangle中嵌套一个枚举类型，用以获取矩形的各个定点坐标。
extension Rectangle{
    
    enum Vertex:Int {
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    //扩展出一个方法来获取各个顶点坐标
    func pointAtVertex(v:Vertex) -> Point{
        switch v {
        case .TopLeft:
            return origin
        case .TopRight:
            return Point(x: origin.x + size.width, y: origin.y)
        case .BottomLeft:
            return Point(x: origin.x, y: origin.y + size.height)
        case .BottomRight:
            return Point(x: origin.x + size.width, y: origin.y + size.height)
        }
    }
    
    //扩展下标
    subscript (index:Int) ->Point{
        assert(index >= 0 && index<4,"out of range")
        //修改枚举的原始值是Int类型，而这里🈶使用rowValue方法构建了枚举型
        return pointAtVertex(v: Vertex(rawValue: index)!)  //已经使用了断言，这里使用强制解包
    }
}


//测试代码：
let rect4  = Rectangle(origin: Point(x:0,y:0), size: Size(width: 100, height: 100))
let point1 = rect4.pointAtVertex(v: .TopRight)
print(point1)    //Point(x: 100.0, y: 0.0)
let point2 = rect4.pointAtVertex(v: Rectangle.Vertex.BottomRight)
print(point2)    //Point(x: 100.0, y: 0.0)
let point3 = rect4[2]
print(point3)    //Point(x: 0.0, y: 100.0)



//四、扩展系统类库
//1.扩展Double
//扩展Double，为其添加计算型属性，提供与距离单位协作的基本支持
extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let distance1 = 25.4.mm
print("distance1 is \(distance1) meters")    //distance1 is 0.0254 meters

let distance2 = 42.mm + 1.km
print("disatance2 is \( distance2) meters")  //disatance2 is 1000.042 meters


//2.为已有类型添加及新的实例方法和类型方法
extension Int{
    //扩展实例方法：传入一个闭包参数，闭包执行10次
    func  repetitions(task: () -> Void){
        for _ in 0...5{
            //执行闭包
            task()
        }
    }
    
    //可变实例方法：平方运算
    mutating func square(){
        self = self * self
    }
    
    //可变实例方法：立方运算
    mutating func cube(){
        self = self * self * self
    }
    
    //判断整型是否在某个范围内
    func inRange(closedLeft:Int, opendRight:Int) -> Bool{
        return self >= closedLeft && self < opendRight
    }
}

var tempNum = 10;
tempNum.square()        //100
tempNum.inRange(closedLeft: 10, opendRight: 100)   //false
tempNum.repetitions {
    print(tempNum)
}


