//
//  TabataCommentViewController.swift
//  onemoretimer
//
//  Created by jonghan on 2021/02/24.
//

import UIKit


class TabataCommentViewController: UIViewController {

    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var textViewComment: UITextView!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var buttonInsertComment: UIButton!
    
    var db:DBHelper = DBHelper()
    
    var getRound = 0
    var getWork = 0
    var getSet = 0
    var getTime = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Shape
        textViewComment.layer.borderWidth = 1
        textViewComment.layer.masksToBounds = true
        textViewComment.layer.cornerRadius = 8
        buttonInsertComment.layer.masksToBounds = true
        buttonInsertComment.layer.cornerRadius = 20

        // show workout result
        let minute = getWork / 60
        let second = getWork % 60
       
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
       
        
        
        labelCurrentTime.text = getTime
        labelResult.text = "\(stringWorkTime) / \(getRound * getSet) 라운드"
    }
    
    
    
    // from segue
    func receiveItem(_ round: Int, _ work: Int, _ set: Int, _ time: String) {
        getRound = round
        getWork = work
        getSet = set
        getTime = time
    }
    
    
    
    
    // Insert Function
    @IBAction func buttonInsertComment(_ sender: UIButton) {
        
        let InsertExerciseComment: String = textViewComment.text!.trimmingCharacters(in: .whitespaces)
        
        // comment update
        db.updateByID(exerciseWhen: getTime, exerciseComment: InsertExerciseComment)
        performSegue(withIdentifier: "unwindTabataTimer", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
