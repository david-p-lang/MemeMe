//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by David Lang on 4/26/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /// Resign first responder
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Text customizations
    ///
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let imputText = textField.text! as NSString
        textField.text = imputText.replacingCharacters(in: range, with: string.uppercased())
        
        return false
    }
    
    /// Clear text at the start of edit
    ///
    /// - Parameter textField: text contents
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
}

