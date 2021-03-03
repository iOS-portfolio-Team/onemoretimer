//
//  ForTimeViewController.swift
//  onemoretimer
//
//  Created by 정정이 on 2021/02/23.
//

import UIKit
import SimpleAlertPickers

class ForTimeViewController: UIViewController {

    
    @IBOutlet weak var viewForTime: UIView!
    @IBOutlet weak var buttonSelectTime: UIButton!
    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var labelTotalRoundTime: UILabel!
    @IBOutlet weak var buttonForTimeStart: UIButton!
    
    // Variables for Picker view
    var roundCountValue: String?
    var selectTimeValue: String?
    
    
    // Set the Array to fit into the pickers
    var times = [String]()  //= (5...100).map { String($0) }
    var count = [String]() //= (1...10).map { String($0) }
    var buttonTimes = [String]()
    var buttonCount = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // The shape and color of buttons are setting.
        viewForTime.layer.masksToBounds = true
        viewForTime.layer.cornerRadius = 20 // 라운드 설정값
        buttonForTimeStart.layer.masksToBounds = true
        buttonForTimeStart.layer.cornerRadius = 20
        buttonRound.layer.masksToBounds = true
        buttonRound.layer.cornerRadius = 20
        buttonSelectTime.layer.masksToBounds = true
        buttonSelectTime.layer.cornerRadius = 20

        
        
        labelTotalRoundTime.text="총 5회를 5분안에 해야합니다."
        
        // Insert Array to Enter PickerView
                for i in 5...100{
                    if i < 10{
                        times.append("0\(i):00 분")
                    }else{
                        times.append("\(i):00 분")
                    }
                    buttonTimes.append("\(i)")
                }
                for i in 1...10{
                        count.append("\(i)회")
                        buttonCount.append("\(i)")
                    }
                   

        
                
        // Give value to pickers and buttons when 'viewDidLoad'
        selectTimeValue = buttonTimes[0]
        roundCountValue = buttonCount[4]
        buttonRound.setTitle(buttonCount[4] + "회", for: .normal)
        buttonSelectTime.setTitle(buttonTimes[0] + "분", for: .normal)
    }
    

    // Event when round button is clicked
    @IBAction func buttonRound(_ sender: UIButton) {
        
        let alert = UIAlertController( title: "몇 라운드 할까요?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let pickerViewValues: [[String]] = [count]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: count.firstIndex(of: roundCountValue!) ?? 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    
                    self.roundCountValue = self.buttonCount[index.row]
                    self.buttonRound.setTitle(self.buttonCount[index.row] + "회", for: .normal)
                    self.roundCountValue = self.buttonCount[index.row]
                    self.labelTotalRoundTime.text="총 \(self.roundCountValue!)회를 \(self.selectTimeValue!)분안에 해야합니다."
  
                }
            }
        }
        
        
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
    }
    
    // Event when time button is clicked
    @IBAction func buttonSelectTime(_ sender: UIButton) {
        
        let alert = UIAlertController( title: "얼마나 할까요?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let pickerViewValues: [[String]] = [times]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: times.firstIndex(of: selectTimeValue!) ?? 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self.selectTimeValue = self.buttonTimes[index.row]
                    self.buttonSelectTime.setTitle(self.buttonTimes[index.row] + "분", for: .normal)
                    self.labelTotalRoundTime.text = self.buttonTimes[index.row] + "분"
                    self.labelTotalRoundTime.text="총 \(self.roundCountValue!)회를 \(self.selectTimeValue!)분안에 해야합니다."
                }
            }
        }
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ForTimeSegue"{
            let timerView = segue.destination as! ForTimeTimerViewController
            timerView.receiveItem(selectTimeValue!, roundCountValue!)
        }
 
    }
    
}
