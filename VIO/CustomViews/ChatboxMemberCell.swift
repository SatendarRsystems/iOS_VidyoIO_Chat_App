//
//  ChatboxMemberCell.swift
//  VIO
//
//  Created by Arun Kumar on 01/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class ChatboxMemberCell: UITableViewCell {

    @IBOutlet weak var lblMemberIntialLetter: UILabel!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMemberMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
