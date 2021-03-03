//
//  MainViewController.swift
//  onemoretimer
//
//  Created by 고종찬 on 2021/02/17.
//

import UIKit

var soundIsOn :Bool = UserDefaults.standard.bool(forKey: "switchIsOn")

class MainTimerViewController: UIViewController {

    @IBOutlet weak var labelRecommendation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomText = [
            "회원님 오늘은 하체 하셔야죠 :D",
        "흔들리면 그것은 지방입니다 :D",
        "헬스클럽은 클럽보다 더 즐거운곳 :D",
        "오늘도 화이팅 ! 아자아자 할수있다! :D",
        "회원님~ 한번만 더 하실수있죠? :D",
        "할수있다 우리 회원님! 한번만 더! :D"]
        let random = Int(arc4random_uniform(5)) //1 or 0
          
        labelRecommendation.text = randomText[random]
        
        
        // UserDefaults 초기 숫자가 0이므로 공동의 숫자인 userDefault를 10으로 잡아주기
        if UserDefaults.standard.integer(forKey: "countOffTime") == 0 {
            UserDefaults.standard.set(10, forKey: "countOffTime")
        }
        if UserDefaults.standard.bool(forKey: "switchIsOn"){
            UserDefaults.standard.set(true, forKey: "switchIsOn")
        }else{
            UserDefaults.standard.set(false, forKey: "switchIsOn")
        }
       
        navigationController?.navigationBar.barTintColor  = #colorLiteral(red: 0.2666666667, green: 0.2588235294, blue: 0.3411764706, alpha: 1)

  
    }
}
