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
    private var user: User? {
        didSet {
            print("HomeVC - \(String(describing: user?.name))")
        }
    }
    
    private let topStackView = HomeNavigationStackView()
    private let bottomStackView = BottomControlsStackView()
    
    private var viewModels = [CardViewModel]() {
        didSet {
            configureCards()
        }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        // 접속한 유저 정보 + 전체 유저 정보 데이터를 Firebase에서 받아옴
        fetchUser()
        fetchWholeUsers()
        configureUI()
    }
    
    // MARK: - API
    
    func fetchUser() {
        
        // 최근 유저의 uid가 있는지 확인 후, 있으면 해당되는 유저 데이터 받기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUID: uid) { user in
            self.user = user
        }
    }
    
    func fetchWholeUsers() {
        Service.fetchWholeUsers { users in
            self.viewModels = users.map { CardViewModel(user: $0) }
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
        topStackView.delegate = self
        
        
        let mainStack = UIStackView(arrangedSubviews: [topStackView, deckView, bottomStackView])
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        mainStack.bringSubviewToFront(deckView)
        
    }
    
    func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
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

// MARK: - HomeNavigationStackViewDelegate

extension HomeViewController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user = self.user else { return }
        // settingVC에 받아놓은 최근 user 데이터를 전달
        let settingVC = SettingsViewController(user: user)
        settingVC.delegate = self
        let naviVC = UINavigationController(rootViewController: settingVC)
        naviVC.modalPresentationStyle = .fullScreen
        present(naviVC, animated: true)
    }
    
    func showMessages() {
        print("show Messages")
    }
    
    
}

// MARK: - SettingsViewControllerDelegate

extension HomeViewController: SettingsViewControllerDelegate {
    func updateUserData(_ controller: SettingsViewController, userData: User) {
        controller.dismiss(animated: true)
        self.user = userData
    }
    
    
    
}
