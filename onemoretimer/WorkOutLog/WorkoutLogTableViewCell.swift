//
//  WorkoutLogTableViewCell.swift
//  onemoretimer
//
//  Created by dev on 2021/02/23.
//

import UIKit

class WorkoutLogTableViewCell: UITableViewCell {

   
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseWhenDate: UILabel!
    @IBOutlet weak var exerciseWhenTime: UILabel!
    @IBOutlet weak var exerciseJudgment: UILabel!
    @IBOutlet weak var exerciseComment: UILabel!
    @IBOutlet weak var exerciseSequenceNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
