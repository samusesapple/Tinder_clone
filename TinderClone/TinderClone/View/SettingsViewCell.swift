//
//  SettingsViewCell.swift
//  TinderClone
//
//  Created by Sam Sung on 2023/04/07.
//

import UIKit

protocol SettingsViewCellDelegate: AnyObject {
    func settingsCell(_ cell: SettingsViewCell, updateUserDataWith updateValue: String, for section: SettingsSection)
    func settingsCell(_ cell: SettingsViewCell, updateAgeRangeWith sender: UISlider)
}

class SettingsViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: SettingsViewModel! { // tableView cellForRowAt() 의해 viewModel이 세팅 될 때마다 호출되도록
        didSet {
            configureUI()
        }
    }
    weak var delegate: SettingsViewCellDelegate?
    
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(updateUserInfoWithTF), for: .editingDidEnd)
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
        
        selectionStyle = .none
        
        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
        // axis의 default값은 horizontal
        let minSliderStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        minSliderStack.spacing = 24
        
        let maxSliderStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        maxSliderStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minSliderStack, maxSliderStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        
        contentView.addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    @objc func ageRangeDidChanged(sender: UISlider) {
        if sender == minAgeSlider {
            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
        } else {
            maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: sender.value)
        }
        delegate?.settingsCell(self, updateAgeRangeWith: sender)
    }
    
    @objc func updateUserInfoWithTF(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, updateUserDataWith: value, for: viewModel.section)
    }
    
    // MARK: - Helpers
    func configureUI() {
        // 세팅된 viewModel로 UI 세팅하기
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
        
        // viewModel의 placeholderText로 placeholder문구 세팅
        inputField.placeholder = viewModel.placeholderText
        // viewModel의 userInfoValue로 텍스트 표시
        inputField.text = viewModel.userInfoValue
        
        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
        minAgeLabel.text = viewModel.minAgeLabelText(forValue: viewModel.minAgeSliderValue)
        maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)
    }
    
    func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(ageRangeDidChanged), for: .valueChanged)
        return slider
    }

    
}
