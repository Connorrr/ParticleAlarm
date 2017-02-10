//
//  DaisyTableCell.swift
//  Particle-Alarm
//
//  Created by Connor Reid on 9/2/17.
//  Copyright © 2017 LongGames. All rights reserved.
//

import UIKit

class DCTableViewCell: UITableViewCell {
    
    override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?){
        self.init(style: style, reuseIdentifier: reuseIdentifier, colour: Colours.mustard)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, colour: UIColor?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = colour
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
