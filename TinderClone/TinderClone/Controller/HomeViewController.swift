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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configuerUI()
    }
    
    // MARK: - Helpers
    func configuerUI() {
        view.backgroundColor = .white
        
        view.addSubview(topStackView)
        topStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }

}
