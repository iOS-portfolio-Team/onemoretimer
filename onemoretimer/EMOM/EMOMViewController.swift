//
//  EMOMViewController.swift
//  onemoretimer
//
//  Created by Derrick on 2021/02/24.
//

import UIKit
import SimpleAlertPickers

class EMOMViewController: UIViewController {
    
    @IBOutlet weak var viewEmom: UIView!
    @IBOutlet weak var labelTotalComment: UILabel!
    @IBOutlet weak var buttonRoundCount: UIButton!
    @IBOutlet weak var buttonTimeCount: UIButton!
    @IBOutlet weak var switchButtonOff: UISwitch!
    @IBOutlet weak var buttonStartNext: UIButton!
  
    
    // Variables for Picker view
    var countTimeValue: String?
    var selectedTimeValue: String?
    
    
    // Set the Array to fit into the pickers
    var times = [String]()
    var count = [String]()
    var sendTime = ""
    var second = 0
    var minute = 0
    var arraySecond :[Int] = []
    var sendSecond = 0
    var buttonTimes = [String]()
    var buttonCount = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The shape and color of buttons are setting.
        buttonShapeNColor()
        
        // Insert Array to Enter PickerView
        appendArr()
        
        
        // Give value to pickers and buttons when 'viewDidLoad'
        selectedTimeValue = "01:00"
        buttonTimeCount.setTitle("1분 0초", for: .normal)
        countTimeValue = "10"
        buttonRoundCount.setTitle("10", for: .normal)
        switchButtonOff.isOn = false
        sendSecond = 60
        
        
        labelTotalComment.text = "1분0초씩 \(String(describing: (countTimeValue!)))라운드를 진행합니다."
        
    }
    
    // Event when round button is clicked
    @IBAction func buttonRoundSet(_ sender: UIButton) {
        
        let alert = UIAlertController( title: "몇 라운드 할까요?", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let pickerViewValues: [[String]] = [count]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: count.firstIndex(of: countTimeValue!) ?? 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) { [self] in
                    countTimeValue = buttonCount[index.row]
                    buttonRoundCount.setTitle(countTimeValue!, for: .normal)
                    labelTotalComment.text = " \(String(selectedTimeValue!))씩 \(String(countTimeValue!))라운드를 진행합니다."
                    
                }
            }
        }
        
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
        
        
        
    }
    
    // Event when time button is clicked
    @IBAction func buttonSelectedTime(_ sender: Any) {
        let alert = UIAlertController( title: "얼마나 할까요?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let pickerViewValues: [[String]] = [times]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: times.firstIndex(of: selectedTimeValue!) ?? 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) { [self] in
                    selectedTimeValue = times[index.row]
                    sendTime = buttonTimes[index.row]
                    buttonTimeCount.setTitle(sendTime, for: .normal)
                    sendSecond = arraySecond[index.row]
                    
                    labelTotalComment.text = " \(String(selectedTimeValue!))씩 \(String(countTimeValue!))라운드를 진행합니다."
                }
            }
        }
        
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
        
        
    }
    
    // Switch Infinity
    @IBAction func switchInfinity(_ sender: UISwitch) {
        
        switch sender.isOn {
        case true:
            buttonRoundCount.isEnabled = false
            buttonTimeCount.isEnabled = true
            self.labelTotalComment.isHidden = true
            buttonRoundCount.setImage(UIImage(named:"infinity.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            labelTotalComment.text = "\(String(describing: selectedTimeValue))씩 \(String(describing: (countTimeValue!)))라운드를 진행합니다."
        default:
            buttonRoundCount.isEnabled = true
            buttonTimeCount.isEnabled = true
            buttonRoundCount.setImage(UIImage(named:""),for: .normal)
            labelTotalComment.text = "\(String(describing: selectedTimeValue))씩 무제한 라운드를 진행합니다."
        }
    }
    
    
    
    // UIView Settings
    func buttonShapeNColor() {
        
        viewEmom.layer.masksToBounds = true // 레이아웃 설정 가능 (true 설정안해주면 round 설정 불가능)
        viewEmom.layer.cornerRadius = 20 // 라운드 설정값
        
        buttonStartNext.layer.masksToBounds = true
        buttonStartNext.layer.cornerRadius = 20
        
        buttonRoundCount.layer.masksToBounds = true
        buttonRoundCount.layer.cornerRadius = 20
        
        buttonTimeCount.layer.masksToBounds = true
        buttonTimeCount.layer.cornerRadius = 20
        
    }
    
    // Insert Array to Enter PickerView
    func appendArr(){
        for i in 1...20{
            arraySecond.append(i * 15)
            if i*15 % 60 == 0{
                minute += 1
                second = 0
            }else{
                second += 15
            }
            if second == 0{
                times.append("0\(minute):0\(second)")
            }else{
                times.append("0\(minute):\(second)")
            }
            if minute == 0{
                buttonTimes.append("\(second)초")
            }else{
                buttonTimes.append("\(minute)분\(second)초")
            }
        }
        
        for i in 6...100{
            if i<10{
                times.append("0\(i):00")
            }else{
                times.append("\(i):00")
            }
            buttonTimes.append("\(i)분")
            arraySecond.append(i*60)
        }
        for i in 1...10{
            count.append("\(i)")
            buttonCount.append("\(i)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EMOMSegue"{
            let timerView = segue.destination as! EMOMTimerViewController
            if buttonRoundCount.isEnabled == true
            {
                // sendSecond = Total Second
                timerView.receiveItem(sendSecond, countTimeValue!, false)
            }
            else{
                timerView.receiveItem(sendSecond, "무제한", true)
            }
        }
        
        
    }
    
    
}

