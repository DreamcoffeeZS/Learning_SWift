//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//================================================//
//=                                              =//
//=           ======Swift学习-泛型======       =//
//=                                              =//
//================================================//




//一、泛型解决的问题
/*
泛型代码让你能够根据自定义的需求，编写出适用于任意类型、灵活可重用的函数及类型。它能让你避免代码的重复，用一种清晰和抽象的方式来表达代码的意图。
这种说法很模糊，下面结合一个实例来理解泛型解决的问题。
*/
//需求描述：使用函数来交换两个变量的值
//互换两个整型
func swapTwoInt(a:inout Int , b:inout Int){
    (a, b) = (b, a)
}

//互换两个Double
func swapTwoDouble(a:inout Double, b:inout Double){
    (a,b) = (b,a)
}

/*
代码分析：
 swapTwoInt与swapTwoDouble两个函数功能相同，唯一的区别就是传入的变量类型不同。
 这样的代码看起来重复又累赘。在实际应用中，通常需要一个更实用更灵活的函数来交换两个任意类型的值，
 幸运的是，泛型代码帮你解决了这种问题。
*/




//二、泛型函数
/*
//泛型函数可以适用于任何类型，下面的swapTwoValues(_:_:) 函数是上面两个个函数的泛型版本,可以交换任意类型的两个变量
*/
//尖括号里声明一种通用类型T，参数列表里可以使用这种类型名表示通用类型
func SwapTwoThing<T>(a:inout T, b:inout T){
    (a, b) = (b, a)
}

var a = 100
var b = 200
swapTwoInt(a: &a , b: &b)
a  //200
b  //100

var string1 = "hello"
var string2 = "world"
SwapTwoThing(a: &string1, b: &string2)
string1  //world
string2  //hello

/*
总结泛型用法：
1.使用了占位类型名(T)，来替换实际类型名(Int，Double)；
2.占位类型符并不指定T必须是什么类型，但是却限制了参数a和b必须是同一种类型T；
3.只有SwapTwoValues<T>(_:_)函数在调用时，才能根据所传入的实际类型决定T所代表的类型；
4.T只是一个符号，可以使用大写字母开头的驼峰命名法（例如T和MyTypeParameter)来为类型参数命名，以表明它们是占位类型，而不是一个值。
*/




//三、泛型类型
//1.系统类型使用到的泛型
/*
事实上，泛型的使用贯穿了Swift语言，只是我们可能没有发现而已。例如，Swift的Array和Dictionary都是泛型集合。你可以创建一个Int数组，也可创建一个String数组
*/
let arr = Array<Int>()
let dict = Dictionary<String,Int>()
let set  = Set<Float>()


//2.自定义泛型类型：实现栈
/*
除了泛型函数，Swift还允许你定义泛型类型；这些自定义类、结构体和枚举可以适用于任何类型，类似于Array和 Dictionary。下面的示例就是创建一个具有栈功能的结构体，适用于各种类型。
 */
struct Stack<Element>{
    //存放栈中变量的数组
    var items = Array<Element>()
    
    //入栈：向栈中添加一个新元素
    mutating func push(item:Element){
        items.append(item)
    }
    
    //出栈：删除栈顶元素,并返回此元素
    mutating func pop() ->Element?{
        return items.removeLast()
    }
}

var stack = Stack<Int>()
stack.push(item: 11)
stack.push(item: 22)
stack.pop()   //22
var stack1 = Stack<String>()
stack1.push(item:"aaa")
stack1.push(item:"bbb")
stack1.pop()  //"bbb"


//3.自定义泛型类型：多占位符
//自定义泛型类型可以设置多个类型占位符，下面就是自定义了一个泛型类型Pair，它具有两个占位类型符。
struct Pair<T1, T2>{
    var t1:T1
    var t2:T2
}

var pair1 = Pair(t1: "hello", t2: "hi")
print(pair1)   //Pair<String, String>(t1: "hello", t2: "hi")

var pair2:Pair<String, Int> = Pair(t1:"hello",t2: 123)
print(pair2)   //Pair<String, Int>(t1: "hello", t2: 123)






