//
//  AmrapTimeTimerViewController.swift
//  onemoretimer
//
//  Created by 최지석 on 2021/02/26.
//

import UIKit
import AVFoundation

class AmrapTimerViewController: UIViewController {

    // SQLite Link
    var db:DBHelper = DBHelper()
    //UI link
    
    @IBOutlet weak var imageViewSuccess: UIImageView!
    @IBOutlet weak var buttonAddComment: UIButton!
    @IBOutlet weak var buttonTabCount: UIButton!
    @IBOutlet weak var buttonAmrapProgressBar: UIButton!
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var viewAmrapTimer: UIView!
    @IBOutlet weak var amrapTimerUiView: UIView!
    
    
    // sound for counter
    var audioPlayer = AVAudioPlayer()
    var soundIsOn :Bool = UserDefaults.standard.bool(forKey: "switchIsOn")
    
    // From Segue
    var getExerciseTime:[Int] = []
    var getRestTime:[Int] = []
    var getTime = 0
    

    // About progress bar
    var amrapTimeProgressBar = AmrapTimeProgressBar()
    var radius: CGFloat!
    var progress: CGFloat!
    var answeredCorrect = 0
    var totalQuestions = 0
    
    // about timer
    let countUpSelector: Selector = #selector(AmrapTimerViewController.updateTime)
    let countDownSelector: Selector = #selector(AmrapTimerViewController.countDownTime)
    static var timeOut = 0
    let interval = 1.0
    var countUpTimer = Timer()
    var countDownTimer = Timer()
    var countDown = UserDefaults.standard.integer(forKey: "countOffTime")
    var countUp = 0
    var minute = 0
    var second = 0
    var minuteText = ""
    var secondText = ""
    var totalTime = 0
    
    var status = true
    
   
    
    //status : for check timer status
    var countDownButtonStatus = true
    var countUpButtonStatus = false
    var countUpButtonOnOff = true
    let orangeColor = #colorLiteral(red: 1, green: 0.5215686275, blue: 0.2039215686, alpha: 1)
    
    // To Segue
    var currentTime: String = ""
    
    var roundCount = 1
    //Timer status: For logging the WorkoutLog.
    var isTimerStarted = false
    var isTimerEnd = false

    var totalWorked = 0
    
    // about tab count
    var tabCount = 0
    var tapOneMore = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmrapTimerViewController.timeOut = getExerciseTime[0]
        
       
        labelRound.text = "총 \(getExerciseTime.count) 라운드중 1 라운드 진행중"
        
        getTime = getExerciseTime[0]
        
        //UI Shape

        amrapTimerUiView.layer.cornerRadius = 20
        amrapTimerUiView.layer.masksToBounds = true
        buttonTabCount.layer.masksToBounds = true
        buttonTabCount.layer.cornerRadius = 20

