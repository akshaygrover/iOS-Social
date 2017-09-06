//
//  customImageView.swift
//  iOS-Social
//
//  Created by akshay Grover on 2017-07-07.
//  Copyright © 2017 akshay Grover. All rights reserved.
//

import UIKit

class customImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.7).cgColor
        
        layer.shadowOpacity = 0.8
        
        layer.shadowRadius = 5.0
        
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }

    override func layoutSubviews() {
     super.layoutSubviews()
        
    layer.cornerRadius = self.frame.width/2
        
        clipsToBounds = true
    }

}
