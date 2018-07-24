//: Playground - noun: a place where people can play

import UIKit


//================================================//
//=                                              =//
//=           ======Swift学习-函数=====           =//
//=                                              =//
//================================================//
/*
 函数是一段完成特定任务的独立代码片段。
*/

//一、函数的定义与调用
print("\n一、函数的定义与调用")

func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
print(greet(person: "Anna"))         // 打印 "Hello, Anna!”


func greetAgain(person: String) -> String {
    return "Hello again, " + person + "!"
}
print(greetAgain(person: "Anna"))    // 打印 "Hello again, Anna!”




//二、函数参数与返回值
print("\n二、函数参数与返回值")
//2.1.无参，有返回值函数
func sayHi() -> String {
    return "Hi！"
}
print(sayHi())

//2.2.多参，有返回值函数
func sayHi(person: String, greet: String) -> String {
    let greetString = greet  + person
    return greetString
}
print(sayHi(person: "zhoushuai", greet: "Hi！"))

//2.3.无返回值函数
/*严格意义上，虽然没有返回值，但是sayHello函数依然返回了值。没有定义返回类型的函数会返回一个特殊的Void值。它其实是一个空的元组(tuple)，没有任何元素，可以写成()
*/
func sayHi(person: String) {
    print("Hi-Hi, \(person)!")
}
sayHi(person: "Tom")
//打印 "Hi-Hi, Tom!"


//sayHello函数与下面的两个函数，会被Swift识别为同一种函数，进而报错重复定义。
/*
func sayHi(person: String) ->(){
    print("Hello, \(person)!")
}

func sayHi(person: String) ->Void {
    print("Hello, \(person)!")
}
*/

//2.4多重返回值函数
//可以用元组（tuple）类型让多个值作为一个复合值从函数中返回,即返回多个参数
func findMaxMin(array:[Int]) ->(max:Int,min:Int){
    let max = array.max()
    let min = array.min()
    return (max!,min!)
}
let bounds = findMaxMin(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")
// 打印 "min is -6 and max is 109


//2.5可选返回值类型
func findMaxMin2(array:[Int]) ->(max:Int,min:Int)?{
    guard !array.isEmpty else{
        return nil
    }
    
    var maxVlaue = array[0]
    var minValue = array[0]
    for number in array{
        maxVlaue = maxVlaue > number ? maxVlaue : number
        minValue = minValue < number ? minValue : number
    }
    //返回的类型是可选型，因为结果有可能是nil
    return (maxVlaue, minValue)
}
if let bounds2 = findMaxMin2(array: [1, 2, 3, 4, 5, 6]){
    print("min is \(bounds2.min) and max is \(bounds2.max)")
}

//注意：可选元组类型如 (Int, Int)? 与元组包含可选类型如 (Int?, Int?) 是不同的.可选的元组类型，整个元组是可选的，而不只是元组中的每个元素值。


//2.6无参，无返回值函数
func sayHiHi(){
    print("sayHiHi:无参五返回值的函数！")
}

sayHiHi()





//三、函数外部参数名和参数名称
print("\n三、函数外部参数名和参数名称")
//每个函数参数都有一个外部参数名(参数标签)以及参数名称，只不过默认情况下，函数参数直接使用参数名来作为它们的外部参数名。下面来总结函数外部参数名的各种用法。
//3.1.指定外部参数名，让函数表意更明确
//函数外部参数名的使用能够让一个函数在调用时更有表达力，更类似自然语言，并且仍保持了函数内部的可读性以及清晰的意图。
//正常写法：
func sayHelloTo(name: String , greeting: String) -> String{
    return "\(greeting), \(name)!"
}
print(sayHelloTo(name: "风恣", greeting: "Hello"))
//打印："Hello，风恣！"

//改进上面的函数，为第二个参数指定外部参数名，让表意更加明确
func sayHelloTo(name: String, withGreetingWord greeting:String) -> String{
    return "\(greeting),\(name)"
}
print(sayHelloTo(name: "FengZi", withGreetingWord: "Hello"))
//打印："Hello，FengZi"

//特别说明：
//一般情况下，第一个参数不设置外部参数名，因为第一个参数的外部参数名是隐藏在函数名中的

//3.2.忽略参数标签
//有时候，使用外部参数名反而会使函数更加繁琐，这就需要隐藏外部参数名：使用下划线"_"来代替一个明确的参数标签。
//正常写法：
func mutipleOf(num1: Int, and num2:Int)-> Int{
    return num1 * num2
}
mutipleOf(num1: 1, and: 6)    //6

//改进1：忽略参数标签
func  mutipleOf(num1:Int , num2:Int) -> Int{
    return num1 * num2;
}
mutipleOf(num1: 1, num2: 6)   //6

//改进2:彻底不使用参数名,使用下划线省略
func mutiply(_ num1:Int, _ num2:Int) -> Int{
    return num1 * num2
}
mutiply(1, 6)                //6







//四、默认参数
print("\n四、默认参数")
/*
定义函数的时候，可以给某些参数设置默认值(Deafult Value)，当默认值被定义后，调用这个函数时可以忽略这个参数。
*/
//1.设置默认参数
//下面的函数包括两个默认参数，而且设置的默认参数都要在非默认参数后面。
func playMusic(name: String, instrument:String = "drum", sound:String = "咚咚咚。。。") -> String{
    let scene = name + " play the " + instrument + "," + sound;
    print(scene)
    return scene;
}

//使用了默认参数的参数, 相关的默认参数可以不用传值
playMusic(name: "zhoushuai")
//对于默认参数，可以有选择的传入值
playMusic(name: "zhoushuai", instrument: "panio")
playMusic(name: "zhoushuai", instrument: "panio" ,sound: "lingling~")

//测试打印：
//zhoushuai play the drum,咚咚咚。。。
//zhoushuai play the panio,咚咚咚。。。
//zhoushuai play the panio,lingling~

//默认参数的位置可以调换,因为有外部参数名
//sayHelloTo(name: "zhoshuai", punctuation: "!!!", withGreetingWord: "大家好！")






//五、可变参数
print("\n五、可变参数")
//一个可变参数可以接受零个或多个值。函数调用时，你可以用可变参数来指定函数参数传入不确定数量的输入值。通过在变量类型名后面加入（...）的方式来定义可变参数。下面的算术平均函数演示了可变参数的用法：
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// 返回 3.0, 是这 5 个数的平均数。
arithmeticMean(3, 8.25, 18.75)
// 返回 10.0, 是这 3 个数的平均数。”

//注意：一个函数只能拥有一个可变函数





//六、输入输出参数
print("\n六、输入输出参数")
//函数参数默认是常量形参，所以我们在函数中对其修改都不会对参数的原值产生影响。为了解决这个问题，我们可以将这些需要修改的参数定义为输入输出参数。
var somInt = 10;
//普通函数:报错，因为num是常量，不能被再次修改
/*
func modifyNum(num:Int){
    num = num * 2;
}
*/

//带有输入输出函数的函数
func modifyNum2(num:inout Int){
    num = num * 2
}

modifyNum2(num: &somInt)
print(somInt)           //20，someIn被修改

//注意：
//1.只能传递变量给输入输出参数，而不能是常量或者字面量，因为这些量是不能被修改的；
//2.传入参数作为输入输出参数时，需要在参数名前添加&符号，表示这个值可以被修改；





//七、函数类型
print("\n七、函数类型")
//如同参数有整型，布尔型等参数类型一样，每个函数都有种特定的函数类型。函数的类型由函数的参数类型和返回值类型组成。下面举例说明：
//1.以下两个函数具有相同的函数类型：（Int,Int）->Int
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

//2.没有参数也没有返回值的函数类型：()->Void
func printHelloWorld() {
    print("hello, world")
}


//3.使用函数类型
//3.1定义一个函数类型的变量或常量，然后可以使用适当函数的为其赋值
//下面的mathFunction变量，经过赋值之后，指向了addTwoInts函数，所以它也可以当做addTwoInts函数使用
var mathFunction:(Int,Int)->Int = addTwoInts

//赋值了加法函数：addTwoInts
print(mathFunction(3,4))         //7
//赋值了乘法函数：multiplyTwoInts
mathFunction = multiplyTwoInts;
print(mathFunction(3,4))         //12

//3.2函数类型做为参数类型
//函数类型也可以作为另一个函数的参数类型，这样我们就可以将函数的一部分实现留给函数的调用者来提供。
//测试1：
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)       //打印 "Result: 8”
printMathResult(multiplyTwoInts, 3, 5)  //打印："Result: 15"

