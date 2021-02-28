//
//  InputViewController.swift
//  onemoretimer
//
//  Created by dev on 2021/02/23.
//

import UIKit

class InputViewController: UIViewController {
    
   // 여기는 그냥 설명용입니다. 일부러 연결 안했으니 걱정 노노해요

    @IBOutlet weak var updateComment: UITextView!
   
    var db:DBHelper = DBHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func InsertBtn(_ sender: UIButton) {
    
        
        let InsertExerciseName: String = "TABATA"
        // 운동 이름 꼭꼭 대문자여야함 안지키면 혼난다
        
        let InsertExerciseHow: String = " / 00:20 min"
        // 운동을 어떻게 했는지
        
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yy-MM-dd / HH:mm:ss"
        let current_year_string = formatter_year.string(from: Date())
        //현재 시간 출력

        let InsertExerciseWhen: String = current_year_string
        // 언제 운동했는지 위에서 찍은 시간 그대로 입력
        
        let InsertExerciseJudgment: String = "중단했습니다."
        // 중단했는지 여부
        // 중단했으면 중단했습니다. 중단 안했으면 그냥 빈값
        
        let InsertExerciseComment: String = "진심 레이아웃 개같다 ^^"
        
        // id 는 시퀀스 넘버로, 0으로 입력해놓으면 AI
        db.insert(exerciseSequenceNumber: 0, exerciseName: "\(InsertExerciseName)", exerciseHow: "\(InsertExerciseHow)", exerciseWhen: "\(InsertExerciseWhen)", exerciseJudgment: "\(InsertExerciseJudgment)", exerciseComment: "\(InsertExerciseComment)")
        
    }
    
    
    
//    @IBAction func updateBtn(_ sender: UIButton) {
//        
//        let InsertExerciseComment: String = updateComment.text!
//        db.updateByID(exerciseSequenceNumer: 1, // 임의로 인덱스번호 선언함
//         exerciseComment: "\(InsertExerciseComment)")
//        
//    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
