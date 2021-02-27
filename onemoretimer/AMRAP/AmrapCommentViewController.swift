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
        // 텍스트컬러 커스텀
       
        // Do any additional setup after loading the view.
        textViewComment.layer.borderWidth = 1
        textViewComment.layer.masksToBounds = true
        textViewComment.layer.cornerRadius = 8
        buttonInsertComment.layer.masksToBounds = true
        buttonInsertComment.layer.cornerRadius = 20
       
        textViewComment.backgroundColor = UIColor.white
        
        
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
        
   
    func receiveItem(_ round: Int, _ worktime: String,_ time: String) {
        getRound = round
        currentTime = worktime
        getTime = time
        print(getTime+"zd")
       
        
      
    }
        
        
    @IBAction func buttonInsertComment(_ sender: UIButton) {
        
        
        let InsertExerciseComment: String = textViewComment.text!.trimmingCharacters(in: .whitespaces)

        // comment update
        db.updateByID(exerciseWhen: getTime, exerciseComment: InsertExerciseComment)
        print(db.read())
        performSegue(withIdentifier: "unwindAmrapTimer", sender: self)
        
    }
    
        

        
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

