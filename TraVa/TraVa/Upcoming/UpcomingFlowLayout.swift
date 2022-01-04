//
//  UpcomingFlowLayout.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 24.12.2021.
//

import Foundation
import UIKit

final class UpcomingFlowLayout: UICollectionViewFlowLayout {
	override func prepare() {
		super.prepare()
		
		guard let cv = self.collectionView else { return }
		
		let availableWidth = cv.bounds.inset(by: cv.layoutMargins).size.width / 2
		
		let screen = UIScreen.main.bounds
		
		let minColumnWidth = (screen.height > screen.width) ? availableWidth : availableWidth / 3
		let maxNumColumns = Int(availableWidth / minColumnWidth)
		let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
		
		let cellHeight = (cellWidth / 2) * 3 + cellWidth / 3
		
		self.itemSize = CGSize(width: cellWidth, height: cellHeight)
		
		self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: self.minimumInteritemSpacing, bottom: 0, right: self.minimumInteritemSpacing)
		self.sectionInsetReference = .fromSafeArea
	}
}
