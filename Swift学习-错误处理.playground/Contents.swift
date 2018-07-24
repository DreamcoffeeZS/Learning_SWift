//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//================================================//
//=                                              =//
//=           ======Swift学习-错误处理======       =//
//=                                              =//
//================================================//



/*
即使是Swift也无法保证所有的操作总是执行完所有代码或总是生成有用的结果，虽然可选类型可用来表示值缺失，但是当某个操作失败时，最好能得知失败的原因，从而可以作出相应的应对。

错误处理(Error handling)是响应错误以及从错误中恢复的过程。Swift提供了在运行时对可恢复错误的抛出、捕获、传递和操作的支持。
*/



//一、表示并抛出错误
//1.表示错误
//在Swift中，错误用符合Error协议的类型的值来表示,这个空协议表明该类型可以用于错误处理。Swift枚举特别适合于对一组相关的错误条件建模。
//例如,下面是表示自动水果售货机购买失败的错误条件
enum VendingMachineError: Error {
    case notSuchFruit        //不存在这样的水果
    case notEnoughMoney(coinsNeeded: Int)  //购买金额不足
    case outOfStock          //水果缺货
    
    //在这里可以添加一个计算型属性，方便打印错误信息
    var description:String{
        switch self {
        case .notSuchFruit:
            return "Not Such Item"
        case .notEnoughMoney(let coinsNeeded):
            return "Not Enough Money" + String(coinsNeeded) + "yuan needed"
        case .outOfStock:
            return "Out of Stock"
        }
    }
}

//2.抛出错误
//抛出一个错误可以让你表明有意外情况发生，导致正常的执行流程无法继续执行，抛出错误使用throw关键字。例如, 下面的代码抛出一个错误, 指示自动售货机需要五个额外的硬币:
// throw VendingMachineError.notEnoughMoney(coinsNeeded: 5)




//二、处理错误
/*
某个错误被抛出时，附近的某部分代码必须负责处理这个错误，例如纠正这个问题、尝试另外一种方式、或是向用户报告错误。
Swift 中有4种处理错误的方式:
1.把throwing函数抛出的错误,传递给调用此函数的代码;
2.用do-catch语句处理错误;
3.将错误作为可选类型处理;
4.或者断言此错误根本不会发生;

当一个函数抛出一个错误时，程序流程会发生改变，所以重要的是能迅速识别代码中会抛出错误的地方。为了标识出这些地方，在调用一个能抛出错误的函数、方法或者构造器之前，加上try关键字，或者try?或try!这种变体
*/
//2.1.使用throwing函数传递错误
/*
表示一个函数、方法或构造器可以抛出错误，需要在其函数声明的参数列表之后加上throws关键字。标有throws关键字的函数被称作throwing函数。如果这个函数指明了返回值类型，throws关键词需要写在箭头(->)的前面。
func canThrowErrors() throws -> String
func cannotThrowErrors() -> String

下面的例子中，售货机VendingMechine类有一个vendFruit方法，如果请求的物品不存在、缺货或者投入金额小于物品价格，该方法就会抛出一个相应的VendingMachineError：
 */


//水果
struct Fruit {
    var price: Int
    var count: Int
}

//售货机
class VendingMachine {
    //水果存货
    var fruits = [
        "banana": Fruit(price: 2, count: 10),
        "apple": Fruit(price: 3, count: 10),
        "pear": Fruit(price: 4, count: 10)
    ]
    

    func vendFruit(fruitName: String, withCoins coins:Int) throws ->Int{
        //1.判断是否需要抛出异常
        //要买的水果不存在
        guard let fruit = fruits[fruitName] else {
            throw VendingMachineError.notSuchFruit
        }
        
        //要买的水果缺货了
        guard fruit.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        //要买的水果价格大于投币的钱
        guard fruit.price <= coins else {
            throw VendingMachineError.notEnoughMoney(coinsNeeded: fruit.price - coins)
        }
        
        //2.更新水果的存货信息
        var newFruit = fruit
        newFruit.count -= 1
        fruits[fruitName] = newFruit
        
        //3.退出多余的钱
        return coins - fruit.price
    }
}

//throwing函数总结：
//1.throwing函数可以在其内部抛出错误，并将错误传递到函数被调用时的作用域。
//2.只有throwing函数可以传递错误,任何在某个非throwing函数内部抛出的错误只能在函数内部处理。

//我们看到throwing函数只是将错误抛出传递，并未真正的处理错误。其实，处理错误是在调用此函数的地方，要么直接处理，即使用do-catch语句、try?或try!,要么继续将错误向下传递；我们先看将错误传递的情况，使用下面的例子说明：

//创建testVendMachine函数，其中调用vendFruit函数
func testVendMachine(vendingMachine:VendingMachine,fruitName:String, coins:Int) throws{
    //vendingMachine函数能抛出异常，调用的时候需要使用try关键字;
    //这里vendFruit的异常向下传递给了testVendMachine
   try vendingMachine.vendFruit(fruitName: fruitName, withCoins: coins)
}

