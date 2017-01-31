//
//  DCTextField.swift
//  Alarm-ios8-swift
//
//  Created by Connor Reid on 25/1/17.
//  Copyright © 2017 LongGames. All rights reserved.
//

import UIKit

class DCTextField: UITextField {
    
    convenience init(){
        self.init(frame: CGRect.zero, placeholderText: "")
    }
    
    init(frame: CGRect, placeholderText: String) {
        super.init(frame: frame)
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)])
        self.textAlignment = .center
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        self.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextFieldViewMode.whileEditing
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
