//
//  LiftingTimerViewController.swift
//  onemoretimer
//
//  Created by 고종찬 on 2021/02/24.
//

import UIKit
import AVFoundation

class LiftingTimerViewController: UIViewController {
    
    // SQLite Link
    var db:DBHelper = DBHelper()
    
    //UI link
    @IBOutlet weak var imageViewFinish: UIImageView!
    @IBOutlet weak var viewLiftingTimer: UIView!
    @IBOutlet weak var viewLiftingProgressBar: UIView!
    @IBOutlet weak var labelTotalRound: UILabel!
    @IBOutlet weak var buttonTabProgressBar: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var buttonAddComment: UIButton!
    
    // sound for counter
    var audioPlayer = AVAudioPlayer()
    var soundIsOn :Bool = UserDefaults.standard.bool(forKey: "switchIsOn")
    
  
    
    // From Segue
    var getTime: String = ""
    var getRound: String = ""
    // To Segue
    var currentTime: String = ""
   
    // About progress bar
    var liftingProgressBar = LiftingProgressBar()
    var radius: CGFloat!
    var progress: CGFloat!
    var answeredCorrect = 0
    var totalQuestions = 0
    
    
    
    // about timer
    let countUpSelector: Selector = #selector(LiftingTimerViewController.updateTime)
   
    static var timeOut = 0
    let interval = 1.0
    var countUpTimer = Timer()

    var countUp = 0
    var minute = 0
    var second = 0
    var minuteText = ""
    var secondText = ""
    
    //status : for check timer status
    var countStart = true
    var countUpButtonStatus = false
    var countUpButtonOnOff = true
    let orangeColor = #colorLiteral(red: 1, green: 0.5215686275, blue: 0.2039215686, alpha: 1)
    
    var roundCount = 1
    
    //Timer status: For logging the WorkoutLog.
    var isTimerStarted = false
    var isTimerEnd = false
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiftingTimerViewController.timeOut = Int(getTime)!
        
