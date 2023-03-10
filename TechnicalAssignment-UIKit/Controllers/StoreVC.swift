//
//  StoreVC.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 08/03/23.
//

import UIKit

class StoreVC: UIViewController {
    
    let storeData = StoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setupUI(){
        navigationItem.titleView = navStackView
        
        view.addSubview(collectionView)
        collectionView.pinToSafeArea(of: view)
        
        NSLayoutConstraint.activate([
            navStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            storeLbl.centerYAnchor.constraint(equalTo: profileImg.centerYAnchor)
        ])
    }
    
    
    
    //MARK: Page elements
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createVerticalFlowLayout(in: view))
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
        cv.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalCollectionViewCell.identifier)
        cv.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var navStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeLbl, profileImg])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private lazy var profileImg: UIImageView = {
        let img = UIImageView()
        img.image = K.Images.avatar
        return img
    }()
    
    private lazy var storeLbl: UILabel = {
        let lbl = TextLabel(textAlignment: .left, font: UIFont(name: K.Fonts.nimbus_bold, size: 26), textColor: .white, text: K.Strings.store)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
}



extension StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return storeData.data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.identifier, for: indexPath) as! HorizontalCollectionViewCell
        let cards = storeData.data[indexPath.section].cards
        cell.passData(cards)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellHeight = collectionView.frame.height * 0.5
        
        return CGSize(width: collectionViewWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.identifier, for: indexPath) as! HeaderReusableView
        let data = storeData.data[indexPath.section]
        header.title.text = data.headerTitle
        header.subTitle.text = data.headerSubtitle
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let headerHeight = screenHeight * 0.1 // 10% of screen height
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
}






