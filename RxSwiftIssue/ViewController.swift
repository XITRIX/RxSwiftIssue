//
//  ViewController.swift
//  RxSwiftIssue
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class ViewModel: Hashable {
    let id = UUID()
    let text = BehaviorRelay<String>(value: "Some text")

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

class ViewController: UICollectionViewController {
    var disposeBag = DisposeBag()
    let data = BehaviorRelay<[ViewModel]>(value: [])
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ViewModel>

    lazy var dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TestCell
        itemIdentifier.text.bind(to: cell.labelView.rx.text).disposed(by: cell.reusableDisposeBag)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "TestCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))

        data.bind { [unowned self] models in
            var snapshot = NSDiffableDataSourceSnapshot<Int, ViewModel>()
            snapshot.appendSections([0])
            snapshot.appendItems(models, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true)
        }.disposed(by: disposeBag)

        var items: [ViewModel] = []
        for i in 0 ..< 10 {
            let model = ViewModel()
            model.text.accept("Cell #\(i)")
            items.append(model)
        }
        data.accept(items)
    }
}

