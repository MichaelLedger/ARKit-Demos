//
//  RoundedButton.swift
//  ARPainter
//
//  Created by MountainX on 2019/3/1.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = tintColor
        layer.cornerRadius = 8
        clipsToBounds = true
        setTitleColor(.white, for: [])
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? tintColor : .gray
        }
    }

}
