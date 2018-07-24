//: Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"
//print("ok")


//================================================//
//=                                              =//
//=           ======Swift学习-协议=====           =//
//=                                              =//
//================================================//



//一、协议的基本语法
//协议是定义一些规范(属性、功能方法)，然后由类、结构体或者枚举遵循并实现这些规范，这一过程被称为遵循了协议。
//下面是协议的一些基本语法：
//1.定义一个协议
protocol SomeProtocol {
    //这里是协议的定义部分
}
protocol AnotherProtocol{
    //这里是协议的定义部分
}

//2.自定义类型遵循协议使用冒号，遵循多个协议时，各协议间使用逗号分隔
struct SomeStructure: SomeProtocol, AnotherProtocol {
    //这里是结构体的定义部分
}

//3.拥有父类的类在遵循协议时，需要将父类名放在协议名之前，以逗号分隔
class SomeClass: UIView, SomeProtocol, AnotherProtocol {
    //这里是类的定义部分
}




//二、定义协议与实现协议
/*
协议要求遵循协议的类型提供特定的属性、方法，构造器，使用协议的时候，我们还需要注意一些具体的使用规则。
属性要求：
1.协议可以定义实例属性和类型属性(使用static);
2.协议不指定属性是存储属性还是计算型属性，只指定属性名称和类型以及读写性;
3.协议指定属性的读取类型，使用的get和set，中间不能使用逗号；
4.协议总是使用var关键字来声明变量属性;
5.不能给协议属性设置默认值，因为默认值被看做是一种实现;

方法要求：
1.协议可以定义实例方法和类方法(使用static);
2.协议定义函数时不能添加函数的实现，同时，传入的参数也不能使用默认参数；
3.如果协议定义的实例方法会改变实例本身，需要在定义的方法名前使用mutating；这使得结构体和枚举能够遵循此协议并满足此方法要求。
*/

protocol  PersonProtocol{
    //1.定义属性
    static var personCount: Int {get}
    var name:String{
        get
        set
    }
    var nickName:String{get set} //要求可读可写，则该属性不能是常量属性或者只读的计算型属性
    var birthPlace:String{get}   //只要求可读，若代码需要，实现时也是可写的
    var age:Int{get}
    
    //2.定义函数
    static func play()
    func eat(food:String)
    //func fed(food:string = "defaultfood”) 错误，不能使用默认参数
    mutating func changeNickName(newName:String)
}


struct Student:PersonProtocol{
    static var personCount = 0         //类属性
    var name: String = ""
    var nickName: String = ""          //这种形式的声明就代表可读可写
    let birthPlace: String = "beijing" //将只读属性设置为let，在合适位置给其设置默认值就好了
    var age:Int = 10
    //其实，只读类型的属性也可以设置为var,这相当于是对其进行扩展，不仅遵循了原来的get，还增加了set
    
    static func play() {
        //类方法
    }
    
    func eat(food: String) {
        //普通实例方法
    }
    
    mutating func changeNickName(newName: String) {
        //实例方法中修改了实例属性
        self.nickName = newName
    }
}

var student:Student = Student()
student.age = 18
var stu:PersonProtocol = student //这里协议也当做了一种类型来使用，但是具体的实现还是是Dog完成的
//stu.age = 10 //这里报错，因为协议中的age是只读的

//注意：实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字。




//三、协议与构造器
/*
这里主要总结协议在定义构造器时候的一些要求，主要有如下几个方面：
1.协议中可设置指定或者便利构造器,实现时都需要添加required修饰符,因为这样可以确保所有子类也必须提供此构造器，从而符合协议，但是如果为final类，就不需要;
2.如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注 required 和 override 修饰符；
3.协议中可定义可失败构造器(init?)、非可失败构造器(init)、隐式解包可失败构造器(init!);
*/

protocol Protocol {
    init()
}

class SomeSuperClass {
    init() {
        // 这里是构造器的实现部分
    }
}

class SomeSubClass: SomeSuperClass, Protocol {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
        // 这里是构造器的实现部分
    }
}




//四、协议作为类型
/*
协议虽本身并未实现任何功能，但是仍然可以像其他普通类型一样使用,如Int、Double等。协议作为类型使用的场景如下：
作为函数、方法或构造器中的参数类型或返回值类型;
作为常量、变量或属性的类型;
作为数组、字典或其他容器中的元素类型;
*/
//协议：定义了生成随机数方法
protocol RandomNumberGenerator {
    func random() -> Double
}

//实现了RandomNumberGenerator协议的类
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        //使用truncatingRemainder方法进行浮点数取余
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m)
        return lastRandom / m
    }
}

