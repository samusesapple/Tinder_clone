//
//  SettingsController.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import UIKit
import JGProgressHUD

protocol SettingsViewControllerDelegate: AnyObject {
    func updateUserData(_ controller: SettingsViewController, userData: User)
    func settingsVCLogout(_ controller: SettingsViewController)
}

class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
    private var user: User // HomeVC에서 받은 use data를 받을 인스턴스
    
    private lazy var headerView = SettingsHeaderView(user: user)
    private let footerView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - Lifecycle
    init(user: User) {  // HomeVC에서 받은 use data를 전달 받을 수 있도록 custom initializer 생성
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Your Data"
        hud.show(in: view)
        
        // API에 새로 담긴 user 정보 update + local앱에 user정보 update (다시 네트워킹 요청해서 user정보 불러오기 x)
        Service.saveUserData(user: user) { [weak self] error in
            self?.delegate?.updateUserData(self!, userData: self!.user)
        }
        
        
    }
    
    // MARK: - API
    
    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading Image.."
        hud.show(in: view)
        
        Service.uploadImage(image: image) { imageURL in
            // 새로운 이미지를 user의 imageURL 배열에 추가
            print("upload NEW IMAGE")
            self.user.imageURLs.append(imageURL)
            hud.dismiss(animated: true)
        }
    }
    
    func updateImage(image: UIImage, index: Int) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading Image.."
        hud.show(in: view)
        
        Service.uploadImage(image: image) { imageURL in
            // index에 해당되는 버튼에 이미지가 있다면, 기존 imageURL을 새로운 url로 대치
            print("updateImage - UPDATE \(index)'s IMAGE")
            self.user.imageURLs[index] = imageURL
            
            hud.dismiss(animated: true)
        }
    }
    
    
    // MARK: - Helpers
    
    func setHeaderImage(_ image: UIImage) {
        headerView.buttonsArray[imageIndex].setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: "SettingsViewCell")
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
    }
    
    
}


// MARK: - UITableViewDataSource
extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsViewCell") as! SettingsViewCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell }
        // HomeVC에서 전달받은 user 데이터를 바탕으로 cell의 ViewModel 생성
        let viewModel = SettingsViewModel(user: user, section: section)
        // cell의 viewModel 세팅해주기
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0 }
        return section == .ageRange ? 96 : 44
    }
    
}


// MARK: - SettingsHeaderViewDelegate

extension SettingsViewController: SettingsHeaderViewDelegate {
    func settingsHeaderImageTapped(_ header: SettingsHeaderView, didSelect index: Int) {
        imageIndex = index
        present(imagePicker, animated: true)
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지 선택 완료 후 실행되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        // 빈 버튼의 이미지 선택하면, 데이터베이스에 url 업로드
        if headerView.buttonsArray[imageIndex].imageView?.image == nil {
            uploadImage(image: selectedImage)
            print("imagePickerController - imageIndex : \(imageIndex)")
        } else {
            // 기존과 동일한 이미지를 선택하면, 함수 종료
            if selectedImage == headerView.buttonsArray[imageIndex].imageView?.image { return }
            
            // 새로운 이미지를 선택하면, 데이터베이스에 새로운 이미지url 업로드
            updateImage(image: selectedImage, index: imageIndex)
        }
        // 선택된 사진 업데이트 해야함
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
    
}
// MARK: - SettingsViewCellDelegate

extension SettingsViewController: SettingsViewCellDelegate {
    func settingsCell(_ cell: SettingsViewCell, updateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCell(_ cell: SettingsViewCell, updateUserDataWith updateValue: String, for section: SettingsSection) {
        switch section {
            
        case .name:
            user.name = updateValue
        case .profession:
            user.profession = updateValue
        case .age:
            user.age = Int(updateValue) ?? user.age
        case .bio:
            user.bio = updateValue
        case .ageRange:
            break
        }
    }
    
}

extension SettingsViewController: SettingsFooterDelegate {
    func handleLogout() {
        delegate?.settingsVCLogout(self)
        print("로그아웃 완료")
    }
    
    
}
