//
//  LiftingCommnetViewController.swift
//  onemoretimer
//
//  Created by 고종찬 on 2021/02/24.
//

import UIKit

class LiftingCommentViewController: UIViewController {
    
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var buttonInsertComment: UIButton!
    
    var db:DBHelper = DBHelper()
    
    var getRound = 0
    var getRestTime = 0
    var getCurrentTime = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Shape
        textViewComment.layer.borderWidth = 1
        textViewComment.layer.masksToBounds = true
        textViewComment.layer.cornerRadius = 8
        buttonInsertComment.layer.masksToBounds = true
        buttonInsertComment.layer.cornerRadius = 20
       
        // show workout result
        let minute = getRestTime / 60
        let second = getRestTime % 60
        var stringWorkTime = ""
        
        if minute > 10 {
            if second < 10 {
                stringWorkTime = "\(minute):0\(second)"
            }else{
                stringWorkTime = "\(minute):\(second)"
            }
        }else{
            if second < 10 {
                stringWorkTime = "0\(minute):0\(second)"
            }else{
                stringWorkTime = "0\(minute):\(second)"
            }
        }
        labelCurrentTime.text = getCurrentTime
        labelResult.text = "휴식 \(stringWorkTime) / \(getRound)라운드"
    }
    

   
    // from segue
    func receiveItem(_ round: Int,_ restTime: Int, _ time: String) {
        getRound = round
        getRestTime = restTime
        getCurrentTime = time
    }
    
    
    // Insert Function
    @IBAction func buttonInsertComment(_ sender: UIButton) {
        let InsertExerciseComment: String = textViewComment.text!.trimmingCharacters(in: .whitespaces)
        
        // comment update
        db.updateByID(exerciseWhen: getCurrentTime, exerciseComment: InsertExerciseComment)
        print(db.read())
        performSegue(withIdentifier: "segueUnwindLiftingTimer", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
}
