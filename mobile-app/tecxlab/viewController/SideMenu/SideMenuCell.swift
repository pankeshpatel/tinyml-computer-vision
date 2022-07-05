//
//  SideMenuCell.swift
//  tecxlab
//
//  Created by bhavin joshi on 29/08/21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgMenu : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
