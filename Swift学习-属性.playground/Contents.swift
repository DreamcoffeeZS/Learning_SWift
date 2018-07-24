//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//================================================//
//=                                              =//
//=           ======Swift学习-属性======       =//
//=                                              =//
//================================================//
/*
 属性是与特定的类、结构体、枚举相关联的值，本篇将详细介绍Swift属性的用法。
*/

//一、存储属性与计算型属性
print("一、存储属性与计算型属性")
/*
Swift从属性被定义的方式上看，可以分为存储属性和计算属性两中属性：
存储属性：存储在特定类或结构体实例里的一个常量(let)或变量(var)，作为实例的一部分；
 
计算型属性：计算属性不直接存储值，而是提供一个getter和一个可选的setter，来间接设置其他属性或变量值；
*/

//下面通过一段代码演示这两种属性的区别：
struct Square{
    //存储属性
    var width:Double
    
    //计算属性
    var area:Double{
        get{
            return width * width
        }
    }
}
let square = Square(width: 10.0)
print("正方形边长：\(square.width)")     //正方形边长：10.0
print("正方形面积：\(square.area)")      //正方形面积：100.0

//关于存储属性和计算属性的用法还有如下几种情况：
//1.1.常量结构的存储属性
/*
如果创建一个结构体的实例并且将其赋值给一个常量，则无法再修改该实例的任何属性(包括其中的变量属性)。
 这是因为结构体是值类型，值类型实例被声明为常量，其所有属性都成了常量;在这点上，类与结构体不同，这种情况下，类中的可变属性可以被修改
*/
let square1 = Square(width: 10.0)
//square1.width = 11.0      //报错
var square2 = Square(width:20.0)
square2.width = 21.0      //可以修改

//1.2.延迟存储属性
/*
延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性。在属性声明前使用lazy来标示一个延迟存储属性。延迟属性作用是：当属性的值依赖于在实例的构造过程结束后才会知道影响值的外部因素时，或者当获得属性的初始值需要复杂或大量计算时，可以只在需要的时候计算它。
*/
class Number{
    //存储属性
    var startNum: Int!
    var endNum:Int!
    //计算属性
    var length :Int{
        return endNum - startNum + 1
    }
    
    //延迟属性：使用闭包计算出了延迟属性的值，此过程只执行一次
    lazy var sum: Int = {
        print("计算延迟属性。。。。")
        var tempNum = 0;
        for i in self.startNum...self.endNum{
            tempNum += i;
        }
        return tempNum
    }()
    
    //可失败的构造方法
    init?(startNum: Int , endNum:Int){
        if(startNum > endNum){
            return nil
        }
        self.startNum = startNum
        self.endNum = endNum
    }
}

let number = Number(startNum: 1, endNum: 100)
number?.length  //100
number?.sum     //5050
number?.sum     //5050
/*
 注意：
 1.必须将延迟存储属性声明成变量(使用var关键字)，因为属性的初始值可能在实例构造完成之后才会得到。而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延迟属性。
 2.如果一个被标记为 lazy 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次。
*/

//1.3计算属性
/*
计算属性不直接存储值，而是提供一个getter和一个可选的setter，来间接设置其他属性或变量值；总结它的使用特点如下：
1.只有getter没有setter的计算属性就是只读计算属性。只读属性通过点运算符访问，只能返回值而不可设置新值；
2.计算属性与其他属性相关，是变化的，所以必须使用var关键字进行修饰，包括只读计算属性；
3.只读计算属性可以去掉get关键字和花括号；
 */
struct Point {
    var x = 0.0
    var y = 0.0
}

struct Size {
    var width = 0.0
    var height = 0.0
}

class Rectangle{
    //存储型数据
    var originPoint  = Point()
    var size = Size()
    
    //计算型属性
    var center:Point{
        //get方法：获取计算属性值
        get{
            let center_x = originPoint.x + size.width/2
            let center_y = originPoint.y + size.height/2
            return Point(x: center_x, y: center_y)
        }
        
        //如果没有set方法，是只读，
        /*
         set(newCenter){
            originPoint.x = newCenter.x - size.width/2
            originPoint.y = newCenter.y - size.height/2
         }
         */
        
        //set方法：设置计算属性新值
        //这里也可以省略括号和newCenter.使用newValue
        set{
            originPoint.x = newValue.x - size.width/2
            originPoint.y = newValue.y - size.height/2
        }
    }
    
