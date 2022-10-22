//
//  BackupAndRestoreView.swift
//  Diffable
//
//  Created by 이도헌 on 2022/10/22.
//

import UIKit

import SnapKit

class BackupAndRestoreView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let layout = layout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(collectionView)
    }
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension BackupAndRestoreView {
    private func layout() ->  UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
        
    }
}
