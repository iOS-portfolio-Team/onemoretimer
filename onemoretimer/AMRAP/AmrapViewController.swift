//
//  AmrapViewController.swift
//  onemoretimer
//
//  Created by 최지석 on 2021/02/25.
//

import UIKit
import SimpleAlertPickers

class AmrapViewController: UIViewController,
                           UICollectionViewDelegate,UICollectionViewDataSource{

   
   
    @IBOutlet weak var collectionViewAmrap: UICollectionView!
    @IBOutlet weak var buttonRound: UIButton!
    @IBOutlet weak var viewAmrap: UIView!
    @IBOutlet weak var buttonStart: UIButton!
    
    // 피커뷰에 들어가는 값 배열
    var timesRestPicker: [String] = []
    var timesExercisePicker: [String] = []
    
    // 셋팅된 라운드 배열에 n번째 값에 시간 넣어줌
    //ex) 피커뷰에서 00:15를 선택하면 15초를 넣어준다
    var timeRest: [String] = []
    var timeExercise: [String] = []
    
    var sendTimeRestArr :[Int] = []
    var sendTimeExerciseArr :[Int] = []
    
   
    var sendData: [[Int]] = [[]]
    
    // 피커에서 선택된 값 변수
    var pickedValueRest: [String] = ["00:30 분"]
    var pickedValueExercise: [String] = ["02:00 분"]
    
    // 셋팅된 라운드 배열
    var rest = ["30초"]
    var exercise = ["2분"]
    var sendRest: [Int] = [30]
    var sendExercise: [Int] = [120]
    
    
    
    var second = 0
    var minute = 0
    
    var roundPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonRound.setTitle("1", for: .normal)
        buttonRound.isEnabled = false
        buttonRound.layer.masksToBounds = true
        buttonRound.layer.cornerRadius = 20
        viewAmrap.layer.masksToBounds = true
        viewAmrap.layer.cornerRadius = 20
        buttonStart.layer.masksToBounds = true
        buttonStart.layer.cornerRadius = 20
        // set Array
        appendArr()
        
    }

    @IBAction func buttonAddRound(_ sender: UIButton) {
        buttonRound.setTitle("\(rest.count+1)", for: .normal)
        rest.append("30초")
        exercise.append("2분")
        sendRest.append(30)
        sendExercise.append(120)
        pickedValueRest.append("00:30 분")
        pickedValueExercise.append("02:00 분")
        collectionViewAmrap.reloadData()
        print(rest)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rest.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewAmrap.dequeueReusableCell(withReuseIdentifier: "amrapCell", for: indexPath) as! AmrapCollectionViewCell
        
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        cell.buttonExercise.layer.masksToBounds = true
        cell.buttonExercise.layer.cornerRadius = 8
        cell.buttonRest.layer.masksToBounds = true
        cell.buttonRest.layer.cornerRadius = 8
        
        cell.labelRound.text = "\(indexPath.row+1) Work out"
        cell.buttonRest.setTitle(rest[indexPath.row], for: .normal)
        cell.buttonExercise.setTitle(exercise[indexPath.row], for: .normal)
        
   
        cell.buttonRoundDelete.tag = indexPath.row
        cell.buttonRoundDelete.addTarget(self, action: #selector(roundDeleteAction), for: .touchUpInside)
       
        cell.buttonRest.tag = indexPath.row
        cell.buttonRest.addTarget(self, action: #selector(restButtonAction), for: .touchUpInside)
       
        cell.buttonExercise.tag = indexPath.row
        cell.buttonExercise.addTarget(self, action: #selector(exerciseButtonAction), for: .touchUpInside)
        
       
        return cell
    }
  
    @objc func exerciseButtonAction(sender:UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)

        let alert = UIAlertController( title: "시간을 정해주세요", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let pickerViewValues: [[String]] = [timesExercisePicker]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: timesExercisePicker.firstIndex(of: pickedValueExercise[indexPath.row]) ?? 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
      
                    self.pickedValueExercise[indexPath.row] = self.timesExercisePicker[index.row]
                    self.exercise[indexPath.row] = self.timeExercise[index.row]
                    self.sendExercise[indexPath.row] = self.sendTimeExerciseArr[index.row]
                    
                    
                    self.collectionViewAmrap.reloadData()
               
                }
            }
            
        }
    
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
    }

    @objc func restButtonAction(sender:UIButton){
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(indexPath.row)
        print(pickedValueRest.count)
     
        let alert = UIAlertController( title: "시간을 정해주세요", message: nil, preferredStyle: UIAlertController.Style.alert)
        let pickerViewValues: [[String]] = [timesRestPicker]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: timesRestPicker.firstIndex(of: pickedValueRest[indexPath.row]) ?? 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self.pickedValueRest[indexPath.row] = self.timesRestPicker[index.row]
                    self.rest[indexPath.row] = self.timeRest[index.row]
                    self.sendRest[indexPath.row] = self.sendTimeRestArr[index.row]
                    
                    
                    self.collectionViewAmrap.reloadData()
                }
            }
        }
        
        
        alert.addAction(title: "완료", style: .cancel)
        alert.show()
    }
    
    
    // when delete button is clicked
    @objc func roundDeleteAction(sender:UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if rest.count > 1 {
            self.pickedValueRest.remove(at: indexPath.row)
            self.pickedValueExercise.remove(at: indexPath.row)
            buttonRound.setTitle("\(rest.count)", for: .normal)
            self.rest.remove(at: indexPath.row)
            self.exercise.remove(at: indexPath.row)
            self.sendRest.remove(at: indexPath.row)
            self.sendExercise.remove(at: indexPath.row)
        }
        collectionViewAmrap.reloadData()

    }

    
    // seting array
    func appendArr(){
        
        for i in 1...20{
            if i*15 % 60 == 0{
                minute += 1
                second = 0
            }else{
                second += 15
            }
                    
            if second == 0{
                timesRestPicker.append("0\(minute):0\(second) 분")
                timesExercisePicker.append("0\(minute):0\(second) 분")
             
            }else{
                timesRestPicker.append("0\(minute):\(second) 분")
                timesExercisePicker.append("0\(minute):\(second) 분")
            }
            
            
            if minute == 0{
                timeRest.append("\(second)초")
                timeExercise.append("\(second)초")
            }else{
                timeRest.append("\(minute)분 \(second)초")
                timeExercise.append("\(minute)분 \(second)초")
            }
            
            sendTimeRestArr.append(i*15)
            sendTimeExerciseArr.append(i*15)
        }
        
        for i in 6...100{
            if i<10{
                timesRestPicker.append("0\(i):00 분")
                timesExercisePicker.append("0\(i):00 분")
            }else{
                timesRestPicker.append("\(i):00 분")
                timesExercisePicker.append("\(i):00 분")
            }
            timeRest.append("\(i)분")
            timeExercise.append("\(i)분")
            sendTimeRestArr.append(i*60)
            sendTimeExerciseArr.append(i*60)
        }
    }
    
    
    // MARK: - Navigation

    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AmrapSegue"{
            let timerView = segue.destination as! AmrapTimerViewController
            timerView.receiveItem(sendRest,sendExercise)
        }
    }
    
}


