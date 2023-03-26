//
//  UpcomingFlowLayout.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 24.12.2021.
//

import Foundation
import UIKit

public final class UpcomingFlowLayout: UICollectionViewFlowLayout {
    public override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView else { return }

        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).size.width / 2
        let screen = UIScreen.main.bounds
        let minColumnWidth = (screen.height > screen.width) ? availableWidth : availableWidth / 3
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        let cellHeight = (cellWidth / 2) * 3 + cellWidth / 3

        itemSize = CGSize(
            width: cellWidth,
            height: cellHeight
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
