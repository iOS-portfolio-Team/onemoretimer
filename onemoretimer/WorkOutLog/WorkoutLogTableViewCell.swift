//
//  WorkoutLogTableViewCell.swift
//  onemoretimer
//
//  Created by dev on 2021/02/23.
//

import UIKit

class WorkoutLogTableViewCell: UITableViewCell {

   
    @IBOutlet weak var exerciseName: UILabel!
    // 운동명 넣는곳
    
    @IBOutlet weak var exerciseImage: UIImageView!
    // 운동명에 따라 각기 다른 이미지 출력

    @IBOutlet weak var exerciseWhenDate: UILabel!
    // 날짜 출력
    
    @IBOutlet weak var exerciseWhenTime: UILabel!
    // 시간출력
    @IBOutlet weak var exerciseJudgment: UILabel!
    // 운동중단했는지 판단 여부
    
    @IBOutlet weak var exerciseComment: UILabel!
    // 운동 코멘트
    @IBOutlet weak var exerciseSequenceNumber: UILabel!
    // 히든으로 처리된 시퀀스 넘버 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
