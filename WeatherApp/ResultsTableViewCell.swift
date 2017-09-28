//
//  ResultsTableViewCell.swift
//  WeatherApp
//
//  Created by Aicha Diallo on 6/20/17.
//  Copyright © 2017 Aicha Diallo. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    
    
    @IBOutlet var thumbnailImageView: UIImageView!
    
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
