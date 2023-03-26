//
//  FlowLayout.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation
import UIKit

public final class FlowLayout: UICollectionViewFlowLayout {
    public override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).size.width
        let screen = UIScreen.main.bounds
        let minColumnWidth = (screen.height > screen.width) ? availableWidth : availableWidth / 3
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

        itemSize = CGSize(
            width: cellWidth,
            height: 90.0
        )
        sectionInset = UIEdgeInsets(
            top: minimumInteritemSpacing,
            left: minimumInteritemSpacing,
            bottom: .zero,
            right: minimumInteritemSpacing
        )
        sectionInsetReference = .fromSafeArea
    }
}
