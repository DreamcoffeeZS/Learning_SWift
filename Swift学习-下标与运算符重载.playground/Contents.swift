//: Playground - noun: a place where people can play

import UIKit



//================================================//
//=                                              =//
//=      ======Swift学习-下标与运算符重载====== =//
//=                                              =//
//================================================//


//一、Swift下标
print("\n一、Swift下标")
//下标可以定义在类、结构体和枚举中，是访问集合，列表或序列中元素的快捷方式。可以使用下标的索引，设置和获取值，而不需要再调用对应的存取方法。
//1.下标的基本语法
//下标语法使用关键字subscript，以中括号中传入参数的形式来对实例进行存取。下标的使用可类比计算型属性，通过getter和setter方法实现读写或只读，并默认有newValue。具体的语法如下：
/*
subscript(index: Int) -> Int {
    get {
        //返回一个适当的Int类型的值
    }
      
    set(newValue) {
        //执行适当的赋值操作
    }
}
*/



//1.2下标的基本使用
//下面定义了一个三维向量的结构体，然后为其添加了数字下标和字符串下标，具体的代码如下：
struct Vector3{
    var x:Double = 0.0
    var y:Double = 0.0
    var z:Double = 0.0
    
    //1.设置数字下标：可以使用数字索引取值
    subscript(index:Int)->Double?{
        //此处默认是get方法；如果需要修改值，就需要增加set方法，对比字符串下标
        switch index{
        case 0:return x
        case 1:return y
        case 2:return z
        default:return nil
        }
    }
    
    //2.设置字符串下标：可以使用字符串取值
    subscript(valueName:String)->Double?{
        get{
            switch valueName{
            case "x","X":return x
            case "y","Y":return y
            case "z","Z":return z
            default:return nil
            }
        }
        //这里是set方法：实现使用字符串下标修改值
        //使用系统默认的newValue，这是一个可选型，所以使用的时候需要解包
        set{
            guard let newValue = newValue else {return}
            switch valueName {
            case "x","X": x = newValue
            case "y","Y": y = newValue
            case "z","Z": z = newValue
            default:return
            }
        }
    }
}

//测试下标的使用
var vector3 = Vector3(x:1.0,y:2.0,z:3.0)
//方法1：使用点语法取值
vector3.x             //1

//方法2：使用下标取值
vector3[0]            //1
vector3["x"]          //1
vector3["x"] = 100.0  //100

/*
 下标的使用总结：
 1.如果是只读属性，可以省略只读下标的get关键字(如数字下标)
 2.一个类或结构体可以根据自身需要提供多个下标实现，使用下标时将通过入参的数量和类型进行区分，
 自动匹配合适的下标，这就是下标的重载,如上面代码中的数字下标和字符串下标
 */



//二、多维下标
print("\n二、Swift下标")
//虽然接受单一入参的下标是最常见的，但也可以根据情况定义接受多个入参的下标。这里使用一个矩阵的示例来演示多维下标的用法:

struct Matrix{
    var data:[[Double]]
    var row:Int     //行数
    var cls:Int     //列数
    
    init(row:Int,cls:Int) {
        self.row = row
        self.cls = cls
        data = [[Double]]()
        for _ in 0...row{
            let tempRowArray = Array(repeating: 0.0, count: cls)
            self.data.append(tempRowArray)
        }
    }
    
    
    //创建具有两个参数的下标
    subscript(x:Int, y:Int) -> Double?{
        get{
            //这里介绍一种新的防止参数越界的方法，使用断言：Assert
            //如果其中的表达式为真，那么什么都不会发生，否则程序终止运行
            assert(x >= 0 && x < row && y >= 0 && y<cls, "Index Out of Range")
            return data[x][y]
        }
        
        set{
            assert(x >= 0 && x < row && y >= 0 && y<cls, "Index Out of Range")
            guard let newValue = newValue else{return}
            data[x][y] =  newValue
        }
    }
    
