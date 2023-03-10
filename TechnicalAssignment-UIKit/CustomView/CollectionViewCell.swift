//
//  CollectionViewCell.swift
//  TechnicalAssignment-UIKit
//
//  Created by Ismailov Farrukh on 09/03/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CollectionViewCell"
    
    let blurEffectView = UIVisualEffectView(effect: nil)
    var imgHeightConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI(){
        contentView.addSubviews(img, lineView, blurView)
        blurView.addSubviews(leftStackView, rightStackView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.appGray?.withAlphaComponent(0.3).cgColor
        contentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: contentView.topAnchor),
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            img.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.frame.size.height * 0.3)),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.widthAnchor.constraint(equalTo: img.widthAnchor),
            
            leftStackView.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 15),
            leftStackView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor,constant: 16),
            leftStackView.trailingAnchor.constraint(equalTo: rightStackView.leadingAnchor,constant: -16),
            leftStackView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor,constant: -15),
            rightStackView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor,constant: -16),
            rightStackView.centerYAnchor.constraint(equalTo: leftStackView.centerYAnchor),
            
            buyButton.widthAnchor.constraint(equalToConstant: 65),
            
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    func configureUI(_ card: Cards){
        img.image = card.img
        title.text = card.name
        subTitle.text = card.subtitle
        blurEffectView.effect = nil
        
        
        if card.subtitle == nil && card.instalment != nil{
            subTitle.text = "\(card.price ?? 0) USD or $\(card.instalment ?? 0)/mo"
        }
        
        //Checks button availability
        if card.isBtnAvailable != nil{
            rightStackView.isHidden = false
            if card.price != nil{
                price.text = "\(card.price ?? 0) USD"
            }else{
                price.isHidden = true
                title.font = UIFont(name: K.Fonts.gibson_bold, size: 26)
                
                blurEffectView.effect = UIBlurEffect(style: .dark)
                blurView.backgroundColor = .clear
                
                lineView.isHidden = true
                img.contentMode = .top
            }
        }
    }
    
    //MARK: -  Page elements
    private lazy var img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var title: UILabel = {
        let lbl = TextLabel(textAlignment: .left, font: UIFont(name: K.Fonts.gibson_bold, size: 16), textColor: .white, text: " ")
        lbl.numberOfLines = 2
        lbl.minimumScaleFactor = 0.1
        return lbl
    }()
    
    private lazy var subTitle: UILabel = {
        let lbl = TextLabel(textAlignment: .left, font: UIFont(name: K.Fonts.gibson_regular, size: 14), textColor: .appGray, text: " ")
        lbl.numberOfLines = 2
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    private lazy var price: UILabel = {
        let lbl = TextLabel(textAlignment: .left, font: UIFont(name: K.Fonts.gibson_regular, size: 14), textColor: .appDarkGray, text: " ")
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    private lazy var buyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(K.Strings.buy, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = .appOrange
        return btn
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appGray?.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, subTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buyButton, price])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
}