//Dice的generator属性，其类型是RandomNumberGenerator协议类型
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator    //协议作为属性
    
    //协议作为参数类型
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}

//Random dice roll is 3
//Random dice roll is 5
//Random dice roll is 4
//Random dice roll is 5
//Random dice roll is 4

print("hello")




//五、协议实现委托代理模式
/*
委托是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。委托模式可以用来响应特定的动作,
 或者接收外部数据源提供的数据，而无需关心外部数据源的类型。
委托模式的原理：定义协议来封装那些需要被委托的功能，这样就能确保遵循协议的类型能提供这些功能。
*/

//播放音乐的协议
protocol PlayMusicTools{
    func playMusic();
}

//实现协议的类
class QQMusisApp:PlayMusicTools{
    func playMusic() {
        print("播放一首美妙的音乐")
    }
}


class Person{
    var delegate:PlayMusicTools?
    func listenMusic(){
        self.delegate?.playMusic()
    }
}
//人想听音乐但是又不能自己播放，就调用了代理的方法
let person:Person = Person()
person.delegate = QQMusisApp()
person.listenMusic()



//六、通过扩展遵循协议
/*
我们知道，扩展可以为已有类型添加属性、方法、下标以及构造器。同样道理，我们也可以通过扩展为已有类型实现需要遵循的协议，通过这种方法与在原始定义中遵循并实现协议效果完全相同。
*/
//1.通过扩展实现协议
//协议：定义一个可以打印UIView属性fame的方法
protocol ViewProperty{
    func printFrame()
}

//通过扩展为UIView实现了ViewProperty协议
extension UIView:ViewProperty{
    func printFrame() {
        print(self.frame)
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
view.printFrame()


//2.已经符合协议的类
//如果一个类型已经符合了某个协议的所有要求，却还没有声明遵循这个协议，那么可以通过空扩展来遵循协议。
class CustomObject{
    func printFrame() {
        print("this is not a view，cant print frame")
    }
}
//空扩展表示遵循协议
extension CustomObject:ViewProperty{}
//遵循了协议之后，就可以使用协议作为类型
let customOject:ViewProperty = CustomObject()
customOject.printFrame()




//七、协议类型的集合
//协议类型可以在数组或者字典这样的集合中使用；如下，等号左边的数组表示遵循了ViewProperty协议的对象构成的数组。
let things:[ViewProperty] = [view,customOject]
for thing in things{
    thing.printFrame()
}
//打印结果：
//(0.0, 0.0, 100.0, 100.0)
//this is not a view，cant print frame





//八、协议继承协议
/*
协议继承协议具有以下特点：
1.协议能够继承一个或多个其他协议，可以在继承的协议的基础上增加新的要求。
2.协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔：
3.所有遵循新协议的类型，也同时满足新协议所继承的父协议
协议继承协议的格式如下：
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // 这里是协议的定义部分
}
*/




//九、类类型专属协议
/*
协议的继承列表中，通过添加 class 关键字来限制协议只能被类类型遵循，而结构体或枚举不能遵循该协议。class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前。
protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol {
    // 这里是类类型专属协议的定义部分
    //class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前
}
*/




//十、协议合成
/*
有时候需要同时遵循多个协议，你可以将多个协议采用SomeProtocol & AnotherProtocol这样的格式进行组合，称为协议合成(protocol composition)；你可以罗列任意多个你想要遵循的协议，以与符号(&)分隔。

*/
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

//Person遵循两个协议
struct Person1: Named, Aged {
    var name: String
    var age: Int
}

//函数参数celebrator的类型为 Name & Aged；
//这意味着它不关心参数的具体类型，只要参数符合这两个协议即可；
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person1(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)      //打印 “Happy birthday Malcolm - you're 21!”

//注意：协议合成并不会生成新的、永久的协议类型，而是将多个协议中的要求合成到一个只在局部作用域有效的临时协议中




//十一、检查协议的一致性
/*
类型转换中描述的is和as操作符同样可以用来检查协议一致性，即是否符合某协议，并且可以转换到指定的协议类型。检查和转换到某个协议类型在语法上和类型的检查和转换完全相同：
is 用来检查实例是否符合某个协议，若符合则返回 true，否则返回 false。
as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil。
as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
 */
//定义协议：定义一个Double类型的可读属性area
protocol HasArea {
    var area: Double { get }
}

//Circle类和Country类遵循协议HasArea
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius } //计算型
    init(radius: Double) { self.radius = radius }
}

