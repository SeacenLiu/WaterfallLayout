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
        
        if let layout = collectionView.collectionViewLayout as? WaterfallLayout {
            layout.itemSize = { [unowned self] indexPath in
                let model = self.commodities[indexPath.item]
                return CGSize(width: model.w, height: model.h)
            }
            layout.headerHeight = { _ in
                return 20
            }
            layout.footerHeight = { _ in
                return 30
            }
        }
        
        /// 注册
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ViewController.headerId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ViewController.footerId)
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

