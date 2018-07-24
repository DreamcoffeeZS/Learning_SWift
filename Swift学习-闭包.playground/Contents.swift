//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//================================================//
//=                                              =//
//=           ======Swift学习-闭包======       =//
//=                                              =//
//================================================//
/*
 闭包是自包含的函数代码块，可以在代码中被传递和使用。Swift中的闭包与C和 Objective-C中的代码块(blocks)以及其他一些编程语言中的匿名函数比较相似。
Swift闭包的三种存在形式：
 1.全局函数是一个有名字但不会捕获任何值的闭包
 2.嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
 3.闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包
*/

//一、闭包表达式
//闭包表达式的语法一般有如下的一般形式：
/*
{ (parameters) -> returnType in
        statements
}
 */
/*
说明:
1.闭包的外层是一个大括号，先写的参数和返回值，然后操作部分之前使用in；
2.闭包就相当于OC中的block, 也可以看做是匿名函数；
3.闭包表达式参数可以是in-out参数，但不能设定默认值；
4.闭包的函数体部分由关键字in引入，该关键字表示闭包参数和返回值类型已经完成，闭包函数体开始；
*/


//二、闭包的使用与优化
print("二、闭包的使用")
//下面，我们使用Swift标准库中的sorted(by:)方法来测试闭包的使用。sorted(by:)方法允许外部传入一个用于排序的闭包函数将已知类型数组中的值进行排序，完成排序之后，该方法会返回一个与原数组大小相同，包含同类型元素已正确排序的新数组。

//定义一个整型数组
var someInts: [Int] = [5,9,7,0,1,3]
//定义一个排序函数
func biggerNumFirst(num1:Int, num2:Int) -> Bool{
    return num1 > num2
}

//普通用法：将biggerNumFirst函数传入sorted函数，实现排序
var sortInts = someInts.sorted(by: biggerNumFirst)
print(sortInts)   //[9, 7, 5, 3, 1, 0]


//现在，我们使用闭包来实现上述功能，为sorted函数参数传入一个闭包：
sortInts = someInts.sorted(by:{ (a:Int, b:Int) -> Bool in
    return a > b
})
print(sortInts)    //[9, 7, 5, 3, 1, 0]
//注意：因为闭包不会在其他地方调用，所以不使用外部参数名


//优化闭包1：根据上下文推断类型，省略参数类型与括号
/*
由于排序闭包函数是作为sorted(by:)方法的参数传入的，Swift可以推断其类型和返回值类型。所以sorted(by:)方法被一个Int类型的数组调用，其参数必定是(Int,Int)->Bool类型的函数。最后，根据上下文推断类型，我们可以省略参数类型和参数周围的括号。
*/
sortInts = someInts.sorted(by: {a,b in
    return a > b
})
print(sortInts)

//优化闭包2：对于不会发生歧义的闭包，可将其写成一行
sortInts = someInts.sorted(by:{a,b in return a > b})
print(sortInts)

//优化闭包3：单行闭包表达式，省略return关键字
//省略return关键字的条件：
//sorted(by:)方法的参数类型明确了闭包必须返回一个Bool类型值
//单行闭包表达式中，其返回值类型没有歧义
sortInts = someInts.sorted(by: {a,b in a > b})
print(sortInts)

//改进闭包4：使用参数名缩写；不推荐使用
/*
 Swift 自动为内联闭包提供了参数名称缩写功能，你可以直接通过 $0，$1，$2 来顺序调用闭包的参数，以此类推。
 
 如果我们在闭包表达式中使用参数名称缩写， 我们就可以在闭包定义中省略参数列表，并且对应参数名称缩写的类型会通过函数类型进行推断。in关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构成：
*/
sortInts = someInts.sorted(by: {$0>$1})
print(sortInts)

//优化闭包5：使用运算符简化闭包；不推荐使用
/*
Swift的Int类型定义了关于大于号（>）的字符串实现，其作为一个函数接受两个Int类型的参数并返回Bool类型的值。而这正好与sorted(by:)方法的参数需要的函数类型相符合。可以使用大于号来代替闭包
*/
sortInts = someInts.sorted(by: >)
print(sortInts)

//优化闭包6：尾随闭包，解决长闭包的书写问题
/*
 如果你需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性。
 尾随闭包的写法：将闭包书写在函数括号之后，函数会支持将其作为最后一个参数调用，使用尾随闭包，不需要写出它的参数标签。
*/
func someFunctionThatTakesAClosure(closure: () -> Void) {
    //函数体部分
    closure(); //调用闭包
}

//不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure(closure: {
    //闭包主体部分
})

//使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    //闭包主体部分
}

//注意：如果闭包表达式是函数或方法的唯一参数，则当你使用尾随闭包时，你甚至可以把 () 省略掉：
someFunctionThatTakesAClosure {
    print("Hello World!")    //打印：Hello World!
}

/*
 实际上，通过内联闭包表达式构造的闭包作为参数传递给函数或方法时，
 总是能够推断出闭包的参数和返回值类型。这意味着闭包作为函数或者方法的参数时，
 你几乎不需要利用完整格式构造内联闭包。
 
 最后总结：
 Swift闭包主要的四种优化方法：
 1.利用上下文推断参数和返回值类型，省略参数类型与括号
 2.隐式返回单表达式闭包，即单表达式闭包可以省略return关键字
 3.参数名称缩写
 4.尾随闭包语法
*/