        if Int(getTime)! < 10 {
            labelTotalRound.text = "총\(getRound)회중 \(roundCount)회차"
        }else{
            labelTotalRound.text = "총\(getRound)회중 \(roundCount)회차"
        }
        
        
        
        
        //UI Shape
        imageViewFinish.image = UIImage(named: "TimerImage.png")
        viewLiftingTimer.layer.masksToBounds = true
        viewLiftingTimer.layer.cornerRadius = 20
        buttonAddComment.layer.masksToBounds = true
        buttonAddComment.layer.cornerRadius = 20
       
    }
    
    //Main timer
    @IBAction func buttonTabProgressBar(_ sender: UIButton) {
    
        if countStart{
            imageViewFinish.isHidden = true
            playSound(file: "RestWorkOut", ext: "mp3")
            labelTotalRound.isHidden = false
            if countUpButtonOnOff{
                countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
                labelTimer.textColor = orangeColor
                countUpButtonOnOff = false
                // 최초 타이머 돌아가는중
                isTimerStarted = true
           
            }
        }else{
            if countUpButtonOnOff{
                restartTimer()
            }else{
                pauseTimer()
            }
        }
    }
    
    // from segue
    func receiveItem(_ time: String, _ round: String) {
          getTime = time
          getRound = round
       
      }
    
    // count up
    @objc func updateTime(){
        
        if countUp == 0{
            progressCircle()
            
        }
        
        if countUp == 1{
            countStart = false
        }

        if countUp == Int(getTime){
            countUp += 1
        }else{
            countUp += 1
            second += 1
           
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
        }
        countSound()
       
       
        if countUp == Int(getTime)!+1{
            
          roundCount += 1
          
          labelTotalRound.text = "총\(getRound)회중 \(roundCount)회차"
            
            
          countUp = 0
          minute = 0
          second = 0
          countUpTimer.invalidate()
          countStart = true
          countUpButtonOnOff = true
        }
     
      if Int(getRound)! + 1 == roundCount{
        countUpTimer.invalidate()
        buttonTabProgressBar.isEnabled = false
        labelTimer.text = "END"
        buttonAddComment.isHidden = false
        labelTotalRound.isHidden = true
        viewLiftingProgressBar.isHidden = true
        imageViewFinish.isHidden = false
        imageViewFinish.image = UIImage(named: "success.png")
        labelTimer.isHidden = true
        buttonTabProgressBar.isHidden = true
        isTimerEnd = true
        insertData("")
       
      }
        
        

    }
    
  
    override func viewDidDisappear(_ animated: Bool) {
      
        countUpTimer.invalidate()
        navigationController?.popViewController(animated: true)
        if isTimerStarted == true && isTimerEnd == false{
            insertData("중단했습니다.")
        }
         
    }

    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        // when timer is running
        if isTimerStarted == true && isTimerEnd == false{
            pauseTimer()
            
            let alertController = UIAlertController(title: "운동을 그만하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
            let alertActionPositive = UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: {ACTION in
                
                self.navigationController?.popViewController(animated: true)
                
            })
            let alertActionNegative = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertActionNegative)
            alertController.addAction(alertActionPositive)
            present(alertController, animated: true, completion: nil)
        }else{// when timer is not running
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func insertData(_ isEnd : String) {
        let InsertExerciseName: String = "LIFTING"
        let InsertExerciseHow: String = " / \(getRound)Round"
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
        radius = (viewLiftingProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        liftingProgressBar.addProgressBar(radius: radius, progress: progress)
        liftingProgressBar.center = viewLiftingProgressBar.center

        //Adding view
        viewLiftingProgressBar.addSubview(liftingProgressBar)
        liftingProgressBar.loadProgress(percentage: progress)
    }
    
    
    func progressCirclePause(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewLiftingProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        liftingProgressBar.addProgressBar(radius: radius, progress: progress)
        liftingProgressBar.center = viewLiftingProgressBar.center


        //Adding view
        viewLiftingProgressBar.addSubview(liftingProgressBar)
        liftingProgressBar.loadProgressPause(percentage: progress,nowTime: nowTime)
    }


    func progressCircleRestart(nowTime: Double) {
        answeredCorrect = 100
        totalQuestions = 100

        //Configure Progress Bar
        radius = (viewLiftingProgressBar.frame.height)/2.60
        progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
        liftingProgressBar.addProgressBar(radius: radius, progress: progress)
        liftingProgressBar.center = viewLiftingProgressBar.center

        //Adding view
        viewLiftingProgressBar.addSubview(liftingProgressBar)

        liftingProgressBar.loadProgressRestart(percentage: progress, nowTime: nowTime)
    }


    func pauseTimer(){
        playSound(file: "PauseWorkOut", ext: "mp3")
        progressCirclePause(nowTime: Double(countUp))
        countUpTimer.invalidate()
        labelTimer.text = "Pause"
        labelTimer.textColor = UIColor.gray
        countUpButtonOnOff = true
        
    }
    func restartTimer(){
        
        labelTimer.text = "\(minuteText):\(secondText)"
        progressCircleRestart(nowTime: Double(countUp))
        countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
        labelTimer.textColor = orangeColor
        countUpButtonOnOff = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            if segue.identifier == "LiftingCommentSegue"{
                let addNoteView = segue.destination as! LiftingCommentViewController
           
                addNoteView.receiveItem(Int(getRound)!, Int(getTime)!, currentTime)
               
            }
            
        }
    // segue to return to ForTimeCommentViewController
    @IBAction func segueUnwindLiftingTimer (segue : UIStoryboardSegue) {
        
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
       
        if Int(getTime)! <= 20 {
            
            if Int(getTime)! - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if Int(getTime)! - countUp == Int(getTime)!/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
    
        }else{
            if Int(getTime)! - countUp == 10{
                playSound(file: "TenSecondLeft", ext: "mp3")
            }
            if Int(getTime)! - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if Int(getTime)! - countUp == Int(getTime)!/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
            
        }
        
      
        
    }
   
}
