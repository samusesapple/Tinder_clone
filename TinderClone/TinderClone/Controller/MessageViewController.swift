//
//  MessageViewController.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/14.
//

import UIKit

class MessageViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    private let headerView = MatchHeaderCollectionView()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
    }
    
    func configureNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        leftButton.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped))
        leftButton.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let messageIcon = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate))
        messageIcon.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        navigationItem.titleView = messageIcon
    }
    
}
// MARK: - UITableViewDataSource
extension MessageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MessageViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label: UILabel = {
            let label = UILabel()
            label.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            label.text = "Messages"
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }

}
