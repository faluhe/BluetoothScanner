//
//  CollectionReusableView.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 09/03/23.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    static let identifier = "CollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        addSubviews(stackView, seeAllBtn)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            seeAllBtn.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            seeAllBtn.centerYAnchor.constraint(equalTo: title.centerYAnchor)
        ])
        
    }
    
    
    //MARK: - Page elements
    lazy var title: UILabel = {
        let lbl = TextLabel(textAlignment: .left, font: UIFont(name: "Gibson-Bold", size: 18), textColor: .white, text: " ")
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    lazy var subTitle: UILabel = {
        let lbl = TextLabel(textAlignment: .left, font: UIFont(name: "Gibson-Regular", size: 16), textColor: .appGray, text: " ")
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    lazy var seeAllBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("See all", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Gibson-Regular", size: 18)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, subTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
}
