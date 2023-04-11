//
//  SegementBarView.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/11.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(numberOfSegment: Int) {
        super.init(frame: .zero)
        
        (0..<numberOfSegment).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            addArrangedSubview(barView)
        }
        
        spacing = 4
        distribution = .fillEqually
        
        arrangedSubviews.first?.backgroundColor = .white
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach { $0.backgroundColor = .barDeselectedColor }
        arrangedSubviews[index].backgroundColor = .white
    }
    
    
}
