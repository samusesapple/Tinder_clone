//
//  MatchHeaderView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/14.
//

import UIKit

private let cellIdentifier = "MessageMatchCell"

protocol MessageHeaderDelegate: AnyObject {
    func messageHeader(_ header: MessageHeaderCollectionView, wantsToStartChatWith uid: String)
}

class MessageHeaderCollectionView: UICollectionReusableView {
    
    var matches = [Match]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: MessageHeaderDelegate?
    
    private let newMatchesLabel: UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
       return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        // collectionView의 delegate, dataSource 세팅, cell 등록
        cv.delegate = self
        cv.dataSource = self
        cv.register(MessageMatchCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return cv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(newMatchesLabel)
        newMatchesLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(collectionView)
        collectionView.anchor(top: newMatchesLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12,paddingBottom: 24, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - UICollectionViewDataSource
extension MessageHeaderCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectionView에 사용할 cell dequeue하기 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageMatchCell
        let viewModel = MessageMatchCellViewModel(match: matches[indexPath.row])
        cell.viewModel = viewModel
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension MessageHeaderCollectionView: UICollectionViewDelegate {
    // 셀 선택되면 실행되는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = matches[indexPath.row].uid
        self.delegate?.messageHeader(self, wantsToStartChatWith: uid)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MessageHeaderCollectionView: UICollectionViewDelegateFlowLayout {
    // 매 인덱스마다 cell 사이즈 정해주기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}

