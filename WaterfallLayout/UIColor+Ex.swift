//
//  UIColor+Ex.swift
//  weibo
//
//  Created by 成 on 2017/10/11.
//  Copyright © 2017年 成. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 随机颜色
    class var random: UIColor {
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}
