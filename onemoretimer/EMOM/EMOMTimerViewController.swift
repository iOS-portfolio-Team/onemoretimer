//
//  EMOMTimerViewController.swift
//  onemoretimer
//
//  Created by Derrick on 2021/02/24.
//

import UIKit
import AVFoundation

class EMOMTimerViewController: UIViewController {

    // SQLite Link
    var db:DBHelper = DBHelper()
    //UI link
    @IBOutlet weak var viewEmomTimer: UIView!
    @IBOutlet weak var labelTimerStart: UILabel!
    @IBOutlet weak var viewEmomProgressBar: UIView!
    @IBOutlet weak var buttonStartTabProgressBar: UIButton!
    @IBOutlet weak var buttonTerminate: UIButton!
    @IBOutlet weak var imageViewFinish: UIImageView!
    @IBOutlet weak var buttonCheckHistory: UIButton!
    @IBOutlet weak var labelTotalComment: UILabel!
    
    @IBOutlet weak var labelFinishMent: UILabel!
    
    // From Segue
    var getSecond : Int = 0
    var getCount : String = ""
    var getInfinity : Bool = true
    var getTime = ""
    var infinityTime = 0
    var roundCount = 0
    
    // About progress bar
    var circularProgressBar = EmomTimeProgressBar()
    var radius: CGFloat!
    var progress: CGFloat!
    var answeredCorrect = 0
    var totalQuestions = 0
      
    // about timer
    let countUpSelector: Selector = #selector(EMOMTimerViewController.updateTime)
    let countDownSelector: Selector = #selector(EMOMTimerViewController.countDownTime)
    static var timeOut = 0
    let interval = 1.0
    var countUpTimer = Timer()
    var countDownTimer = Timer()
    var countDown = UserDefaults.standard.integer(forKey: "countOffTime")
    var countUp = 0
    var minute = 0
    var second = 0
    var textMinute = ""
    var textSecond = ""
    
    //status : for check timer status
    var countDownButtonStatus = true
    var countUpButtonStatus = false
    var countUpButtonOnOff = true
    let orangeColor = #colorLiteral(red: 1, green: 0.5215686275, blue: 0.2039215686, alpha: 1)
    var countAdd = "0"
    
    //sound for counter
    var audioPlayer = AVAudioPlayer()
    var soundIsOn :Bool = UserDefaults.standard.bool(forKey: "switchIsOn")
   
    // Random Ment
    let randomText = ["회원님 오늘은 하체하셔야죠 :D",
                 "운동이 끝났습니다. 회원님 하체한번 더 :D",
                 "잘하셨어요! 회원님 한번 더! :D",
                 "운동이 끝났습니다! 회원님 이제 어깨할까요? :D",
                 "잘하셨어요! 회원님 이제 상체할까요~? :D",
                 "회원님~ 오늘도 고생했어요! :D",
                 "우리회원님 ! 잘하셨어요! :D",
                 "회원님! 잘하셨어요! 조금만 더 해볼까요? :D"]
    let random = Int(arc4random_uniform(7)) //1 or 0
      

    //Timer status: For logging the WorkoutLog.
    var isTimerStarted = false
    var isTimerEnd = false
    var isWork = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewFinish.image = UIImage(named: "TimerImage.png")
       
        EMOMTimerViewController.timeOut = getSecond
        //UI Shape
        viewEmomTimer.layer.masksToBounds = true
        viewEmomTimer.layer.cornerRadius = 20
        buttonTerminate.isHidden = true
        buttonTerminate.isEnabled = false
        buttonTerminate.backgroundColor = UIColor.gray
        buttonCheckHistory.isHidden = true
        
        // The Random Ment is Hidden
        labelFinishMent.isHidden = true
        
