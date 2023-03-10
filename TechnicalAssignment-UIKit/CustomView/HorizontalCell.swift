//
//  HorizontalCell.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 10/03/23.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "HorizontalCollectionViewCell"
    private var cards: [Cards] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .red
        contentView.addSubview(horizontalCollectionView)
        horizontalCollectionView.pinToEdges(of: contentView)
    }
    
    
    func passData(_ data: [Cards]){
        cards = data
    }
    
    
    //MARK: Page elements
    private lazy var horizontalCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHorizontalFlowLayout(in: contentView))
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
}



extension HorizontalCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        let card = self.cards[indexPath.row]
        cell.configureUI(card)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let card = self.cards[indexPath.row]
        if card.price == nil{
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
        }
        return CGSize(width: collectionView.frame.width * 0.60, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
