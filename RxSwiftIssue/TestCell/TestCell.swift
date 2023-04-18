//
//  TestCell.swift
//  RxSwiftIssue
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import UIKit
import RxSwift

class TestCell: UICollectionViewListCell {
    @IBOutlet var labelView: UILabel!
    var reusableDisposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        reusableDisposeBag = DisposeBag()
    }
}
