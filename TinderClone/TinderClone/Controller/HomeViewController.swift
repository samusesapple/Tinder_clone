//
//  HomeViewController.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/03/30.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private let topStackView = HomeNaviagtionStackView()
    
    private let deckView: UIView = {
       let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let bottomStackView = BottomControlsStackView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCards()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let mainStack = UIStackView(arrangedSubviews: [topStackView, deckView, bottomStackView])
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        mainStack.bringSubviewToFront(deckView)

    }
    
    func configureCards() {
        let user1 = User(name: "Jane Doe", age: 21, images: [#imageLiteral(resourceName: "jane3"), #imageLiteral(resourceName: "jane2")])
        let user2 = User(name: "Megan Charles", age: 22, images: [#imageLiteral(resourceName: "lady5c"), #imageLiteral(resourceName: "kelly1")])
        
        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
        let cardView2 = CardView(viewModel: CardViewModel(user: user2))
        
        
        deckView.addSubview(cardView1)
        deckView.addSubview(cardView2)
        
        cardView1.fillSuperview()
        cardView2.fillSuperview()
    }
    
    
}
