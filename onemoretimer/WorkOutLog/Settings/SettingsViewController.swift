//
//  SettingsViewController.swift
//  onemoretimer
//
//  Created by 고종찬 on 2021/02/17.
//

import UIKit
import SimpleAlertPickers

class SettingsViewController: UIViewController {

    @IBOutlet weak var switchSoundOnOff: UISwitch!
    @IBOutlet weak var buttonCountOffSecond: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
   
        switchSoundOnOff.isOn = UserDefaults.standard.bool(forKey: "switchIsOn")
        buttonCountOffSecond.setTitle(String(UserDefaults.standard.integer(forKey: "countOffTime")), for: .normal)
        
    }
 
    
    @IBAction func buttonCountOffAlert(_ sender: UIButton) {
        
        // Alert 형식
        let alert = UIAlertController( title: "시간을 정해주세요", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        // 3~30초까지를 String 타입 배열로 구성
        let times: [String] = (3...30).map { String($0) }
        
        // addPickerView에 매개변수로 있는 values 자체가 [[String]] 형식이라 맞춰서 써야 될거같습니다.
        let pickerViewValues: [[String]] = [times]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 9)
       
        // alert에 picker 추가해주기 + async를 통해 버튼의 text 바꿔줌.
        // picker 선택시 action은 이 안에 써주시면 됩니다.
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 1) {
                    
                    self.buttonCountOffSecond.setTitle(times[index.row], for: .normal)
                    UserDefaults.standard.set(Int(times[index.row])!, forKey: "countOffTime")
                }
            }
        }
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
    }
    
    @IBAction func switchSoundOnOff(_ sender: UISwitch) {
        if sender.isOn{
           UserDefaults.standard.set(true, forKey: "switchIsOn")

        }else if !sender.isOn{
           UserDefaults.standard.set(false, forKey: "switchIsOn")
        }
        print(UserDefaults.standard.bool(forKey: "switchIsOn"))
    }
   

}