        // Unlimited mode is turned on
        if getInfinity == true{
            buttonTerminate.isHidden = true
            buttonTerminate.isEnabled = false
            buttonTerminate.setTitle("종료", for: .normal)
            buttonTerminate.layer.masksToBounds = true
            buttonTerminate.layer.cornerRadius = 20
        }
        
        
        labelTotalComment.text = "\(getCount)회중 \(roundCount)회차"

    }
    
    //terminate timer
    @IBAction func buttonTerminator(_ sender: UIButton) {
        
        isTimerEnd = true
        insertData("무제한")
        countUpTimer.invalidate()
        buttonTerminate.isHidden = true
        buttonStartTabProgressBar.isEnabled = false
        labelTimerStart.text = "END"
        buttonCheckHistory.isHidden = false
        labelTotalComment.isHidden = true
        viewEmomProgressBar.isHidden = true
        imageViewFinish.isHidden = true
        buttonStartTabProgressBar.isHidden = true
        buttonCheckHistory.isHidden = false
        buttonCheckHistory.layer.masksToBounds = true
        buttonCheckHistory.layer.cornerRadius = 20
        
        labelFinishMent.isHidden = false
        labelFinishMent.text = randomText[random]
       
    }
    //Main timer
    @IBAction func buttonTabProgressBar(_ sender: UIButton) {
        
        if countUpButtonStatus{
            if countUpButtonOnOff{
                progressCirclePause(nowTime: Double(countUp))
                playSound(file: "PauseWorkOut", ext: "mp3")
                countUpTimer.invalidate()
                labelTimerStart.text = "Pause"
                
                //counter tab button is enabled
                countUpButtonOnOff = false
                //Depends on countButtonOnOff UI color is changed
                buttonTerminate.backgroundColor = UIColor.orange
                labelTimerStart.textColor = UIColor.gray
                
            }else{
                labelTimerStart.text = "\(textMinute):\(textSecond)"
                progressCircleRestart(nowTime: Double(countUp))
                countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
                
                countUpButtonOnOff = true
                buttonTerminate.isEnabled = false
                
                buttonTerminate.backgroundColor = UIColor.gray
                labelTimerStart.textColor = UIColor.orange
            }
        }else{
            isTimerStarted = true
            if countDownButtonStatus{
                labelTotalComment.isHidden = false
                imageViewFinish.isHidden = true
                
                if getInfinity == true{
                    buttonTerminate.isHidden = false
                    buttonTerminate.isEnabled = true
                    buttonTerminate.backgroundColor = UIColor.orange
                }
                playSound(file: "StartWorkOut", ext: "mp3")
                labelTimerStart.text = "\(countDown)"
                countDownTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countDownSelector, userInfo: nil, repeats: true)
                countDownButtonStatus = false
                labelTimerStart.textColor = UIColor.orange
                
            }else{
//                playSound(file: "PauseWorkOut", ext: "mp3")
                labelTimerStart.text = "Pause"
                countDownTimer.invalidate()
                labelTimerStart.textColor = UIColor.gray
                countDownButtonStatus = true

                
            }
        }
    }
    
    //back button
    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        // when timer is running
        if isTimerStarted && isTimerEnd == false
        {
            playSound(file: "PauseWorkOut", ext: "mp3")
            countUpTimer.invalidate()
            buttonStartTabProgressBar.isEnabled = true
            buttonTerminate.backgroundColor = UIColor.gray
            buttonTerminate.isEnabled = true
            buttonCheckHistory.isHidden = true
            // break timer
            progressCirclePause(nowTime: Double(self.countUp))
            countDownTimer.invalidate()
            labelTimerStart.text = "Pause"
            labelTimerStart.textColor = UIColor.gray
            countUpButtonOnOff = false

            // Floating Alert
            let alertController = UIAlertController(title: "중지", message: "중지 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
                
            })
            let alertActionNeg = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertActionNeg)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
        
        else{// when timer is not running
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // from segue
    func receiveItem(_ second : Int, _ count: String, _ infinity : Bool) {
        getSecond = second
        getCount = count
        getInfinity = infinity
    }
    
    // count down
    @objc  func countDownTime(){
        labelTimerStart.text = "\(countDown)"
        countDown -= 1
        if countDown == 2{
            playSound(file: "CountDown", ext: "wav")
        }
        
        if countDown == -1{
            countDownTimer.invalidate()
            countUpButtonStatus = true
            labelTimerStart.text = "GO"
            countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
        }
    }

    
    
    // count up
    @objc func updateTime(){
        if countUp == 0{
            
            progressCircle()

        }
        
        countUp += 1
        second += 1
        infinityTime += 1
        
        if second == 60 {
            minute += 1
            second = 0
        }
        
        if minute < 10{
            textMinute = "0\(minute)"
        }else{
            textMinute = "\(minute)"
        }
        if second < 10{
            textSecond = "0\(second)"
        }else{
            textSecond = "\(second)"
        }
        
        labelTimerStart.text = "\(textMinute):\(textSecond)"
        countSound()
      
        //'if' to check Infinity mode
        if getInfinity == true && countUp == EMOMTimerViewController.timeOut
        {
            roundCount += 1
            labelTotalComment.text = "무제한모드 \(roundCount)라운드"
            countUp = 0
            minute = 0
            second = 0
            progressCircle()
         
        }
        else if getInfinity == false && countUp == EMOMTimerViewController.timeOut
        {
            roundCount += 1
            labelTotalComment.text = "\(getCount)라운드중 \(roundCount)라운드"
            buttonTerminate.isHidden = true
            countUp = 0
            minute = 0
            second = 0
            
            if Int(getCount)!  == roundCount{
                labelFinishMent.isHidden = false
                labelFinishMent.text = randomText[random]
                isTimerEnd = true
                insertData("")
                countUpTimer.invalidate()
                buttonStartTabProgressBar.isEnabled = false
                labelTimerStart.text = "END"
                buttonCheckHistory.isHidden = false
                labelTotalComment.isHidden = true
                viewEmomProgressBar.isHidden = true
                imageViewFinish.isHidden = false
                labelTimerStart.isHidden = true
                buttonStartTabProgressBar.isHidden = true
                buttonCheckHistory.isHidden = false
                buttonCheckHistory.layer.masksToBounds = true
                buttonCheckHistory.layer.cornerRadius = 20
                
            }
        }
       
}
    override func viewWillDisappear(_ animated: Bool) {
        countDownTimer.invalidate()
        countUpTimer.invalidate()
        
        if isTimerStarted && isTimerEnd == false{
            insertData("중단했습니다.")
        }
        
    }
    
    
    // Function for progress bar
    func progressCircle() {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewEmomProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        circularProgressBar.addProgressBar(radius: radius, progress: progress)
        circularProgressBar.center = viewEmomProgressBar.center

        //Adding view
        viewEmomProgressBar.addSubview(circularProgressBar)
        circularProgressBar.loadProgress(percentage: progress)
        
    }
    
    func progressCirclePause(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewEmomProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        circularProgressBar.addProgressBar(radius: radius, progress: progress)
        circularProgressBar.center = viewEmomProgressBar.center


        //Adding view
        viewEmomProgressBar.addSubview(circularProgressBar)
        circularProgressBar.loadProgressPause(percentage: progress,nowTime: nowTime)
    }
    
    func progressCircleRestart(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewEmomProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        circularProgressBar.addProgressBar(radius: radius, progress: progress)
        circularProgressBar.center = viewEmomProgressBar.center

        //Adding view
        viewEmomProgressBar.addSubview(circularProgressBar)

        circularProgressBar.loadProgressRestart(percentage: progress, nowTime: nowTime)
    }
    
    
 
    //Function for inserting into SQLite
    func insertData(_ isEnd : String) {
        var stringWorkTime = " "
        var minute = 0
        var second = 0
        
        if getInfinity == false {
            minute = getSecond / 60
            second = getSecond % 60
            
            if minute >= 5 {
                    stringWorkTime = "\(minute):00"
                }
            
             else
            {
                if second < 10 {
                    stringWorkTime = "0\(minute):0\(second)"
                }else{
                    stringWorkTime = "0\(minute):\(second)"
                }
            }
        }else{
            minute = infinityTime / 60
            second = infinityTime % 60
            
            if minute >= 5 {
                    stringWorkTime = "\(minute):00"
                }
            
             else
            {
                if second < 10 {
                    stringWorkTime = "0\(minute):0\(second)"
                }else{
                    stringWorkTime = "0\(minute):\(second)"
                }
            }
        }

        let InsertExerciseName: String = "EMOM"
                
        let InsertExerciseHow: String = " / \(stringWorkTime) min"
        
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yy-MM-dd / HH:mm:ss"
        let current_year_string = formatter_year.string(from: Date())
 
        let InsertExerciseWhen: String = current_year_string
        getTime = current_year_string
  
        let InsertExerciseJudgment: String = isEnd
    
        
        let InsertExerciseComment: String = " "
        
      
        db.insert(exerciseSequenceNumber: 0, exerciseName: "\(InsertExerciseName)", exerciseHow: "\(InsertExerciseHow)", exerciseWhen: "\(InsertExerciseWhen)", exerciseJudgment: "\(InsertExerciseJudgment)", exerciseComment: "\(InsertExerciseComment)")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "EmomCommentSegue"{
            let emomCommentView = segue.destination as! EMOMCommentViewController
            if getInfinity == true {
                    emomCommentView.receiveItems(String(roundCount), infinityTime, getTime)
            }else{
                    emomCommentView.receiveItems(getCount, getSecond, getTime)
            }
           }
            
        }
    
    
    
    // Check when the sound setting is on.
    func playSound(file: String , ext: String) -> Void {
       
        if soundIsOn{
        
            do{
                let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: file, ofType: ext) ?? "mp3")
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }catch let error{
                NSLog(error.localizedDescription)
            }
        }
    }
    
    //The sound is determined according to the time set.
    func countSound(){
    
        if getSecond <= 30 {
            
            if getSecond - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if getSecond - countUp == getSecond/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
       
        }else{
            if getSecond - countUp == 10{
                playSound(file: "TenSecondLeft", ext: "mp3")
            }
            if getSecond - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if getSecond - countUp == getSecond / 2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
            
        }
    }



    // segue to return to EMOMCommentViewController
    @IBAction func unwindEMOMTimer (segue : UIStoryboardSegue) {}
}