    //改进1：
    subscript (row:Int) ->[Double]{
        get{
            assert(row >= 0 && row < self.row, "Index Out of Range")
            return data[row]
        }
        
        set(vector){
            assert(vector.count == cls ,"Column Number does Not Match")
            return data[row] = vector
        }
    }
}
var m = Matrix(row: 2, cls: 2)
//测试1：取值
m[1,1]              //0
//m[2,2]            //越界崩溃

//测试2：赋值
m[1,1] = 100
m[1,1]              //100

//测试3：使用m[1][1]的样式来取值、赋值
m[0] = [200, 300]   //使用单个索引之后得到一个数组
m[0][0]             //200
m[1][1] = 999       //999
m[1][1]             //999


//三、重载运算符
print("\n三、重载运算符")
//所谓运算符重载，就是对swfit已经存在的一些运算符，我们在具体的使用的时候，重新赋于了它们新的定义。如下创建va、vb两个三维向量:

var va = Vector3(x:1.0, y:2.0, z:3.0)
var vb = Vector3(x:3.0, y:2.0, z:1.0)

//现在提出一个问题：我们希望使用Swift中类似"+"的运算符来计算这两个向量。其实，运算符"+"也是一个函数，只不过这个函数的名字是一个符号。下面演示了对于加号,减号等符号的重载定义
//重载"+"：实现加法
func + (left:Vector3, right:Vector3) -> Vector3{
    return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}
va + vb

//重载"-"：实现减法
//这时候需要注意left和right参数的位置
func - (left:Vector3, right:Vector3) -> Vector3{
    return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}
va  - vb

//重载"*"：实现向量与向量的相乘
func * (left:Vector3, right:Vector3) -> Double{
    return  left.x * right.x + left.y * right.y + left.z * right.z
}
va  * vb

//重载"*"：实现向量与数字的相乘
func * (left:Vector3, num:Double) -> Vector3{
    return Vector3(x: left.x * num, y: left.y * num, z: left.z * num)
}
va  * 50
//50  * va  //报错，因为顺序的问题，需要再次重载

//重载"*"：实现数字与向量的相乘
func * (num:Double, right:Vector3) -> Vector3{
    //return Vector3(x: right.x * num, y: right.y * num, z: right.z * num)
    //其实这里也可以调用去其他的方法
    //如：
    return right * num
}
50 * va


//重载"+="
func += ( left :inout Vector3, right:Vector3){
    left = left + right
}
va += vb

//情况7：我们不能重载=,因为这跟内存有关会出现问题

//情况8：负号，prefix是只这个运算放在前面使用
prefix func - (vector:Vector3) -> Vector3{
    return vector * -1
}

-vb



//四、重载比较运算符
print("\n三、重载比较运算符")

va = Vector3(x:1.0, y:2.0, z:3.0)
vb = Vector3(x:3.0, y:2.0, z:1.0)

//va == vb //报错,系统并不知道两个Vector3类型的数据该如何比较
//va === vb //报错，Vector3是结构体，不能用对类实例对象的方法来比较

//1.重载: ==
func == (left:Vector3, right:Vector3) -> Bool{
    return left.x == right.x && left.y == right.y && left.z == right.z
}
va == vb


//2.重载: !=
func !=(left:Vector3, right:Vector3) -> Bool{
    return !(left == right)
}
va != vb


//3.重载: <
func < (left:Vector3, right:Vector3) ->Bool{
    if left.x != right.x { return left.x < right.x}
    if left.y != right.y { return left.y < right.y}
    if left.z != right.z { return left.z < right.z}
    return false
}


//4.重载: <=
func <= (left:Vector3, right:Vector3) -> Bool{
    return left < right || left == right
}


//5.重载: >
func > (left:Vector3, right:Vector3) ->Bool{
    return !(left <= right)
}


//6.重载：>=
func  >= (left:Vector3, right:Vector3) -> Bool{
    return !(left < right)
}





