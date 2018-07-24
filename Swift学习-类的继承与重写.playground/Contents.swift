//: Playground - noun: a place where people can play

import UIKit



//================================================//
//=                                              =//
//=           ======Swift学习-类的继承=====       =//
//=                                              =//
//================================================//
//一个类可以继承另一个类的方法，属性和其它特性。当一个类继承其它类时，继承类叫子类，被继承类叫超类（或父类)。通过继承，子类可以调用、访问超类的方法、属性、下标，也可以重写父类的行为。

//一、基类与子类
/*
基类：
区别于Objective-C里的继承，Swift中的类并不是从一个通用的基类继承而来。如果你不为你定义的类指定一个超类的话，这个类就自动成为基类。换言之，不继承与其他类的类，就称之为基类，

子类：
子类生成指的是在一个已有类的基础上创建一个新的类。子类继承超类的特性，并且可以进一步完善。你还可以为子类添加新的特性。

 为了指明某个类的超类，将超类名写在子类名的后面，用冒号分隔。下面的示例演示了Vehicle类、Bicyclel类、Tandem类三者之间的继承：
*/
//车辆类
class Vehicle {
    var currentSpeed = 0.0
    
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    
    func makeNoise() {
        //什么也不做-因为车辆不一定会有噪音
    }
}

//自行车类
class Bicycle: Vehicle {
    //除了继承父类的属性外，还新定义了一个默认属性hasBasket
    var hasBasket = false
}

//串联双人自行车
class Tandem: Bicycle {
    //除了继承父类的属性外，还新定义了一个默认属性currentNumberOfPassengers
    var currentNumberOfPassengers = 0
}


let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
// 打印："Tandem: traveling at 22.0 miles per hour”

//上述代码中存在两种继承关系，即Bicycle继承于Vehicle,Tandem又继承于Bicycle。作为最后的继承，Tandem不仅拥有Bicycle中的新属性，也具有Vehicle中的属性。



//二、重写
/*
子类可以为继承来的实例方法，类方法，实例属性，或下标提供自己定制的实现。我们把这种行为叫重写。
重写涉及到两个关键字：override与super

override:
重写某个特性，需要在重写定义的前面加上override关键字，这样会提醒Swift编译器去检查该类的超类（或其中一个父类）是否有匹配重写版本的声明,从而确保重写定义是正确的。

super:
虽然是重写，但也有可能我们希望继续用到基类中原有实现，这时候我们需要通过super前缀来访问基类中的方法、属性或下标：
1.重写someMethod()方法，通过super.someMethod()来调用超类版本的someMethod()方法。
2.重写someProperty的 getter 或 setter实现，可以通过super.someProperty来访问超类版本的someProperty属性。
3.重写下标实现，可以通过super[someIndex]来访问超类版本中的相同下标。

 下面通过Train类，重写基类Vehicle类的方法与属性，具体代码如下：
*/
class Train: Vehicle {
    //重写属性
    //注意：不能将一个继承来的读写属性重写为一个只读属性
    override var description: String{
        return super.description + "---子类的描述"
    }
    
    //重写属性观察器
    //注意：不能为继承来的常量、只读计算型属性添加观察器
    override var currentSpeed: Double {
        didSet {
            print("重写了属性观察器，设置了新的currentSpeed")
        }
    }
    //重写方法
    override func makeNoise() {
        super.makeNoise()
        print("火车，呜呜呜。。。。")
    }
}

let train = Train()
train.currentSpeed = 100  //写了属性观察器，设置了新的currentSpeed
print(train.description)  //traveling at 0.0 miles per hour---子类的描述
train.makeNoise()         //火车，呜呜呜。。。。



//三、防止重写
/*
在某些情况下，我们不希望继承和重写，这就需要用到final关键字。
1.禁止类的继承
 在关键字class前添加final修饰符（final class），可以将整个类标记为final。这样的类是不可被继承的，试图继承这样的类会导致编译报错。

2.禁止属性方法重写
在声明的关键字前标记final修饰符，例如：final var，final func，f以及final subscript等，可以禁止子类对于基类方法，属性或下标的重写。在扩展里表标记同样适用
*/
















//暂时弃用的代码：学习视频代码

/*
//0角色
public class Avatar{
    var name :String
    var isAlive :Bool = true
    var avatarDesc:String{
        return "I am a Avatar, ,myName is \(name)"
    }
    var life  = 100{
        didSet{
            if self.life <= 0{
                self.isAlive = false
            }
            if self.life > 100{
                self.life = 100
            }
        }
    }
    
    //初始化
    init(name:String){
        self.name = name
    }
    
    //方法:，模拟被攻击
    func beAttacked(attack: Int){
        life -= attack
        if life <= 0{
            isAlive = false
        }
    }
}
//1.用户
public class User: Avatar{
    var score = 0
    //使用override重载了属性
    override var avatarDesc:String{
        return "I am a User, ,myName is \(name)"
    }
    //如果方法不想被覆写，需要使用final
}


//1.1魔术师
//final：防止被再次继承
public final class Magician: User{
    var magic  = 100
    override var avatarDesc:String{
        return "I am a Magician, ,myName is \(name)"
    }
    func addLife(user:User){
        user.life += 10
    }
}
//1.2战士
class Warrior: User{
    var weapon:String?
    
    override var avatarDesc:String{
        return "I am a Warrior, ,myName is \(name)"
    }
    
    //使用override重载方法
    //战士减少的血量少
    override func beAttacked(attack: Int) {
        self.life -= attack/2
    }
    
}
//2.怪兽
class Monster: Avatar {
    override var avatarDesc:String{
        return "I am a Monster, ,myName is \(name)"
    }
    
    func attack(user: User, amount:Int){
        user.beAttacked(amount)
    }
}
//2.1僵尸
final class Zombie: Monster{
    var type = "Default"
    override var avatarDesc:String{
        return "I am a Zombie, ,myName is \(name)"
    }
}
func printBasicInfo(avatar:Avatar){
    print("current avtar name is \(avatar.name)")
}

let player1 = Magician(name: "哈利波特")
let player2 = Warrior(name: "zhoushuai")
let zombie = Zombie(name: "default zombie")
let monster = Monster(name: "monster")
monster.attack(player1, amount: 10)
monster.attack(player2, amount: 10)
player1.life
player2.life
printBasicInfo(player2)
//同时都修改了血量值
let avatars: [Avatar] = [player1, player2, zombie, monster]
for avatar in avatars{
    avatar.life = 200
    print(avatar.avatarDesc)
}

*/