//三、值捕获
print("三、闭包值捕获")
/*
 闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。Swift会为你管理在捕获过程中涉及到的所有内存操作。
*/
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
/*
 代码分析：
1.makeIncrementer函数以amount为参数，以()->Int作为返回值类型，其函数体中还嵌套了另一个函数incrementer。
2.如果我们把incrementer单独拿出来，会发现其中runingTotal和amount变量都无法使用，因为这两个变量的引用是incrementer从外部捕获的。
3.Swift会负责被捕获变量的所有内存管理工作，包括对捕获的一份值拷贝，也包括释放不再需要的变量。
 */



//现在来测试makeIncrementer函数的使用
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen();    //10
incrementByTen();    //20

let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()   //7
incrementBySeven();  //14

let alsoIncrementByTen = incrementByTen
alsoIncrementByTen() //30

/*
代码分析:
1.incrementByTen与incrementBySeven，是通过makeIncrementer函数传入不同的增量参数amount而创建的；
2.两个函数都有属于各自的引用，其中的runningTotal变量都是从makeIncrementer中捕获的，但是已经各自没有关系；
3.函数和闭包都是引用类型，将其赋值给变量或者常量，都只是操作的它们的引用，而不会改变闭包或者函数本身；
*/





//四、逃逸闭包
print("四、逃逸闭包")
/*
4.1.逃逸闭包
 逃逸：当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。
 逃逸闭包：
 在定义接受闭包作为参数的函数时，我们需要在参数名之前标注@escaping,以此表明这个闭包是允许"逃逸"出这个函数的。
 */

var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    //代码1：执行闭包，不需要添加@escaping
    //completionHandler();
    //代码2：函数外部对闭包进行了操作
    completionHandlers.append(completionHandler)
 }

/*
代码分析：
someFunctionWithEscapingClosure(_:) 函数接受一个闭包作为参数，该闭包被添加到一个函数外定义的数组中。如果不将这个参数标记为@escaping，就会得到一个编译错误。
*/

//4.2.逃逸闭包的使用
//逃逸闭包和非逃逸闭包在使用上有所不同。将一个闭包标记为@escaping(即逃逸闭包)后,在调用这个闭包时就必须在闭包中显式地引用 self。一个示例如下：
//定义一个带有非逃逸闭包参数的函数
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

//定义一个可以使用闭包的类
class SomeClass {
    var x = 10
    func doSomething() {
        //调用逃逸闭包：必须在闭包中显式引用self
        someFunctionWithEscapingClosure { self.x = 100 }
        //调用非逃逸闭包：可以隐式引用self
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)         //打印出 "200”




//五、自动闭包
print("五、自动闭包")
/*
 自动闭包:一种自动创建的闭包，用作函数的闭包参数(以一种表达式的形式)。
 
 自动闭包的特点：
 1.自动闭包不接受任何参数；
 2.自动闭包被调用的时候，会返回被包装在其中的表达式的值；
 3.自动闭包是用一个普通的表达式来代替显式的闭包，能够省略闭包的花括号；
 
 其实，我们经常调用采用自动闭包的函数，但是却少去实现这样的函数，assert函数就是其中之一：
 assert(condition:, message:)
 assert函数中的condition参数可以接受自动闭包作为值，condition参数仅会在debug模式下被求值，在condidtion被调用返回值为false时，message参数将被使用。
*/

//1.自动闭包的基本使用
//自动闭包能够实现延迟求值，直到调用这个闭包时，代码才会被执行。这对于有副作用或者高计算成本的代码来说是有益处的。
//下面的代码展示了自动闭包实现延时求值的具体做法：
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)    //打印出 "5"
//自动闭包不接受参数，只是一个表达式
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)    //打印出 "5"
//调用自动闭包
print("Now serving \(customerProvider())!")  // Prints "Now serving Chris!"
print(customersInLine.count)                 //打印出 "4”

//代码分析：闭包实现了移除第一元素的功能，但是在闭包被调用之前，这个元素是不会被移除的。这就实现了延迟的作用

//2.自动闭包在函数中的使用
//现在将闭包作为参数传递给一个函数，同样可以实现延时求值行为。下面的serve函数接受了一个闭包参数(具有删除第一个元素且返回这个元素的功能)。
//customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}

serve(customer: { customersInLine.remove(at: 0) } )  //打印出"Now serving Alex!”



//现在使用自定闭包来实现上述函数功能，使用@autoclosure关键字，标明参数使用的是自动闭包，具体示例如下：
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
//由于标明了自动闭包，这里直接省略了闭包的花括号
serve(customer: customersInLine.remove(at: 0))  //打印出"Now serving Ewa!\n"



//3.可"逃逸"的自动闭包
//一个自动闭包可以“逃逸”，这时候应该同时使用 @autoclosure 和 @escaping 属性，下面举例说明：
// customersInLine i= ["Barry", "Daniella"]
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
//调用collectCustomerProviders，向数组中追加闭包
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")   //打印 "Collected 2 closures."

//循环数组中闭包，并且执行
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
// 打印 "Now serving Barry!"
// 打印 "Now serving Daniella!”

/*
代码分析：
作为逃逸闭包：
collectCustomerProviders函数中，闭包customerProvider被追加到customerProviders中，而这个数据
是定义在函数作用域范围之外的，这意味数组内的闭包能够在函数返回之后被调用，所以customerProvider必须允许
"逃逸"出函数作用域。

作为自动闭包：
调用collectCustomerProviders函数时，传入的闭包是表达式的形式，自动闭包省略了闭包花括号
*/


/*
注意：
过度使用 autoclosures 会让你的代码变得难以理解。上下文和函数名应该能够清晰地表明求值是被延迟执行的。
*/






