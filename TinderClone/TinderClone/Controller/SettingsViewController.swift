//
//  SettingsController.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let headerView = SettingsHeaderView()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        print("done button tapped")
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
        
        // 선택된 사진 업데이트 해야함
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
    
}
