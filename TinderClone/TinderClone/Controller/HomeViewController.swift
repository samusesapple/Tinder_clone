//
//  HomeViewController.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/03/30.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private let topStackView = HomeNavigationStackView()
    
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
        checkIfUserIsLoggedIn()
        configureUI()
        configureCards()
//        logOut()
        fetchUser()
    }
    
    // MARK: - API
    
    func fetchUser() {
        // 최근 유저의 uid가 있는지 확인 후,
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUID: uid) { user in
            print("fetch user OK - fetched user name : \(user.name)")
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("User 로그인 완료")
        }
    }
    
    func logOut() {
        do {
           try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("로그아웃 실패")
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        let mainStack = UIStackView(arrangedSubviews: [topStackView, deckView, bottomStackView])
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        mainStack.bringSubviewToFront(deckView)

    }
    
    func configureCards() {
//        let user1 = User(name: "Jane Doe", age: 21, images: [#imageLiteral(resourceName: "jane3"), #imageLiteral(resourceName: "jane2")])
//        let user2 = User(name: "Megan Charles", age: 22, images: [#imageLiteral(resourceName: "lady5c"), #imageLiteral(resourceName: "kelly1")])
//        
//        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
//        let cardView2 = CardView(viewModel: CardViewModel(user: user2))
//        
//        
//        deckView.addSubview(cardView1)
//        deckView.addSubview(cardView2)
//        
//        cardView1.fillSuperview()
//        cardView2.fillSuperview()
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let loginController = LoginController()
            let nav = UINavigationController(rootViewController: loginController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }
}
