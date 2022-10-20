import UIKit

enum Section: CaseIterable, CustomStringConvertible {
    case backupRestore
    case service
    
    var description: String {
        switch self {
        case .backupRestore:
            return "백업 및 복원"
        case .service:
            return "문의하기"
        }
    }
    
    var header: String {
        switch self {
        case .backupRestore:
            return "데이터"
        case .service:
            return "고객센터"
        }
    }
    
    var footer: String {
        switch self {
        case .backupRestore:
            return "앱을 재설치하거나 또는 기기를 잃어버리거나 새로운 기기로 교체하실 때 사용자의 데이터를 복원할 수 있도록 생성된 백업 파일을 '파일'앱 > 'iCloud Drive' 또는 안전한 위치로 옮겨주세요.\n\n생성된 백업 파일의 파일명은 변경하지 마시기 바랍니다."
            
            //"백업 파일은 Hanger 앱 내부에 생성되며, Hanger 앱 삭제 시 저장된 백업 파일도 함께 삭제됩니다.\n\n기기를 잃어버리거나 새로운 기기로 교체하실 때 사용자의 데이터를 복원할 수 있도록 생성된 백업 파일을 '파일'앱 > 'iCloud Drive' 또는 안전한 위치로 옮겨주세요.\n\n데이터 크기에 따라 다소 시간이 걸릴 수 있습니다. 진행 중에 앱을 종료하거나 다른 앱으로 이동하지 말고 잠시만 기다려 주세요.\n\n성공적인 백업, 복구를 위해 파일명은 변경하지 마시기 바랍니다."
            
        case .service:
            return "기본 Mail 앱에 메일 계정이 등록되어야 사용할 수 있습니다."
        }
    }
}

class PreferencesViewController: BaseViewController {
    
    let mainView = PreferencesView()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSourse()
        self.mainView.collectionView.delegate = self
    }
}

extension PreferencesViewController {
    
    private func configureDataSourse() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = "\(itemIdentifier)"
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
//        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
//            var content = UIListContentConfiguration.groupedHeader()
//            content.text = "\(Section.allCases[indexPath.section].header)"
//            supplementaryView.contentConfiguration = content
//        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            var content = UIListContentConfiguration.groupedFooter()
            content.text = "\(Section.allCases[indexPath.section].footer)"
            supplementaryView.contentConfiguration = content
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            
            //return elementKind == UICollectionView.elementKindSectionHeader ? collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath) : collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)

        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.backupRestore])
        snapshot.appendItems([Section.backupRestore.description])
        
        snapshot.appendSections([.service])
        snapshot.appendItems([Section.service.description])
        dataSource.apply(snapshot)
        
    }
}

extension PreferencesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