    //计算属性：area属性只有get,可以不显式的声明出get；此属性为只读属性
    var area:Double{
        return size.width * size.height
    }
    
    init(origin: Point, size: Size){
        self.originPoint  = origin
        self.size  = size
    }
}

//创建一个长方形
var rect = Rectangle(origin: Point(x: 0, y: 0), size: Size(width: 100, height: 100))
rect.center
rect.area   //10000


//二、属性观察器
print("\n二、属性观察器")
/*
属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外。
 
属性观察器可以为延迟属性外的其他存储属性添加属性观察，也可以通过继承的方式重写父类属性，为其添加属性观察期。但是我们没有必要为非重写的计算属性添加属性观察器，因为它本身就可以通过自己的setter直接监控和响应值的变化。
 
添加属性观察器方式如下：
willSet:在新的值被设置之前调用，拥有一个默认参数newValue(代表新的属性值)；
didSet:在新的值被设置之后立刻调用,拥有一个默认参数oldValue(代表就的属性值)；
 
 下main通过lightBlub演示用法，其中为currentDianYa属性添加了观察器：
 */
class lightBlub {
    //最大电压和当前电压
    static let maxDianYa = 30
    
    //属性监听
    //注意：willSet和didSet括号中的值可以省略，直接使用系统自带的newVlaue和oldValue
    var currentDianYa = 0 {
        //可以使用系统默认的属性newValue和oldValue
        willSet(newCurrentDianya){
            print("当前电压值将要改变:  \(currentDianYa) -> \(newCurrentDianya)")
        }
        
        //当调用此方法时，已经设置了值的时候,
        didSet(oldCurentDianYa){
            if(currentDianYa == lightBlub.maxDianYa){
                print("请注意 ,当前电压达到了最大电压值")
            }else if(self.currentDianYa > lightBlub.maxDianYa){
                print("当前电压过高，不能设置新的电压值")
                currentDianYa = oldCurentDianYa
            }
        }
    }
}

let light = lightBlub()
light.currentDianYa = 10
light.currentDianYa = 30
light.currentDianYa = 40
/*
 打印结果：
 当前电压值将要改变:  0 -> 10
 当前电压值将要改变:  10 -> 30
 请注意 ,当前电压达到了最大电压值
 当前电压值将要改变:  30 -> 40
 当前电压过高，不能设置新的电压值
*/

//注意：willSet和didSet并不会在初始化时被调用

//三、类型属性
print("\n三、类型属性")
/*
实例属性属于一个特定类型的实例，因此实例之间的属性相互独立。但其实，也可以为类型本身定义属性，这样无论创建了多少个该类型实例，这些属性只有唯一的一份，这种属性就是类型属性。

Swift的类型属性就相当于OC或者C中的类变量，但他们有着以下的不同：
在OC或者C中，与某个类型相关的静态常量和静态变量，是作为全局静态变量来定义的。但是Swift中，类型属性是作为类型定义的一部分写在类型最外层的花括号内，因此它的作用范围也就在类型支持的范围内。
 
 Swift类型属性使用关键字static,下面是一个具体示例：
*/
Int.min //Int拥有min和max类型属性
Int.max

class Player {
    var name: String = ""
    //对象属性：本人的得分
    var score: Int = 0
    //类型属性：本游戏的最高得分,使用类名来访问，使用关键字static声明
    static var heighestScore:Int = 0;
    
    //构造方法
    init(name: String){
        self.name = name
    }
    //玩一句游戏得分
    func playGame(){
        let tempNum = Int(arc4random()%100)+1
        self.score += tempNum
        print("\(name) 的游戏得分是：\(score)")
        
        if(self.score > Player.heighestScore){
            Player.heighestScore = self.score
        }
        print("当前本游戏的最高分是:\(Player.heighestScore)")
    }
}

let player1 = Player(name: "zs")
player1.playGame()
player1.playGame()

let player2 = Player(name: "cf")
player2.playGame()
/*
 打印结果
 zs 的游戏得分是：11
 当前本游戏的最高分是:11
 zs 的游戏得分是：87
 当前本游戏的最高分是:87
 
 cf 的游戏得分是：88
 当前本游戏的最高分是:88
*/



//四、全局变量与局部变量
print("\n四、全局变量与局部变量")
/*
 全局变量：在函数、方法、闭包或者任意类型之外定义的变量
 局部变量：在函数、方法或者闭包内部定义的变量
 
 全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。
 局部范围的常量或变量从不延迟计算。
 */
