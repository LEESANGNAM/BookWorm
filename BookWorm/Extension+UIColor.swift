//
//  Extenstion+UIColor.swift
//  BookWorm
//
//  Created by 이상남 on 2023/08/01.
//

import UIKit


extension UIColor {
    
    static func randomColor() -> UIColor{
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return color
    }
}
