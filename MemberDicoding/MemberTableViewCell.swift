//
//  MemberTableViewCell.swift
//  MemberDicoding
//
//  Created by Gilang Ramadhan on 16/01/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var nameItem: UILabel!
    @IBOutlet weak var emailItem: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
