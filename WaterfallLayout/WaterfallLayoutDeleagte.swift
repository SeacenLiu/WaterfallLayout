//
//  WaterfallLayoutDeleagte.swift
//  WaterfallLayout
//
//  Created by SeacenLiu on 2018/9/13.
//  Copyright © 2018年 SeacenLiu. All rights reserved.
//

import UIKit

enum WaterfallStyle {
    case vertical
    case horizontal
}

protocol WaterfallLayoutDeleagte: NSObjectProtocol {
    /// 获取高宽比
    func waterfallLayoutItemSize(for indexPath: IndexPath, layout: WaterfallLayout) -> CGSize
    /// 瀑布水流数
    func waterfallLayoutFlowCount(with layout: WaterfallLayout) -> Int
    
    // optional
    /// 瀑布样式 默认为 vertical
    func waterfallLayoutStyle(with layout: WaterfallLayout) -> WaterfallStyle
    /// 获取列边距
    func waterfallLayoutColumnMargin(with layout: WaterfallLayout) -> CGFloat
    /// 获取行边距
    func waterfallLayoutRowMargin(with layout: WaterfallLayout) -> CGFloat
    /// 获取四边距
    func waterfallLayoutEdgeInsets(with layout: WaterfallLayout) -> UIEdgeInsets
    
    func waterfallLayoutHeightForHeader(for indexPath: IndexPath, layout: WaterfallLayout) -> CGFloat
    func waterfallLayoutHeightForFooter(for indexPath: IndexPath, layout: WaterfallLayout) -> CGFloat
}

extension WaterfallLayoutDeleagte {
    func waterfallLayoutStyle(with layout: WaterfallLayout) -> WaterfallStyle {
        return .vertical
    }
    
    func waterfallLayoutColumnMargin(with layout: WaterfallLayout) -> CGFloat {
        return 10
    }
    
    func waterfallLayoutRowMargin(with layout: WaterfallLayout) -> CGFloat {
        return 10
    }
    
    func waterfallLayoutEdgeInsets(with layout: WaterfallLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    func waterfallLayoutHeightForHeader(for indexPath: IndexPath, layout: WaterfallLayout) -> CGFloat {
        return 0
    }
    
    func waterfallLayoutHeightForFooter(for indexPath: IndexPath, layout: WaterfallLayout) -> CGFloat {
        return 0
    }
}