        buttonTabCount.setTitle("COUNT : \(tabCount)", for: .normal)
        buttonTabCount.isHidden = true
        buttonTabCount.backgroundColor = UIColor.gray
        buttonAddComment.layer.masksToBounds = true
        buttonAddComment.layer.cornerRadius = 20
        
        
    }
    
    
    

 
    
    // 타이머 버튼
    @IBAction func buttonAmrapProgressBar(_ sender: UIButton) {
    
        if countUpButtonStatus{
            
            if countUpButtonOnOff{
                progressCirclePause(nowTime: Double(countUp))
                countUpTimer.invalidate()
                labelTimer.text = "Pause"
                labelTimer.textColor = UIColor.gray
                countUpButtonOnOff = false
              
                buttonTabCount.isEnabled = false
                buttonTabCount.backgroundColor = UIColor.gray
           
            }else{
                
                labelTimer.text = "\(minuteText):\(secondText)"
                progressCircleRestart(nowTime: Double(countUp))
            
                if status{
                    labelTimer.textColor = orangeColor
                    //탭버튼 활성화
                    buttonTabCount.backgroundColor = orangeColor
                    buttonTabCount.isEnabled = true
                }else{
                    amrapTimeProgressBar.shapeLayer.strokeColor = UIColor.gray.cgColor
                    labelTimer.textColor = UIColor.gray
                    
                }
                countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
                
                countUpButtonOnOff = true
                
            }
           
            
        }else{
            isTimerStarted = true
            
            if countDownButtonStatus{
                labelRound.isHidden = false
                imageViewSuccess.isHidden = true
                buttonTabCount.isHidden = false
                labelTimer.text = "\(countDown)"
                countDownTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countDownSelector, userInfo: nil, repeats: true)
                if countDown > 5 {
                    playSound(file: "StartWorkOut", ext: "mp3")
                }
                countDownButtonStatus = false
                labelTimer.textColor = UIColor.orange
                //buttonAddComent.backgroundColor = UIColor.orange
                
                //카운트다운 PAUSE
            }else{
                playSound(file: "PauseWorkOut", ext: "mp3")
                labelTimer.text = "Pause"
                labelTimer.textColor = UIColor.gray
                //buttonAddComent.backgroundColor = UIColor.gray
                countDownButtonStatus = true
                countDownTimer.invalidate()
                
            }
        }
    }
    
    
    
    // 탭 카운트 버튼
    @IBAction func buttonTabCount(_ sender: UIButton) {
        
            tabCount += 1 // tab 할때마다 1씩 증가
            buttonTabCount.setTitle("COUNT : \(tabCount)", for: .normal)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "amrapTimeAddComment"{
            let addNoteView = segue.destination as! AmrapCommentViewController
            addNoteView.receiveItem(getExerciseTime.count, currentTime, String(totalTime))
            
            
            
        }
    }
    
    
    
    // from segue
    func receiveItem(_ rest: [Int], _ exercise: [Int]) {
        getRestTime = rest
        getExerciseTime = exercise
    }

    // count down
    @objc  func countDownTime(){
        
        labelTimer.text = "\(countDown)"
        countDown -= 1
        
        if countDown == 2{
            playSound(file: "CountDown", ext: "wav")
        }
        
      
        
        if countDown == -1{
            countDownTimer.invalidate()
           
            countUpButtonStatus = true
    
            countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
            progressCircle()
            buttonTabCount.backgroundColor = orangeColor
            buttonTabCount.isEnabled = true
        }
    }
    
    
    // count up
    @objc func updateTime(){
        //when count up starts countdown is invalidated
        countDownTimer.invalidate()

        if countUp == 0{
            labelTimer.text = "GO"
        }
        totalWorked += 1
        countUp += 1
        second += 1
        
        if second == 60 {
            minute += 1
            second = 0
        }
        
        if minute < 10{
            minuteText = "0\(minute)" // 분이 10보다 작으면 앞에 0을 붙여주므로 01:00을 완성
        }else{
            minuteText = "\(minute)"
        }
        if second < 10{
            secondText = "0\(second)"
        }else{
            secondText = "\(second)"
        }
        
        labelTimer.text = "\(minuteText):\(secondText)"
        countSound()
        if countUp == AmrapTimerViewController.timeOut{
           
            
            if status{
           
                tapOneMore = tabCount + 1
                AmrapTimerViewController.timeOut = getRestTime[roundCount-1]
                progressCircle()
                status = false
                labelTimer.textColor = UIColor.gray
                amrapTimeProgressBar.shapeLayer.strokeColor = UIColor.gray.cgColor
                countUp = 0
                minute = 0
                second = 0
                
                buttonTabCount.backgroundColor = UIColor.gray
                buttonTabCount.isEnabled = false
                getTime = getRestTime[roundCount-1]
                
                
            }else{
               
                if roundCount == getRestTime.count{
                    
                    insertData("")
                    isTimerEnd = true
                    countUpTimer.invalidate()
                    buttonAmrapProgressBar.isEnabled = false
                    labelTimer.text = "END"
                    buttonTabCount.isEnabled = false
                    buttonTabCount.backgroundColor = UIColor.gray
                    buttonAddComment.isHidden = false
                    buttonTabCount.isHidden = true
                    labelRound.isHidden = true
                    viewAmrapTimer.isHidden = true
                    imageViewSuccess.isHidden = false
                    imageViewSuccess.image = UIImage(named: "success.png")
                    labelTimer.isHidden = true
                 
                }else{
                    roundCount += 1
                    AmrapTimerViewController.timeOut = getExerciseTime[roundCount-1]
                    progressCircle()
                    status = true
                    labelTimer.textColor = orangeColor
                    buttonTabCount.backgroundColor = orangeColor
                    buttonTabCount.isEnabled = true
                    amrapTimeProgressBar.shapeLayer.strokeColor = orangeColor.cgColor
                    countUp = 0
                    minute = 0
                    second = 0
                    if roundCount < getExerciseTime.count{
                        getTime = getExerciseTime[roundCount]
                    }
                    
                
                    labelRound.text = "총 \(getExerciseTime.count) 라운드중 \(roundCount) 라운드 진행중"
                
                }
            }
            
        }
    
    }
    
    
    //back button
    @IBAction func buttonBack(_ sender: Any) {
        if isTimerStarted && isTimerEnd == false {
            labelTimer.text = "Pause"
            countDownTimer.invalidate()
            labelTimer.textColor = UIColor.gray
            countDownButtonStatus = true

            progressCirclePause(nowTime: Double(countUp))
            countUpTimer.invalidate()
            labelTimer.text = "Pause"
            labelTimer.textColor = UIColor.gray
            countUpButtonOnOff = false
            
            let alertEnd = UIAlertController( title: "운동을 그만하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)

            let alertActionEnd = UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: { [self]ACTION in
                navigationController?.popViewController(animated: true)
            })
            let alertActionCancel = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
            
            alertEnd.addAction(alertActionEnd)
            alertEnd.addAction(alertActionCancel)
            present(alertEnd, animated: true, completion: nil)
            
        }else{
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    //Function for inserting into SQLite
    func insertData(_ isEnd : String) {
        var strMinute = ""
        var strSecond = ""
        for i in 0..<getExerciseTime.count{
            totalTime += getExerciseTime[i]
        }
        
        if (totalTime / 60 < 10){
            strMinute = "0\(totalTime/60)"
        }else{
            strMinute = "\(totalTime/60)"
        }
        
        if totalTime % 60 < 10{
            strSecond = "0\(totalTime%60)"
        }else{
            strSecond = "\(totalTime%60)"
        }
        let InsertExerciseName: String = "AMRAP"
        let InsertExerciseHow: String = " /\(strMinute):\(strSecond) min \(tabCount)rounds"
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yy-MM-dd / HH:mm:ss"
        let current_year_string = formatter_year.string(from: Date())
        let InsertExerciseWhen: String = current_year_string
        currentTime = current_year_string
        let InsertExerciseJudgment: String = isEnd
        let InsertExerciseComment: String = " "
        db.insert(exerciseSequenceNumber: 0, exerciseName: "\(InsertExerciseName)", exerciseHow: "\(InsertExerciseHow)", exerciseWhen: "\(InsertExerciseWhen)", exerciseJudgment: "\(InsertExerciseJudgment)", exerciseComment: "\(InsertExerciseComment)")
        
    }
    
    
    
    // Function for progress bar
    func progressCircle() {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewAmrapTimer.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        amrapTimeProgressBar.addProgressBar(radius: radius, progress: progress)
        amrapTimeProgressBar.center = viewAmrapTimer.center

        //Adding view
        viewAmrapTimer.addSubview(amrapTimeProgressBar)
        amrapTimeProgressBar.loadProgress(percentage: progress)
        
    }
    
    func progressCirclePause(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewAmrapTimer.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        amrapTimeProgressBar.addProgressBar(radius: radius, progress: progress)
        amrapTimeProgressBar.center = viewAmrapTimer.center


        //Adding view
        viewAmrapTimer.addSubview(amrapTimeProgressBar)
        amrapTimeProgressBar.loadProgressPause(percentage: progress,nowTime: nowTime)
    }
    
    func progressCircleRestart(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewAmrapTimer.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        amrapTimeProgressBar.addProgressBar(radius: radius, progress: progress)
        amrapTimeProgressBar.center = viewAmrapTimer.center

        //Adding view
        viewAmrapTimer.addSubview(amrapTimeProgressBar)

        amrapTimeProgressBar.loadProgressRestart(percentage: progress, nowTime: nowTime)
    }
    
    // segue to return to AmrapCommentViewController
    @IBAction func unwindAmrapTimer (segue : UIStoryboardSegue) {
        
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
     
        if AmrapTimerViewController.timeOut <= 20 {
            
            if AmrapTimerViewController.timeOut - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if AmrapTimerViewController.timeOut - countUp == AmrapTimerViewController.timeOut/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
    
        }else{
            if AmrapTimerViewController.timeOut - countUp == 10{
                playSound(file: "TenSecondLeft", ext: "mp3")
            }
            if AmrapTimerViewController.timeOut - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if AmrapTimerViewController.timeOut - countUp == AmrapTimerViewController.timeOut/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
        }
    }
    
}
