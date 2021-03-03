//
//  ForTimeComentViewController.swift
//  onemoretimer
//
//  Created by 정정이 on 2021/02/21.
//

import UIKit


class ForTimeCommentViewController: UIViewController {

    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelTotalTimeRound: UILabel!
    @IBOutlet weak var buttonInsertComment: UIButton!
    
    var db:DBHelper = DBHelper()
   
    var getRound = 0
    var getTime = 0
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
        let minute = getTime / 60
        
        var stringWorkTime = ""
        
        if minute > 10 {
            stringWorkTime = "\(minute):00"
        }else{
            stringWorkTime = "0\(minute):00"
        }
       
        
        labelCurrentTime.text = getCurrentTime
        labelTotalTimeRound.text = "\(stringWorkTime) / \(getRound) 라운드"
    }
    
    
 
    // from segue
    func receiveItem(_ round: Int, _ currentTime: String,_ time: Int) {
        getRound = round
        getCurrentTime = currentTime
        getTime = time
       
        
      
    }
    
    
    // Insert Function
    @IBAction func buttonInsertComent(_ sender: UIButton) {
        let InsertExerciseComment: String = textViewComment.text!.trimmingCharacters(in: .whitespaces)
        
        // comment update
        db.updateByID(exerciseWhen: getCurrentTime, exerciseComment: InsertExerciseComment)
        performSegue(withIdentifier: "unwindForTimeTimer", sender: self)
        
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
