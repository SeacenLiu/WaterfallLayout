//
//  ViewController.swift
//  WaterfallLayout
//
//  Created by SeacenLiu on 2018/9/13.
//  Copyright © 2018年 SeacenLiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let commodities = FModel.loadData() //Commodity.loadData()
    
    static let headerId = "header"
    static let footerId = "footer"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 必须设置代理
        if let layout = collectionView.collectionViewLayout as? WaterfallLayout {
            layout.delegate = self
        }
        
        /// 注册
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ViewController.headerId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ViewController.footerId)
    }
    
}

extension ViewController: WaterfallLayoutDeleagte {
    func waterfallLayoutStyle(with layout: WaterfallLayout) -> WaterfallStyle {
        return .vertical
    }
    
    func waterfallLayoutItemSize(for indexPath: IndexPath, layout: WaterfallLayout) -> CGSize {
        let model = commodities[indexPath.item]
        return CGSize(width: model.w, height: model.h)
    }
    
    func waterfallLayoutFlowCount(with layout: WaterfallLayout) -> Int {
        return 2
    }
    
    func waterfallLayoutHeightForHeader(for indexPath: IndexPath, layout: WaterfallLayout) -> CGFloat {
        return 20
    }
    
    func waterfallLayoutHeightForFooter(for indexPath: IndexPath, layout: WaterfallLayout) -> CGFloat {
        return 30
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commodities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommodityCell.cellId, for: indexPath)
        cell.backgroundColor = .random
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let hv = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewController.headerId, for: indexPath)
            hv.backgroundColor = .red
            return hv
        case UICollectionView.elementKindSectionFooter:
            let fv = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewController.footerId, for: indexPath)
            fv.backgroundColor = .blue
            return fv
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

