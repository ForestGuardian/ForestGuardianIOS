//
//  FGButton.swift
//  Guardian Forestal
//
//  Created by Luis Alonso Murillo Rojas on 17/9/17.
//  Copyright © 2017 Forest Guardian. All rights reserved.
//

import UIKit

@IBDesignable
class FGButton: UIView {
    
    //MARK: Interface builder attributes
    @IBInspectable var enabled: Bool = true {
        didSet {
            initViews()
        }
    }
    @IBInspectable var text: String = "" {
        didSet {
            initViews()
        }
    }
    
    //MARK: Private attributes
    private var button: UIButton = UIButton()

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initViews()
    }
    
    //MARK: Private methods
    private func initViews() {
        
        // Setup container
        self.backgroundColor = enabled ? UIColor(red:0.6, green:0.78, blue:0.13, alpha:1) : UIColor.darkGray
        self.layer.cornerRadius = 25.0
        
        // Create the internal button
        button.setTitle(text, for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(button)
    }

}
