//
//  CheckmarkButton.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class CheckmarkButton: UIButton {
    
    private var checked = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        clicked()
    }
    
    func clicked() {
        if checked {
            setImage(UIImage.init(named: "CheckboxEmpty"), for: .normal)

            self.checked = false
        } else if checked == false {

            self.setImage(UIImage.init(named: "CheckboxChecked"), for: .normal)
            self.checked = true
        }
    }
    
    func setChecked(_ check : Bool) {
        self.checked = check
        if checked {
           self.setImage(UIImage.init(named: "CheckboxChecked"), for: .normal)
        } else {
            self.setImage(UIImage.init(named: "CheckboxEmpty"), for: .normal)
        }
    }
    
    func isChecked() -> Bool {
        return checked
    }
    
}

