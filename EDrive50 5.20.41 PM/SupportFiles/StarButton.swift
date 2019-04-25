//
//  StarButton.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-04-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class StarButton: UIButton {

    private var filled = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    func fillStar() {
        setImage(UIImage.init(named: "FilledStar"), for: .normal)
        filled = false
    }
    
    func emptyStar() {
        setImage(UIImage.init(named: "EmptyStar"), for: .normal)
        filled = true
    }
    
    func isFilled() -> Bool {
        return filled
    }

}
