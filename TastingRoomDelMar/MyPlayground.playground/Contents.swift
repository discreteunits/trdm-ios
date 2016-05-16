//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"
//str
//print(str)
//
//var person = ["Name": "Toby", "Age": "25"]
//person["Name"]
//person["Height"] = "6"
//person["Height"]
//
//
//
//let view = UIView(frame: CGRect(x: 0, y: 0,
//    width: 600, height: 600))
//view.backgroundColor = UIColor.lightTextColor()
//XCPShowView("Main View", view: view)
//let whiteSquare = UIView(frame: CGRect(x: 100, y: 100,
//    width: 100, height: 100))
//whiteSquare.backgroundColor = UIColor.whiteColor()
//view.addSubview(whiteSquare)
//let orangeSquare = UIView(frame: CGRect(x: 400, y: 100,
//    width: 100, height: 100))
//orangeSquare.backgroundColor = UIColor.orangeColor()
//view.addSubview(orangeSquare)
//
//let animator = UIDynamicAnimator(referenceView: view)
//animator.addBehavior(UIGravityBehavior(items: [orangeSquare]))
//
//let boundaryCollision = UICollisionBehavior(items: [whiteSquare, orangeSquare])
//boundaryCollision.translatesReferenceBoundsIntoBoundary = true
//animator.addBehavior(boundaryCollision)
//
//let bounce = UIDynamicItemBehavior(items: [orangeSquare])
//
//bounce.elasticity = 0.8
//bounce.density = 800
//bounce.resistance = 1
//animator.addBehavior(bounce)
//
//animator.setValue(true, forKey: "debugEnabled")
var price = 129.60000000000002
let priceDecimals:Double =  (price % 1)
var a = String(format:"%.2f", priceDecimals)
var b = Double(a)
if priceDecimals < 0.999999999 && priceDecimals > 0.0999999999 {
    print("price: \(price)0")
} else {
//    print("price: \(price)")
}

let deci = price - floor(price)
