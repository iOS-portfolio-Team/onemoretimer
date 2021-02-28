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
        
        
        //UI Shape
        buttonCountOffSecond.layer.masksToBounds = true
        buttonCountOffSecond.layer.cornerRadius = 20
        switchSoundOnOff.isOn = UserDefaults.standard.bool(forKey: "switchIsOn")
        buttonCountOffSecond.setTitle(String(UserDefaults.standard.integer(forKey: "countOffTime")), for: .normal)
        
    }
 
    
    @IBAction func buttonCountOffAlert(_ sender: UIButton) {
        let alert = UIAlertController( title: "시간을 정해주세요", message: nil, preferredStyle: UIAlertController.Style.alert)
       
        let times: [String] = (3...30).map { String($0) }
        let pickerViewValues: [[String]] = [times]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 9)
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
        
    }
   

}