class Country: HasArea {
    var area: Double //存储型
    init(area: Double) { self.area = area }
}

//Animal未遵循协议
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

//迭代测试，并检测协议
for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
// Area is 12.5663708
// Area is 243610.0
// Something that doesn't have an area”


//十二、协议的可选性
/*
协议可以定义可选要求，即遵循协议的类型可以选择是否实现这些要求。
1.在协议中使用optional关键字作为前缀来定义可选要求。
2.可选要求用在你需要和Objective-C打交道的代码中。协议和可选要求都必须带上@objc属性。
3.标记@objc特性的协议只能被继承自Objective-C类的类或者@objc类遵循，其他类以及结构体和枚举均不能遵循这种协议。
4.协议中的可选要求可通过可选链式调用来使用，因为遵循协议的类型可能没有实现这些可选要求

*/

//下面的例子定义了一个名为Counter的用于整数计数的类，它使用外部的数据源来提供每次的增量。数据源由CounterDataSource 协议定义，

//1.协议CounterDataSource包含两个可选要求
@objc protocol CounterDataSource {
    @objc optional func incrementForCount(count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

//2.Counter类含有CounterDataSource?类型的可选属性dataSource
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    
    func increment() {
        if let amount = dataSource?.incrementForCount?(count: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
             //通过可选链调用，每次使用的是fixedIncrement的3
            count += amount
        }
    }
}

//3.ThreeSource类遵循了CounterDataSource协议
//它实现了可选属性fixedIncrement，而并未实现incrementForCount方法
class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

//4.使用ThreeSource实例作为Counter实例的数据源对象
var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

//测试结果：
//3
//6
//9
//12



//十三、协议扩展
/*
协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数。
*/
//协议：定义random函数生成随机数方法
protocol RandomNumProtocol {
    func random() -> Double
}

//扩展RandomNumProtocol协议，增加了randomBool方法
//注意：通过协议扩展，所有遵循协议的类型都能自动获得这个扩展所增加的方法实现，无需任何额外修改
extension RandomNumProtocol {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

//遵循协议的类：一个实现了RandomNumProtocol协议的类
//RandomNum类只实现了协议方法random()，但是同样可以使用协议扩展里的方法randomBool()
class RandomNum: RandomNumProtocol {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        //使用truncatingRemainder方法进行浮点数取余
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m)
        return lastRandom / m
    }
}

//测试代码：
let generator = RandomNum()
print("Here's a random number: \(generator.random())")
//打印：Here's a random number: 0.37464991998171
print("And here's a random Boolean: \(generator.randomBool())")
//打印：And here's a random Boolean: true



//1.提供默认实现
/*
可以通过协议扩展来为协议要求的属性、方法以及下标提供默认的实现。但是，如果遵循协议的类型也为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。
注意：通过协议扩展为协议要求提供的默认实现，这和可选的协议要求不同；虽然在这两种情况下，遵循协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用。
 */

//协议：定义宠物协议，有一个发出声音的方法
protocol PetProtocol{
    func makeSound()
}

//扩展协议：提供默认方法
extension PetProtocol{
    func makeSound(){
        print("aaaaaa。。。。")
    }
}

class Cat:PetProtocol{
     //因为有协议扩展，提供了默认的方法实现；所以这里只遵循了协议
}

class Dog:PetProtocol{
    func makeSound() {
        print("汪汪汪。。。。")
    }
}

//测试代码：
let cat = Cat();
cat.makeSound();  //打印：aaaaaa。。。。
let dog = Dog();
dog.makeSound()   //打印：汪汪汪。。。。


//2.为协议扩展添加限制条件
/*
在扩展协议的时候，可以指定一些限制条件，只有遵循协议的类型满足这些限制条件时，才能获得协议扩展提供的默认实现。这些限制条件写在协议名之后，使用 where子句来描述
*/
//例如，你可以扩展Collection协议，适用于集合中的元素遵循了Equatable协议的情况。通过限制集合元素遵循Equatable 协议， 作为标准库的一部分，你可以使用==和!=操作符来检查两个元素的等价性和非等价性。
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

//如果集合中的所有元素都一致，allEqual()方法才返回 true
let equalNumbers = [100, 100, 100, 100, 100]
print(equalNumbers.allEqual())      //打印 "true"
let differentNumbers = [100, 100, 200, 100, 200]
print(differentNumbers.allEqual())  //打印 "false"

//注意：如果一个遵循的类型满足了为同一方法或属性提供实现的多个限制型扩展的要求， Swift 使用这个实现方法去匹配那个最特殊的限制。