//处理异常：testVendMachine函数抛出了vendFruit函数里的异常
do{
    try testVendMachine(vendingMachine: VendingMachine(), fruitName: "watermelon", coins: 10)
}catch let error as VendingMachineError{
    print(error)  //notSuchFruit
    print(error.description)  //Not Such Item
}



//2.2.用do-catch语句处理错误;
/*
可以使用一个do-catch语句运行一段闭包代码来处理错误。如果在do子句中的代码抛出了一个错误，这个错误会与catch子句做匹配，从而决定哪条子句能处理它。
*/
/*
//do-catch语法格式
do {
    try expression
    statements
} catch pattern 1 {
    statements
} catch pattern 2 where condition {
    statements
} catch {
    statements
}
*/
//示例代码：
do{
    try testVendMachine(vendingMachine: VendingMachine(), fruitName: "watermelon", coins: 10)
}catch VendingMachineError.notSuchFruit{
    print("处理错误1：No Such Item");
}catch VendingMachineError.notEnoughMoney(let coinsNeeded){
    print("处理错误2：Not Engough Money,\(coinsNeeded) yuan needed");
}catch VendingMachineError.outOfStock{
    print("处理错误3：Out of Stock");
}catch{
    print("处理其他可能的错误");
}
/*
注意：
1.Catch后跟随的是一个匹配模式，表明这个子语句能处理的错误类型
2.Catch后如果没有指定匹配模式，则可以匹配任何错误，并把错误绑定到一个名为error的局部常量。
3.Catch不必将do语句代码中所抛出所有可能错误都处理
*/






//2.3.将错误作为可选类型处理;
/*
 可以使用try?通过将错误转换成一个可选值来处理错误。如果在评估try?表达式时一个错误被抛出，那么表达式的值就是nil。
 例如,在下面的代码中,x1和x2有着相同的数值和等价的含义：
 */
//非负整数抛出异常
enum IntNumberError:Error{
    case NegativeIntError  //负整数
    case ZeroIntError      //零
}

//检查正整数的函数
func checkIntFunction(_ num:Int) throws -> Int {
    if num < 0 {
        throw IntNumberError.NegativeIntError
    }
    if num == 0 {
        throw IntNumberError.ZeroIntError
    }
    return num
}

//方法1：使用try？,异常抛出后表达式就是nil
let x1 = try? checkIntFunction(-1)

//方法2：使用do-catch的方式处理异常，将结果转化为nil
let x2: Int?
do {
    x2 = try checkIntFunction(-1)
} catch {
    x2 = nil
}

//有时候，利用try？抛出错误默认表达式nil的特点，可以写出简洁的代码。例如：下面的代码分别从本地和服务器获取数据，如果两种方式都失败则返回nil：
/*
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}
*/



//2.4.禁用错误传递
/*使用throwing函数时，我们也会遇到明知道函数不会抛出异常的情况，此时我们可以在表达式前使用try!禁用错误传递。这样会把调用包装在一个不会有错误抛出的运行时断言中，若真的有异常抛出错误，会得到一个运行时错误。
 
 例如，我们使用loadImage(atPath:)函数从本地的固定路径中获取图片，一般这个过程不会失败，所以这里禁用错误传递：

 let photo = try! loadImage(atPath: "./Resources/appIcon.png")
*/



//三、指定清理操作
/*
 指定清理操作是使用defer语句在即将离开当前代码块时执行一系列语句，能够让我们执行一些必要的清理工作。
 1.defer语句适用于以任何方式离开当前代码块的操作：无论抛出异常离开还是诸如return或者break的语句；
 2.defer语句可以用来确保文件描述符得以关闭、手动分配的内存得以释放等；
 3.defer语句将代码的执行延迟到当前的作用域退出之前；
 4.defer语句由defer关键字和延迟执行的语句组成；
 5.defer延迟执行的语句不能包含任何控制转移语句，例如break、return，或者抛出一个错误；
 6.即使没有涉及到错误处理，你也可以使用defer语句。
 7.延迟执行的操作会按照它们被指定时的顺序的相反顺序执行，即第一条defer语句中的代码会在第二条defer语句中的代码被执行之后才执行，以此类推；
*/
/*
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // 处理文件。
        }
        //close(file) 会在这里被调用，即作用域的最后。
    }
}
*/
//注意：上面的代码使用一条defer语句来确保open(_:)函数有一个相应的对close(_:)函数的调用。




//四、强制退出程序
//强制退出程序有两种情况：
//1.只在调试Debug阶段中断
/*
assert(1 > 0) //条件判断失败后，程序中断
assert(1 > 0,"程序中断说明")

assertionFailure() //无需判断条件，程序执行到此处直接中断
assertionFailure("")
*/

//2.能够在发布阶段生效的中断
/*
precondition(1>0)  //条件判断失败后，程序中断
precondition(1>0, "程序中断说明")

preconditionFailure()  //无需判断条件，程序执行到此处直接中断
preconditionFailure("程序中断说明")
*/









