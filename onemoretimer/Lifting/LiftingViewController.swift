//
//  LiftingViewController.swift
//  onemoretimer
//
//  Created by 고종찬 on 2021/03/01.
//

import UIKit
import SimpleAlertPickers


class LiftingViewController: UIViewController {
    
    // Set the Array to fit into the pickers
    let stringTimes: [String] = ["10초","20초","30초","40초","50초","1분","1분 10초","1분 20초","1분 30초","1분 40초","1분 50초","2분 ","2분 30초","3분","3분 30초","4분","4분 30초","5분"]
    let intTimes: [Int] = [10,20,30,40,50,60,70,80,90,100,110,120,150,180,210,240,270,300]
    let rounds: [String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
   
    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var buttonTime: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var labelCheck: UILabel!
    @IBOutlet weak var liftingUIView: UIView!
    
    // Variables for Picker view
    var roundCountValue: String?
    var selectTimeValue: String?
    var labelTimeValue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give value to pickers and buttons when 'viewDidLoad'
        labelTimeValue = intTimes[5]
        selectTimeValue = String(intTimes[5])
        roundCountValue = rounds[4]
        buttonTime.setTitle("\(stringTimes[5])", for: .normal)
        buttonRound.setTitle("\(roundCountValue!)", for: .normal)

        labelCheck.text = "\(labelTimeValue!/60)분 \(labelTimeValue!%60)초를 \(roundCountValue!)라운드 만큼 쉽니다."
        
        
        // The shape and color of buttons are setting.
        liftingUIView.layer.masksToBounds = true
        liftingUIView.layer.cornerRadius = 20
        buttonTime.layer.masksToBounds = true
        buttonTime.layer.cornerRadius = 20
        buttonRound.layer.masksToBounds = true
        buttonRound.layer.cornerRadius = 20
        buttonStart.layer.masksToBounds = true
        buttonStart.layer.cornerRadius = 20
    }
    // Event when round button is clicked
    @IBAction func buttonRound(_ sender: UIButton) {
        let alert = UIAlertController( title: "얼마나 하실건가요?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let pickerViewValues: [[String]] = [rounds]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 4 )
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values  in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) { [self] in
                    buttonRound.setTitle(rounds[index.row], for: .normal)
                    roundCountValue = rounds[index.row]
                    labelCheck.text = "\(labelTimeValue!/60)분 \(labelTimeValue!%60)초를 \(roundCountValue!)라운드 만큼 쉽니다."
                }
            }
        }
        let alertAction = UIAlertAction(title: "완료", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertAction)
        alert.show()
    }
    // Event when time button is clicked
    @IBAction func buttonTime(_ sender: UIButton) {
        
        let alert = UIAlertController( title: "시간을 정해주세요", message: nil, preferredStyle: UIAlertController.Style.alert)
        let pickerViewValues: [[String]] = [stringTimes]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 5)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) { [self] in
                   buttonTime.setTitle(stringTimes[index.row], for: .normal)
                    selectTimeValue = String(Int(intTimes[index.row]))
                    labelTimeValue =  intTimes[index.row]
                    labelCheck.text = "\(labelTimeValue!/60)분 \(labelTimeValue!%60)초를 \(roundCountValue!)라운드 만큼 쉽니다."
                }
            }
        }
        let alertAction = UIAlertAction(title: "완료", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertAction)
        alert.show()
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "LiftingSegue"{
             let timerView = segue.destination as! LiftingTimerViewController
            timerView.receiveItem(selectTimeValue!, roundCountValue!)
         }
     }

}
