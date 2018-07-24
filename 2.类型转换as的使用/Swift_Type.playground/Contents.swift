//: Playground - noun: a place where people can play

import UIKit


//1、Swift中as as！ as?的区别
//仅当一个值的类型在运行时（runtime）和as模式右边的指定类型一致 
//或者是该类型的子类的情况下，才会匹配这个值。
//如果匹配成功，被匹配的值的类型被转换成as模式左边指定的模式。

class Animal{}
class Dog :Animal{}

//as的使用有包含两种情况
//1.和as右边的类型一致
//2.是右边类型的子类型
let a = Animal()
a as Animal

//swift不支持向下转型,这里应该使用过as！;
let b :Animal = Dog()
//b as Dog  //编译不能通过
b as! Dog


//as!强制转型，如果类型不符合会报错
//使用as?，相当于可选型转型，如果转化失败会返回nil
b as? Dog