//测试2：
//生成随机数组成的数组
var array: [Int] = []
for _ in 0..<6{
    let max=20
    let randNum0=arc4random()%UInt32(max)
    let randNum1=Int(randNum0)
    if(array.contains(randNum1)){
        continue;
    }
    array.append(randNum1)
}
print(array)       //[12, 9, 19, 13, 3]
//1.排序array：从小到大
array.sort()
print(array)      //[3, 9, 12, 13, 19]
//2.排序array,并返回一个新的排序的数组
array.sorted()
print(array)      //[3, 9, 12, 13, 19]

//自定义排序方法1：从大到小排序
func biggerNumFirst(num1:Int, num2:Int) -> Bool{
    return num1 > num2
}
//自定义排序方法2：将数字转化为字符串， 按照字符换的字典排序
func compareByNumberString(num1: Int, num2: Int) ->Bool{
    return String(num1) > String(num2)
}
//自定义排序方法3：距离某个数字最近
func nearTo10(num1: Int, num2: Int) ->Bool{
    return abs(num1 - 10) < abs(num2 - 10) ? true :false
}
array.sort(by: biggerNumFirst(num1:num2:))
array.sort(by: compareByNumberString)
array.sort(by: nearTo10)
//测试打印:
//[19, 13, 12, 9, 3]
//[9, 3, 19, 13, 12]
//[9, 12, 13, 3, 19]



//3.3函数类型作为返回值类型
//你可以用函数类型作为另一个函数的返回类型。你需要做的是在返回箭头（->）后写一个完整的函数类型。
func getMathFunction(symbol: String)->(Int,Int)->Int{
    if symbol == "*" {
        return multiplyTwoInts;
    }else{
        return addTwoInts
    }
}
//传入不同的字符串参数，会返回不同的函数
var function = getMathFunction(symbol: "*")
function(1,2)    //2
function = getMathFunction(symbol: "abcdefg")
function(1,2)    //3





//八、嵌套函数
print("\n八、嵌套函数")
//通常，我们见到的都是全局函数，即定义在全局域中的函数。我们也可以把函数定义在别的函数体中，称作嵌套函数。
func getMathFunction2(symbol: String)->(Int,Int)->Int{
    func mathFunc1(a:Int,b:Int)->Int{
        return a - b
    }
    
    func mathFunc2(a: Int, b: Int) -> Int{
        return a * b
    }
    
    if symbol == "*" {
        return mathFunc2;
    }else{
        return mathFunc1;
    }
}
var method = getMathFunction2(symbol: "*")
method(5,6)     //30

method = getMathFunction2(symbol: "123123")
method(5,6)     //-1




 







