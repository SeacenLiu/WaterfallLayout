//
//  FModel.swift
//  瀑布流
//
//  Created by SeacenLiu on 2018/9/11.
//  Copyright © 2018年 SeacenLiu. All rights reserved.
//

import UIKit

struct FModel {
    let h: CGFloat
    let w: CGFloat
    
    static func loadData() -> [FModel] {
        return [
            FModel(h: 10, w: 20),
            FModel(h: 20, w: 20),
            FModel(h: 30, w: 20),
            FModel(h: 10, w: 30),
            FModel(h: 20, w: 20),
            FModel(h: 30, w: 40),
            FModel(h: 60, w: 50),
            FModel(h: 20, w: 30),
            FModel(h: 10, w: 20),
        ]
    }
}
