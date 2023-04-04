//
//  LoginController.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/02.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecuredText: true)
    
    private let authButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [.foregroundColor : UIColor.white, .font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegister), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Actions
    @objc func handleLogin() {
        print("DEBUG: Login Button Tapped")
    }
    @objc func handleShowRegister() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black

        configureGradientLayer()
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 100, width: 100)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
  
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    

}
