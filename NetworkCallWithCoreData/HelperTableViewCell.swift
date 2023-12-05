//
//  HelperTableViewCell.swift
//  NetworkCallWithCoreData
//
//  Created by Refat E Ferdous on 12/5/23.
//

import UIKit

class HelperTableViewCell: UITableViewCell {

    @IBOutlet var id : UILabel!
    @IBOutlet var title : UILabel!
    @IBOutlet var price : UILabel!
    @IBOutlet var des : UILabel!
    @IBOutlet var category : UILabel!
    @IBOutlet var rate : UILabel!
    @IBOutlet var count : UILabel!
    @IBOutlet var myImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
