//
//  BackupAndRestoreViewController.swift
//  Diffable
//
//  Created by 이도헌 on 2022/10/22.
//

enum BackupRestoreSection {
    case main
    
    var item: [String] {
        switch self {
        case .main:
            return ["백업", "복원"]
        }
    }
    
    static let footer = "앱을 재설치하거나 또는 기기를 잃어버리거나 새로운 기기로 교체하실 때 사용자의 데이터를 복원할 수 있도록 생성된 백업 파일을 '파일'앱 > 'iCloud Drive' 또는 안전한 위치로 옮겨주세요.\n\n생성된 백업 파일의 파일명은 변경하지 마시기 바랍니다."
}

import UIKit

class BackupAndRestoreViewController: BaseViewController {
    
    let mainView = BackupAndRestoreView()
    
    var dataSource: UICollectionViewDiffableDataSource<BackupRestoreSection, String>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        self.mainView.collectionView.delegate = self
    }
}

extension BackupAndRestoreViewController {
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            var content = UIListContentConfiguration.groupedFooter()
            content.text = BackupRestoreSection.footer
            supplementaryView.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<BackupRestoreSection, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(BackupRestoreSection.main.item)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension BackupAndRestoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
