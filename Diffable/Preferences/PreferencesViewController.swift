import UIKit
import MessageUI

enum Section: CaseIterable, Hashable {
    
    case backupRestore
    case support
    case Information
    
    var numberOfItem: [String] {
        switch self {
        case .backupRestore:
            return ["데이터 백업", "데이터 복원"]
        case .support:
            return ["문의하기", "리뷰 남기기"]
        case .Information:
            return ["버전"]
        }
    }
    
    var header: String {
        switch self {
        case .backupRestore:
            return "데이터"
        case .support:
            return "고객센터"
        case .Information:
            return "정보"
        }
    }
    
    var footer: String {
        switch self {
        case .backupRestore:
            return "앱을 재설치하거나 또는 기기를 잃어버리거나 새로운 기기로 교체하실 때 사용자의 데이터를 복원할 수 있도록 생성된 백업 파일을 '파일'앱 > 'iCloud Drive' 또는 안전한 위치로 옮겨주세요.\n\n생성된 백업 파일의 파일명은 변경하지 마시기 바랍니다."
            
            //"백업 파일은 Hanger 앱 내부에 생성되며, Hanger 앱 삭제 시 저장된 백업 파일도 함께 삭제됩니다.\n\n기기를 잃어버리거나 새로운 기기로 교체하실 때 사용자의 데이터를 복원할 수 있도록 생성된 백업 파일을 '파일'앱 > 'iCloud Drive' 또는 안전한 위치로 옮겨주세요.\n\n데이터 크기에 따라 다소 시간이 걸릴 수 있습니다. 진행 중에 앱을 종료하거나 다른 앱으로 이동하지 말고 잠시만 기다려 주세요.\n\n성공적인 백업, 복구를 위해 파일명은 변경하지 마시기 바랍니다."
            
        case .support:
            return "기본 Mail 앱에 메일 계정이 등록되어야 사용할 수 있습니다."
        case .Information:
            return ""
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
        applyInitialSnapshots()
        
        self.mainView.collectionView.delegate = self
    }
}

extension PreferencesViewController {
    
    private func configureDataSourse() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { [weak self] cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier)"
            content.secondaryText = indexPath.section == self?.dataSource.indexPath(for: Section.Information.numberOfItem[0])?.section ? self?.getCurrentAppVersion() : nil
            
            //content.image = UIImage(systemName: "star")
            //content.imageProperties.tintColor = .systemOrange
            cell.contentConfiguration = content
            cell.accessories = indexPath.section == self?.dataSource.indexPath(for: Section.Information.numberOfItem[0])?.section ? [] : [.disclosureIndicator()]
        }
        
        // header
        //        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
        //            var content = UIListContentConfiguration.groupedHeader()
        //            content.text = "\(Section.allCases[indexPath.section].header)"
        //            supplementaryView.contentConfiguration = content
        //        }
        
        // footer
        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            var content = UIListContentConfiguration.groupedFooter()
            content.text = indexPath.section == 0 ? "\(Section.backupRestore.footer)" : nil
            supplementaryView.contentConfiguration = content
            //supplementaryView.backgroundColor = .red
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: self.mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            
            //return elementKind == UICollectionView.elementKindSectionHeader ? collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath) : collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
            
        }
    }
    
    private func applyInitialSnapshots() {
        
        for section in Section.allCases {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
            let items = section.numberOfItem
            sectionSnapshot.append(items)
            dataSource.apply(sectionSnapshot, to: section, animatingDifferences: true)
        }
    }
    
    //        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    //        snapshot.appendSections([.backupRestore])
    //        //snapshot.appendItems([Section.backupRestore.description])
    //        snapshot.appendItems(Section.backupRestore.numberOfItem, toSection: .backupRestore)
    //
    //        snapshot.appendSections([.support])
    //        snapshot.appendItems(Section.support.numberOfItem, toSection: .support)
    //
    //        snapshot.appendSections([.Information])
    //        snapshot.appendItems(Section.Information.numberOfItem, toSection: .Information)
    //        dataSource.apply(snapshot)
    //
}


extension PreferencesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case Section.backupRestore.numberOfItem[0] : // 데이터 백업
            print(item)
        case Section.backupRestore.numberOfItem[1] : // 데이터 복원
            print(item)
        case Section.support.numberOfItem[0] : // 문의하기
            print(item)
            sendFeedback()
        case Section.support.numberOfItem[1] : // 리뷰남기기
            print(item)
            openAppStore(appleID: "1645004892")
        case Section.Information.numberOfItem[0]: // 버전
            print(item)
        default :
            print("")
        }
        
        
        
    }
}

// MARK: - 문의하기 & 리뷰 남기기
extension PreferencesViewController {
    
    private func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            let message = """
                          내용:
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          ---
                          iOS 버전: \(UIDevice.current.systemVersion)
                          Hanger 버전: \(getCurrentAppVersion())
                          """
            
            mail.setToRecipients(["idhun90@me.com"])
            mail.setSubject("[Hanger] 문의")
            mail.setMessageBody(message, isHTML: false)
            mail.mailComposeDelegate = self
            
            self.present(mail, animated: true)
            
        } else {
            
            print("문의하기 실패")
            let sendMailErrorAlert = UIAlertController(title: "기본 Mail 앱에 메일 계정이 추가되어 있지 않습니다.", message: "기본 Mail 앱에 메일 계정을 추가하시겠습니까?", preferredStyle: .actionSheet)
            
            let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
            let cancel = UIAlertAction(title: "취소", style: .destructive)
            
            sendMailErrorAlert.addAction(goSetting)
            sendMailErrorAlert.addAction(cancel)
            self.present(sendMailErrorAlert, animated: true)
            
        }
    }
    
    // 현재 사용 중인 버전
    private func getCurrentAppVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let appVersion = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return appVersion
    }
    
//    func checkCurrentAppVersion() -> Bool {
//        let currentVersion = getCurrentAppVersion()
//    }
    
    private func openAppStore(appleID: String) {
        let url = "itms-apps://itunes.apple.com/app/itunes-u/id\(appleID)?ls=1&mt=8&action=write-review"
        if let reviewURL = URL(string: url), UIApplication.shared.canOpenURL(reviewURL) {
            UIApplication.shared.open(reviewURL)
        }
    }
    
}

extension PreferencesViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true)
    }
}