//四、扩展一个泛型类型
/*
 扩展一个泛型类型，可以直接使用原始类型定义中声明的类型参数列表，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。
 比如，我们现在扩展泛型类型Stack，为其添加计算型属性，用于获取栈顶元素，代码示例如下：
*/
extension Stack {
    //返回当前栈顶元素而不会将其从栈中移除
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
var stack3 = Stack<Int>()
stack3.push(item:1)
stack3.push(item:2)
stack3.push(item: 3)
if let topItem = stack3.topItem{
    print("栈顶元素:\(topItem)")   //栈顶元素:3
}

//注意：扩展中的占位类型符需要与原始类保持一致，所以这里用的还是Element。




//五、泛型的类型约束
/*
swapTwoValues(_:_:)函数和Stack类型可以作用于任何类型。但如果可以为泛型函数和泛型类型的类型添加一个特定的类型约束，将会是非常有用的。
 通常情况下，我们设置泛型类型约束的时候，会指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合。

*/
//1.类型约束语法
//对泛型函数添加类型约束的基本语法如下所示(作用于泛型类型时的语法与之相同)。
/*
//在一个类型参数名后面放置一个类名或者协议名，并用冒号进行分隔，来定义类型约束
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // 这里是泛型函数的函数体部分
}
*/

//2.泛型类型约束实践
/*
下面的泛型函数用于查找数组中某个元素的索引位置；但由于for循环里用到了对象比较"=="，要确保所有的类型都适用，所以在泛型函数的中添加了类型约束，使用此泛型函数的参数必须遵循Equatable协议。
*/
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])  //nil
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"]) //2

//注意：Swift标准库定义了Equatable协议，该协议要求任何遵循该协议的类型必须实现等式符（==）及不等符(!=)。从而能对该类型的任意两个值进行比较。所有的Swift标准类型自动支持 Equatable 协议





//六、关联类型
/*
关联类型是在为协议中的某个类型提供一个占位名，其所代表的实际类型会在协议被实现时才会被指定。这里涉及到两个关键字，其作用就是给一个类型起一个别名，首先来说明一下：
associatedtype（协议声明中使用）
typealias     （协议实现中使用）
*/
//下面通过一个示例来理解关联类型的作用：

//示例1：
//协议：可称重的协议，其中使用了泛型关联类型
//这种方式可以更大程度的使用协议，具体实现协议的时候再决定类型
protocol WeightCaclulable{
    //associatedtype设置别名，即关联类型
    associatedtype WeightType
    var weight:WeightType{get} //返回重量属性，其类型是WeightType
}

//iphone7:手机较轻，表示重量时会有小数点，所以使用Double描述
class Iphone7:WeightCaclulable{
    //实现的时候用的是typealias
    typealias WeightType  = Double
    
    var weight: Double {
        return 0.114
    }
}

//Ship:轮船较重,表示重量可以忽略小数，所以使用Int描述
class Ship:WeightCaclulable{
    typealias WeightType = Int
    var weight: WeightType
    
    init(weight:WeightType) {
        self.weight = weight
    }
}

let iphone7 = Iphone7()
print(iphone7.weight)  //0.114

let ship = Ship(weight: 100000)
print(ship.weight)     //100000


//示例2：
//下面例子定义了一个 Container 协议，该协议定义了一个关联类型 ItemType：
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
/*
代码分析：
Container协议使用了类型关联，这样就限制了遵循此协议的类型,其中的操作必须符合如下要求：
1.必须可以通过append(_:) 方法添加一个新元素到容器里。
2.必须可以通过count属性获取容器中元素的数量，并返回一个Int值。
3.必须可以通过索引值类型为Int的下标检索到容器中的每一个元素。
*/

struct NewStack<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}


//七、为关联类型添加约束
//协议中存在关联类型，我们也可以为其添加约束，下面是一个Container协议，我们设置其关联类型Item遵循了协议Equatable，具体代码如下：
protocol Container1 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}




//八、










//一、理解inout
/*
 在Swift中，常用的字符串、数组和字典，由OC中的NSString、NSArray和NSDictionary转变为了Swift中的String、Array和Dictionary。OC中的这几个数据类型都属于类，Swift中的这几个数据类型是结构体。Swift的数据类型相对OC来说更安全，运行速度更快，但是也会造成一些问题。我遇到的最大的问题就是结构体类型的数据在当做参数时是值传递，而不是指针传递，这样的话我就不能做到在方法内改变对象的值同时改变原对象的值。而OC的类由于是指针传递，可以很方便的实现这个效果。
 所以，如果我们有指针传递的需求，有两种方法:
 方法一：在需要使用指针传递的地方使用OC的类，这个也是最容易想到的方法；
 
 方法二：使用关键字 inout，声明参数为指针。
 */



