//
//  WorkOutLogDetailViewController.swift
//  onemoretimer
//
//  Created by 고종찬 on 2021/03/07.
//

import UIKit

class WorkOutLogDetailViewController: UITabBarController {

    @IBOutlet weak var exerciseDate: UILabel!
    @IBOutlet weak var exerciseTime: UILabel!
    @IBOutlet weak var exerciseFinished: UILabel!
    @IBOutlet weak var exerciseComment: UITextView!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    
    var date: String?
    var finished: String?
    var comment: String?
    var image: String?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(date,finished,comment,image,name)
       
//        exerciseFinished!.text = finished
//        exerciseComment!.text = comment
//        exerciseName!.text = name
//        exerciseImage!.image = UIImage(named: "\(String(describing: image)).png")
//
//
    }
 
    func receivedItems(name:String, date:String , finished:String, comment:String, image:String){
        self.date = date
        self.finished = finished
        self.comment = comment
        self.image = image
        self.name = name
        
    }

}
