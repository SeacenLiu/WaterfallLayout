//
//  WaterfallLayout.swift
//  瀑布流
//
//  Created by SeacenLiu on 2018/9/11.
//  Copyright © 2018年 SeacenLiu. All rights reserved.
//

import UIKit

/**
 * WaterfallLayout 用于 UICollectionView 的瀑布布局
 * 当前版本:
    - 必须设置 delegate (改成 dataSource ?)
    - 没有头尾视图设置
 * 计算方法:
    - 使用数组缓存当前各水流长度
    - 在最短水流处添加新 Item
    - 以此类推
 */

enum WaterfallStyle {
    case vertical
    case horizontal
}

protocol WaterfallLayoutDeleagte: NSObjectProtocol {
    /// 获取高宽比
    func waterfallLayoutItemSize(for indexPath: IndexPath, layout: WaterfallLayout) -> CGSize
    func waterfallLayoutFlowCount(with layout: WaterfallLayout) -> Int
    
    // optional
    func waterfallLayoutStyle(with layout: WaterfallLayout) -> WaterfallStyle
    func waterfallLayoutColumnMargin(with layout: WaterfallLayout) -> CGFloat
    func waterfallLayoutRowMargin(with layout: WaterfallLayout) -> CGFloat
    func waterfallLayoutEdgeInsets(with layout: WaterfallLayout) -> UIEdgeInsets
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
}

class WaterfallLayout: UICollectionViewLayout {
    
    weak var delegate: WaterfallLayoutDeleagte?
    
    var _delegate: WaterfallLayoutDeleagte {
        guard let delegate = delegate else {
            fatalError("必须设置 WaterfallLayoutDeleagte 协议")
        }
        return delegate
    }
    
    /// 水流高度 垂直瀑布是列高度 水平瀑布是行高度
    private var flowHeights = [CGFloat]()
    /// 缓存布局属性数组
    private var attributesArray = [UICollectionViewLayoutAttributes]()
    /// 瀑布样式
    private lazy var style = _delegate.waterfallLayoutStyle(with: self)
    /// 行间距
    private lazy var rowMargin = _delegate.waterfallLayoutRowMargin(with: self)
    /// 列间距
    private lazy var columnMargin = _delegate.waterfallLayoutColumnMargin(with: self)
    /// 列数
    private lazy var flowCount = _delegate.waterfallLayoutFlowCount(with: self)
    /// 四边距
    private lazy var edgeInsets = _delegate.waterfallLayoutEdgeInsets(with: self)
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        // 清除缓存
        flowHeights = Array(repeating: edgeInsets.top, count: flowCount)
        attributesArray.removeAll()
        // 创建新的布局属性
        for i in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            if let attributes = layoutAttributesForItem(at: indexPath) {
                attributesArray.append(attributes)
            }
        }
    }
    
    // 返回布局数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    // 返回每个 indexPath 对应的 cell 的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = itemFrame(with: indexPath)
        return attributes
    }
    
    /// 计算 Item 的 Frame
    func itemFrame(with indexPath: IndexPath) -> CGRect {
        switch style {
        case .vertical:
            return verticalItemFrame(with: indexPath)
        case .horizontal:
            return horizontalItemFrame(with: indexPath)
        }
    }
    
    /// 计算垂直瀑布的Frame
    func verticalItemFrame(with indexPath: IndexPath) -> CGRect {
        guard let collectionViewWidth = collectionView?.frame.width else {
            return .zero
        }
        // 布局的宽度和高度
        #warning("width 应该计算一次就行了")
        let width = (collectionViewWidth - edgeInsets.left - edgeInsets.right - (CGFloat(flowCount) - 1) * columnMargin) / CGFloat(flowCount)
        let size = _delegate.waterfallLayoutItemSize(for: indexPath, layout: self)
        let aspectRatio = size.height / size.width
        let height = width * aspectRatio
        
        // 查找最短的一列索引和值
        var destColumn = 0
        var minColumnHeight = flowHeights[0] //.first ?? edgeInsets.top
        for (i, v) in flowHeights.enumerated() {
            if v < minColumnHeight {
                minColumnHeight = v
                destColumn = i
            }
        }
        
        // 布局的坐标点
        let x = edgeInsets.left + CGFloat(destColumn) * (width + columnMargin)
        var y = minColumnHeight
        if y != edgeInsets.top {
            y += rowMargin
        }
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        // 更新最短那列的高度
        flowHeights[destColumn] = rect.maxY
        
        return rect
    }
    
    /// 计算水平瀑布的Frame
    func horizontalItemFrame(with indexPath: IndexPath) -> CGRect {
        guard let collectionViewHeight = collectionView?.frame.height else {
            return .zero
        }
        // 布局的宽度和高度
        #warning("height 应该计算一次就行了")
        let height = (collectionViewHeight - edgeInsets.top - edgeInsets.bottom - (CGFloat(flowCount) - 1) * rowMargin) / CGFloat(flowCount)
        let size = _delegate.waterfallLayoutItemSize(for: indexPath, layout: self)
        let aspectRatio = size.width / size.height
        let width = height * aspectRatio
        
        // 查找最短的一列索引和值
        var destRow = 0
        var minRowWidth = flowHeights[0] //.first ?? edgeInsets.top
        for (i, v) in flowHeights.enumerated() {
            if v < minRowWidth {
                minRowWidth = v
                destRow = i
            }
        }
        
        // 布局的坐标点
        var x = minRowWidth
        if x != edgeInsets.top {
            x += rowMargin
        }
        let y = edgeInsets.top + CGFloat(destRow) * (height + rowMargin)
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        // 更新最短那列的高度
        flowHeights[destRow] = rect.maxX
        
        return rect
    }
    
    // contentSize
    override var collectionViewContentSize: CGSize {
        switch style {
        case .vertical:
            guard var maxColumnHeight = flowHeights.first else {
                return .zero
            }
            flowHeights.forEach {
                if maxColumnHeight < $0 {
                    maxColumnHeight = $0
                }
            }
            return CGSize(width: 0, height: maxColumnHeight + edgeInsets.bottom)
        case .horizontal:
            guard var maxRowWidth = flowHeights.first else {
                return .zero
            }
            flowHeights.forEach {
                if maxRowWidth < $0 {
                    maxRowWidth = $0
                }
            }
            return CGSize(width: maxRowWidth + edgeInsets.right, height: 0)
        }
    }
}
