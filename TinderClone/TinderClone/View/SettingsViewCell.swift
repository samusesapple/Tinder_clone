//
//  SettingsViewCell.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import UIKit

class SettingsViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: SettingsViewModel! {
        didSet {
            configureUI()
        }
    }
    
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "정보를 입력해주세요."
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()
    
    lazy var minAgeSlider = createAgeRangeSlider()
    lazy var maxAgeSlider = createAgeRangeSlider()
    
    var sliderStack = UIStackView()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        minAgeLabel.text = "Min: 18"
        maxAgeLabel.text = "Max: 60"
        
        addSubview(inputField)
        inputField.fillSuperview()
        
        // axis의 default값은 horizontal
        let minSliderStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        minSliderStack.spacing = 24
        
        let maxSliderStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        maxSliderStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minSliderStack, maxSliderStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        
        addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func ageRangeDidChanged() {
        
    }
    
    // MARK: - Helpers
    
    func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(ageRangeDidChanged), for: .valueChanged)
        return slider
    }
    
    func configureUI() {
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
    }
    
    
}
