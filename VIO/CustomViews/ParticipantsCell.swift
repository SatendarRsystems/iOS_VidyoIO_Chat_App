//
//  ParticipantsCell.swift
//  VIO
//
//  Created by Arun Kumar on 27/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class ParticipantsCell: UITableViewCell {
    @IBOutlet weak var lblInitialLetter: UILabel!
    @IBOutlet weak var lblParticipantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
