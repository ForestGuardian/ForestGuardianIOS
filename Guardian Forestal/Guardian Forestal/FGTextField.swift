//
//  FGTextField.swift
//  Guardian Forestal
//
//  Created by Luis Alonso Murillo Rojas on 16/9/17.
//  Copyright © 2017 Forest Guardian. All rights reserved.
//

import UIKit

@IBDesignable
class FGTextField: UIView {
    
    //MARK: Interface builder attributes
    @IBInspectable var iconImage: String = "" {
        didSet {
            setupTextFieldViews()
        }
    }
    @IBInspectable var placeholderText: String = "" {
        didSet {
            setupTextFieldViews()
        }
    }
    @IBInspectable var keyboardType: Int = 0 {
        didSet {
            setupTextFieldViews()
        }
    }
    
    //MARK: Private attributes
    private var icon: UIImageView = UIImageView()
    private var textField: UITextField = UITextField()
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initTextFieldViews()
        setupTextFieldViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initTextFieldViews()
        setupTextFieldViews()
    }
    
    //MARK: Private Methods
    
    private func initTextFieldViews() {
        
        // Setup parent view
        self.backgroundColor = UIColor.clear
        
        // Create bottom border
        let borderWidth: CGFloat = 0.5
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        bottomBorder.backgroundColor = UIColor.white.cgColor
        self.layer.addSublayer(bottomBorder)
        
        // Create Horizontal StackView
        let leftMargin: CGFloat = 12.0
        let containerHeight: CGFloat = 20.0
        let container = UIStackView(frame: CGRect(x: leftMargin, y: (self.frame.size.height / 2) - (containerHeight / 2), width: self.frame.size.width - leftMargin, height: containerHeight))
        container.axis = UILayoutConstraintAxis.horizontal
        container.spacing = 21
        self.addSubview(container)
        
        // Create TextField icons
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: containerHeight).isActive = true
        icon.heightAnchor.constraint(equalToConstant: containerHeight).isActive = true
        container.addArrangedSubview(icon)
        
        // Create TextField
        textField.textColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: self.frame.size.width - (icon.frame.size.width + container.spacing + leftMargin))
        textField.heightAnchor.constraint(equalToConstant: containerHeight)
        container.addArrangedSubview(textField)
    }
    
    private func setupTextFieldViews() {
        // Set the icon image
        icon.image = UIImage(named: iconImage)
        
        // Set the TextField placeholder
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        switch keyboardType {
        case 0:
            textField.keyboardType = UIKeyboardType.default
            break
        case 1:
            textField.keyboardType = UIKeyboardType.emailAddress
            break
        case 2:
            textField.keyboardType = UIKeyboardType.default
            textField.isSecureTextEntry = true
        default:
            textField.keyboardType = UIKeyboardType.default
        }
    }

}
