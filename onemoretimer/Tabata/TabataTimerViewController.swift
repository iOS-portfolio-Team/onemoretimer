//
//  TabataTimerViewController.swift
//  onemoretimer
//
//  Created by jonghan on 2021/02/24.
//

import UIKit
import AVFoundation

class TabataTimerViewController: UIViewController {

    // SQLite Link
    var db:DBHelper = DBHelper()

    @IBOutlet weak var viewTabataTimer: UIView!
    @IBOutlet weak var viewTabataProgressBar: UIView!
    @IBOutlet weak var buttonTabProgressBar: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var labelSet: UILabel!
    @IBOutlet var labelShowRest: UILabel!
    @IBOutlet var buttonCheckResult: UIButton!
    @IBOutlet var imageViewFinish: UIImageView!

    
    // From Segue
    var getRound: Int = 0
    var getWork: Int = 0
    var getRest: Int = 0
    var getSet: Int = 0
    var getSetRest: Int = 0
    var getTime = ""
    
   // About progress bar
    var circularProgressBar = TabataProgressBar()
    var radius: CGFloat!
    var progress: CGFloat!
    var answeredCorrect = 0
    var totalQuestions = 0
    
    // about timer
    let countUpSelector: Selector = #selector(TabataTimerViewController.updateTime)
    let countDownSelector: Selector = #selector(TabataTimerViewController.countDownTime)
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
    
    //status : for check timer status
    var countDownButtonStatus = true
    var countUpButtonStatus = false
    var countUpButtonOnOff = true
    let orangeColor = #colorLiteral(red: 1, green: 0.5215686275, blue: 0.2039215686, alpha: 1)
    
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
   
    //Count for round
    var roundCount = 0
    var setCount = 0
    var totalWorked = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TabataTimerViewController.timeOut = getWork
    
        
        //UI Shape
        viewTabataTimer.layer.masksToBounds = true
        viewTabataTimer.layer.cornerRadius = 20
        buttonCheckResult.layer.masksToBounds = true
        buttonCheckResult.layer.cornerRadius = 20
        imageViewFinish.isHidden = false
        imageViewFinish.image = UIImage(named:"TimerImage.png")
        buttonCheckResult.isEnabled = false
        
        
        buttonCheckResult.isHidden = true
        
