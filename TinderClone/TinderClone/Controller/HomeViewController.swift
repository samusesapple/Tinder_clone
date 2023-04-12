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
    private var user: User?
    
    private let topStackView = HomeNavigationStackView()
    private let bottomStackView = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
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
        bottomStackView.delegate = self
        
        
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
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        cardViews = deckView.subviews.map{ ($0 as? CardView)! }
        topCardView = cardViews.last
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let loginController = LoginController()
            let nav = UINavigationController(rootViewController: loginController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 500 : -500
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width:
                                                (self.topCardView?.frame.width)!,
                                             height: (self.topCardView?.frame.height)!)
        }) { _ in
            self.topCardView?.removeFromSuperview()
            
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
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
    
    func settingsVCLogout(_ controller: SettingsViewController) {
        controller.dismiss(animated: true)
        logOut()
    }
    
}
// MARK: - CardViewDelegate

extension HomeViewController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: {view == $0}) // views배열에서 view와 일치하는 view 제거
        
        guard let user = topCardView?.viewModel.user else { return }
        Service.saveSwipe(forUser: user, isLike: didLikeUser)
        
        self.topCardView = cardViews.last // cardViews의 맨 마지막에 있는 카드를 topCardView에 두기 (앞으로 끌어와서 보여줘서 다음 cardView 세팅)
    }
    
    func showInfoView(_ view: CardView, wantsToShowProfile user: User) {
        let profileVC = ProfileViewController(user: user)
        profileVC.delegate = self
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true)
    }
    
}

// MARK: - BottomControlsStackViewDelegate

extension HomeViewController: BottomControlsStackViewDelegate {
    func handleRefresh() {
        print(#function)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false)
    }
    
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: true)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: true)
    }
}

extension HomeViewController: ProfileViewControllerDelegate {
    func profileController(_ controller: ProfileViewController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            Service.saveSwipe(forUser: user, isLike: true)
            self.performSwipeAnimation(shouldLike: true)
        }
    }
    
    func profileController(_ controller: ProfileViewController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            Service.saveSwipe(forUser: user, isLike: false)
            self.performSwipeAnimation(shouldLike: false)
        }
    }
    
    
}
