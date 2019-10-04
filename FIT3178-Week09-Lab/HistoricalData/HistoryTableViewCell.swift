//
//  HistoryTableViewCell.swift
//  FIT3178-Week09-Lab
//
//  Created by Poornima Sivakumar on 2/10/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var tImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tempReading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
