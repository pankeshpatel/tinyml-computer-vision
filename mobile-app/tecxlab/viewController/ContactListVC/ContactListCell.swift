//
//  ContactListCell.swift
//  TestApp
//
//  Created by Sanskar Management Pro on 9/3/21.
//

import UIKit

class ContactListCell: UITableViewCell {
    @IBOutlet weak var imgProfile : UIImageView!{
        didSet{
            self.imgProfile.layer.cornerRadius = 20
            self.imgProfile.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var btnDelete : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