        labelSet.text = "1 세트 ( 1 / \(getRound) )"
        labelShowRest.text = "총 \(getSet)회 중 1번째 세트"
    }
    
    //Main timer
    @IBAction func buttonTabProgressBar(_ sender: UIButton) {
        imageViewFinish.isHidden = true
            if countUpButtonStatus{
                if countUpButtonOnOff{
                    playSound(file: "PauseWorkOut", ext: "mp3")
                    progressCirclePause(nowTime: Double(countUp))
                    countUpTimer.invalidate()
                    labelTimer.text = "pause"
                    labelTimer.textColor = UIColor.gray
                    countUpButtonOnOff = false

                }else{
                    labelTimer.text = "\(minuteText):\(secondText)"
                    progressCircleRestart(nowTime: Double(countUp))
                    countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
                    if isWork{
                        labelTimer.textColor = UIColor.orange
                    }
                    countUpButtonOnOff = true
                }
            }else{
                isTimerStarted = true
                if countDownButtonStatus{
                    imageViewFinish.isHidden = true
                    labelShowRest.isHidden = false
                    if countDown > 5 {
                    
                        playSound(file: "StartWorkOut", ext: "mp3")
                    }
                    labelTimer.text = "\(countDown)"
                    countDownTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countDownSelector, userInfo: nil, repeats: true)
                    labelTimer.textColor = UIColor.orange
                    countDownButtonStatus = false

                }else{
                    labelTimer.text = "Pause"
                    countDownTimer.invalidate()
                    labelTimer.textColor = UIColor.gray
                    countDownButtonStatus = true
                }
            }
       
    }
    
    
    //back button
    @IBAction func barButtonBack(_ sender: UIBarButtonItem) {
        // when timer is running
        if isTimerStarted && isTimerEnd == false {
           
            labelTimer.text = "Pause"
            countDownTimer.invalidate()
            labelTimer.textColor = UIColor.gray
            countDownButtonStatus = true
            // break timer
            progressCirclePause(nowTime: Double(countUp))
            countUpTimer.invalidate()
            labelTimer.text = "Pause"
            labelTimer.textColor = UIColor.gray
            countUpButtonOnOff = false
            
            // Floating Alert
            let alertEnd = UIAlertController( title: "운동을 그만하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
            let alertActionEnd = UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: { [self]ACTION in
                navigationController?.popViewController(animated: true)
            })
            let alertActionCancel = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
            alertEnd.addAction(alertActionEnd)
            alertEnd.addAction(alertActionCancel)
            present(alertEnd, animated: true, completion: nil)
        // when timer is not running
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    

    
    // from segue
    func receiveItem(_ round: Int, _ work: Int, _ rest: Int, _ set: Int, _ setRest: Int) {
        getRound = round
        getWork = work
        getRest = rest
        getSet = set
        getSetRest = setRest
    }
    
    
    
    // count down
    @objc  func countDownTime(){
        labelTimer.text = "\(countDown)"
        countDown -= 1
        if countDown == 2 {
            playSound(file: "CountDown", ext: "wav")
        }
        
        if countDown == -1{
            countDownTimer.invalidate()
            countUpButtonStatus = true
            labelTimer.text = "GO"
            
            
                countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
        }
    }
    // count up
    @objc func updateTime(){
        
        if countUp == 0{
            if setCount == getSet {
                isTimerEnd = true
                insertData("")
                countUpTimer.invalidate()
                buttonTabProgressBar.isEnabled = false
                labelShowRest.isHidden = true
                labelSet.isHidden = true
                viewTabataProgressBar.isHidden = true
                labelTimer.isHidden = true
                imageViewFinish.isHidden = false
                imageViewFinish.image = UIImage(named: "success.png")
                buttonCheckResult.isHidden = false
                buttonCheckResult.isEnabled = true
                buttonCheckResult.backgroundColor = UIColor.orange
               
            }
            progressCircle()
            
            if isWork {
                labelShowRest.text = "총 \(getSet)회 중 \(setCount + 1)번째 세트"
                labelSet.text = "\(setCount + 1) 세트 ( \(roundCount + 1) / \(getRound) )"
                labelTimer.textColor = UIColor.orange
                circularProgressBar.shapeLayer.strokeColor = UIColor.orange.cgColor
            }else{
                labelTimer.textColor = UIColor.gray
                circularProgressBar.shapeLayer.strokeColor = UIColor.gray.cgColor
            }
        }
        
        totalWorked += 1
        countUp += 1
        second += 1
        countSound()
        
        if second == 60 {
            minute += 1
            second = 0
        }
        
        if minute < 10{
            minuteText = "0\(minute)"
        }else{
            minuteText = "\(minute)"
        }
        if second < 10{
            secondText = "0\(second)"
        }else{
            secondText = "\(second)"
        }
        
        labelTimer.text = "\(minuteText):\(secondText)"
       
        if countUp == TabataTimerViewController.timeOut{
                if isWork{

                    
                    if getRest != 0 {
                        
                        TabataTimerViewController.timeOut = getRest
                        isWork = !isWork
                        
                    }
                   
                    countUp = 0
                    minute = 0
                    second = 0
                    roundCount += 1
                }else{

                    TabataTimerViewController.timeOut = getWork
                    countUp = 0
                    minute = 0
                    second = 0
                    isWork = !isWork
                }
                
                
                if roundCount == getRound {
                    if getSetRest != 0 {
                        TabataTimerViewController.timeOut = getSetRest

                    }
                    countUp = 0
                    minute = 0
                    second = 0
                    roundCount = 0
                    setCount += 1
                }
        }
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        countDownTimer.invalidate()
        countUpTimer.invalidate()
        navigationController?.popViewController(animated: true)
        if isTimerStarted && isTimerEnd == false{
            insertData("중단했습니다.")
        }
        
    }
    
    // Function for progress bar
    func progressCircle() {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewTabataProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        circularProgressBar.addProgressBar(radius: radius, progress: progress)
        circularProgressBar.center = viewTabataProgressBar.center

        //Adding view
        viewTabataProgressBar.addSubview(circularProgressBar)
        circularProgressBar.loadProgress(percentage: progress)
    }

    func progressCirclePause(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewTabataProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        circularProgressBar.addProgressBar(radius: radius, progress: progress)
        circularProgressBar.center = viewTabataProgressBar.center


        //Adding view
        viewTabataProgressBar.addSubview(circularProgressBar)
        circularProgressBar.loadProgressPause(percentage: progress,nowTime: nowTime)
    }

    func progressCircleRestart(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewTabataProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        circularProgressBar.addProgressBar(radius: radius, progress: progress)
        circularProgressBar.center = viewTabataProgressBar.center

        //Adding view
        viewTabataProgressBar.addSubview(circularProgressBar)

        circularProgressBar.loadProgressRestart(percentage: progress, nowTime: nowTime)
        if !isWork {
            circularProgressBar.shapeLayer.strokeColor = UIColor.gray.cgColor
        }
    }
    
    //Function for putting into SQLite
    func insertData(_ isEnd : String) {
        var stringWorkTime = ""
        var minute = 0
        var second = 0
        
        minute = totalWorked / 60
        second = totalWorked % 60
        
        if minute > 10 {
            if second < 10 {
                stringWorkTime = "\(minute):0\(second)"
            }else{
                stringWorkTime = "\(minute):\(second)"
            }
        }else{
            if second < 10 {
                stringWorkTime = "0\(minute):0\(second)"
            }else{
                stringWorkTime = "0\(minute):\(second)"
            }
        }
        let InsertExerciseName: String = "TABATA"
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
            if segue.identifier == "TabataCommentSegue"{
                let addNoteView = segue.destination as! TabataCommentViewController
           
                addNoteView.receiveItem(getRound, getWork, getSet, getTime)

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
        
        if isWork{
            if getWork <= 20 {
                
                if getWork - countUp == 3{
                    playSound(file: "CountDown", ext: "wav")
                }
                if getWork - countUp == getWork/2 {
                    playSound(file: "HalfInWorkOut", ext: "mp3")
                }
                
            }else{
                if getWork - countUp == 10{
                    playSound(file: "TenSecondLeft", ext: "mp3")
                }
                if getWork - countUp == 3{
                    playSound(file: "CountDown", ext: "wav")
                }
                if getWork - countUp == getWork/2 {
                    playSound(file: "HalfInWorkOut", ext: "mp3")
                }
                
            }
        }else{
            if getRest <= 20 {
                
                if getRest - countUp == 3{
                    playSound(file: "CountDown", ext: "wav")
                }
                if getRest - countUp == getRest/2 {
                    playSound(file: "HalfInWorkOut", ext: "mp3")
                }
                
            }else{
                if getRest - countUp == 10{
                    playSound(file: "TenSecondLeft", ext: "mp3")
                }
                if getRest - countUp == 3{
                    playSound(file: "CountDown", ext: "wav")
                }
                if getRest - countUp == getRest/2 {
                    playSound(file: "HalfInWorkOut", ext: "mp3")
                }
            }
        }
        
        
        
    }
    
    // segue to return to EMOMCommentViewController
    @IBAction func unwindTabataTimer (segue : UIStoryboardSegue) {}

}
