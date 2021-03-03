//
//  AmrapCommentViewController.swift
//  onemoretimer
//
//  Created by 최지석 on 2021/02/27.
//

import UIKit

class AmrapCommentViewController: UIViewController {

    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var buttonInsertComment: UIButton!
    
    var db:DBHelper = DBHelper()
    var getRound = 0
    var getTime = ""
    var currentTime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //UI Shape
        textViewComment.layer.borderWidth = 1
        textViewComment.layer.masksToBounds = true
        textViewComment.layer.cornerRadius = 8
        buttonInsertComment.layer.masksToBounds = true
        buttonInsertComment.layer.cornerRadius = 20
       
        textViewComment.backgroundColor = UIColor.white
        
        // show workout result
        let minute = Int(getTime)! / 60
        let second = Int(getTime)! % 60
        
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
       
        

        labelCurrentTime.text = currentTime
        labelResult.text = "\(stringWorkTime) / \(getRound) 라운드"
        
        
    }
        
    // from segue
    func receiveItem(_ round: Int, _ worktime: String,_ time: String) {
        getRound = round
        currentTime = worktime
        getTime = time
     
    }
        
    // Insert Function
    @IBAction func buttonInsertComment(_ sender: UIButton) {
        let InsertExerciseComment: String = textViewComment.text!.trimmingCharacters(in: .whitespaces)
        // comment update
        db.updateByID(exerciseWhen: currentTime , exerciseComment: InsertExerciseComment)

        performSegue(withIdentifier: "unwindAmrapTimer", sender: self)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

