//
//  ForTimeTimerViewController.swift
//  onemoretimer
//
//  Created by 정정이 on 2021/02/23.
//

import UIKit
import AVFoundation

class ForTimeTimerViewController: UIViewController {
   
    // SQLite Link
    var db:DBHelper = DBHelper()
    //UI link
    @IBOutlet weak var imageViewFinish: UIImageView!
    @IBOutlet weak var forTimeTimerUIView: UIView!
    @IBOutlet weak var buttonTabCount: UIButton!
    @IBOutlet weak var forTimeProgressBarUIView: UIView!
    @IBOutlet weak var labelTotalRound: UILabel!
    @IBOutlet weak var buttonTabProgressBar: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var buttonAddComment: UIButton!
    
    // From Segue
    var getTime: String = ""
    var getRound: String = ""
    // To Segue
    var currentTime: String = ""
    
    // sound for counter
    var audioPlayer = AVAudioPlayer()
    var soundIsOn :Bool = UserDefaults.standard.bool(forKey: "switchIsOn")
    
    // About progress bar
    var forTimeProgressBar = ForTimeProgressBar()
    var radius: CGFloat!
    var progress: CGFloat!
    var answeredCorrect = 0
    var totalQuestions = 0
    
    // about timer
    let countUpSelector: Selector = #selector(ForTimeTimerViewController.updateTime)
    let countDownSelector: Selector = #selector(ForTimeTimerViewController.countDownTime)
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
    
    var roundCount = 1
    
    //Timer status: For logging the WorkoutLog.
    var isTimerStarted = false
    var isTimerEnd = false
    
    var totalWorked = 0
    
  
    
    //Create a tab counter to use while the timer is moving
    var tabCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ForTimeTimerViewController.timeOut = Int(getTime)! * 60
        
     
        
        imageViewFinish.image = UIImage(named: "TimerImage.png")
        
        //UI Shape
     
        forTimeTimerUIView.layer.masksToBounds = true
        forTimeTimerUIView.layer.cornerRadius = 20
        buttonTabCount.layer.masksToBounds = true
        buttonTabCount.layer.cornerRadius = 20
        
        buttonTabCount.setTitle("COUNT : \(tabCount)", for: .normal)
        buttonTabCount.isEnabled = false
        buttonTabCount.backgroundColor = UIColor.gray
        buttonAddComment.layer.masksToBounds = true
        buttonAddComment.layer.cornerRadius = 20
    }
    
    @IBAction func buttonTabCount(_ sender: UIButton) {
        tabCount += 1
        buttonTabCount.setTitle("COUNT : \(tabCount)", for: .normal)
        labelTotalRound.text = "총\(getRound)회중 \(tabCount)회차"
        if tabCount == Int(getRound){
            isTimerEnd = true
            insertData("")
            countUpTimer.invalidate()
            buttonTabProgressBar.isEnabled = false
            labelTimer.text = "END"
            buttonTabCount.isEnabled = false
            buttonTabCount.backgroundColor = UIColor.gray
            buttonAddComment.isHidden = false
            buttonTabCount.isHidden = true
            labelTotalRound.isHidden = true
            forTimeProgressBarUIView.isHidden = true
            imageViewFinish.isHidden = false
            imageViewFinish.image = UIImage(named: "success.png")
            labelTimer.isHidden = true
            buttonTabProgressBar.isHidden = true
            playSound(file: "EndWorkOut", ext: "mp3")
         
        }
        
    }
    //Main timer
    @IBAction func buttonTabProgressBar(_ sender: UIButton) {
        
        
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
                labelTimer.text = "\(textMinute):\(textSecond)"
                progressCircleRestart(nowTime: Double(countUp))
                countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
                labelTimer.textColor = orangeColor
                countUpButtonOnOff = true
                buttonTabCount.backgroundColor = orangeColor
                buttonTabCount.isEnabled = true
            }
           
            
        }else{
            isTimerStarted = true
            if countDownButtonStatus{
                labelTotalRound.isHidden = false
                labelTotalRound.text = "총\(getRound)회중 \(tabCount)회차"
                buttonTabCount.isHidden = false
                imageViewFinish.isHidden = true
                if countDown > 5 {
                    playSound(file: "StartWorkOut", ext: "mp3")
                }
                labelTimer.text = "\(countDown)"
                countDownTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countDownSelector, userInfo: nil, repeats: true)
                countDownButtonStatus = false
                labelTimer.textColor = orangeColor
                buttonTabCount.backgroundColor = UIColor.gray
            }else{
                
                labelTimer.text = "Pause"
                labelTimer.textColor = UIColor.gray
                buttonTabCount.backgroundColor = UIColor.gray
                countDownButtonStatus = true
                countDownTimer.invalidate()
                
            }
        }
    }
    // from segue
    func receiveItem(_ time: String, _ round: String) {
          getTime = time
          getRound = round

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
              labelTimer.text = "GO"
              countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
          }
      }
      // count up
      @objc func updateTime(){
        countSound()
          if countUp == 0{
              progressCircle()
              buttonTabCount.backgroundColor = orangeColor
              buttonTabCount.isEnabled = true
          }else{
          }
        totalWorked += 1
          countUp += 1
          second += 1
          
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
          labelTimer.text = "\(textMinute):\(textSecond)"
         
    
        if countUp == ForTimeTimerViewController.timeOut{
            isTimerEnd = true
            insertData("")
            countUpTimer.invalidate()
            buttonTabProgressBar.isEnabled = false
            labelTimer.text = "END"
            buttonTabCount.isEnabled = false
            buttonTabCount.backgroundColor = UIColor.gray
            buttonAddComment.isHidden = false
            buttonTabCount.isHidden = true
            labelTotalRound.isHidden = true
            forTimeProgressBarUIView.isHidden = true
            imageViewFinish.isHidden = false
            imageViewFinish.image = UIImage(named: "success.png")
            labelTimer.isHidden = true
            buttonTabProgressBar.isHidden = true
          

          }
    
       
 
      }
    
    //back button
    @IBAction func buttonBack(_ sender: UIBarButtonItem) {
        // when timer is running
        if isTimerStarted && isTimerEnd == false {
            
            labelTimer.text = "Pause"
            countDownTimer.invalidate()
            labelTimer.textColor = UIColor.gray
            buttonTabCount.backgroundColor = UIColor.gray
            countDownButtonStatus = true
            // break timer
            progressCirclePause(nowTime: Double(countUp))
            countUpTimer.invalidate()
            labelTimer.text = "Pause"
            labelTimer.textColor = UIColor.gray
            buttonTabCount.backgroundColor = UIColor.gray
            buttonTabCount.isEnabled = false
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
            
        }else{// when timer is not running
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        countDownTimer.invalidate()
        countUpTimer.invalidate()
        if isTimerStarted && isTimerEnd == false{
            insertData("중단했습니다.")
        }
        
        
    }
    
    //Function for inserting into SQLite
    func insertData(_ isEnd : String) {
        var stringWorkTime = " "
        let minute = totalWorked / 60
        let second = totalWorked % 60
      
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
       
        let InsertExerciseName: String = "FORTIME"
        let InsertExerciseHow: String = " / \(stringWorkTime) min \(tabCount)R"
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
          radius = (forTimeProgressBarUIView.frame.height)/2.60
          progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
          forTimeProgressBar.addProgressBar(radius: radius, progress: progress)
          forTimeProgressBar.center = forTimeProgressBarUIView.center

          //Adding view
          forTimeProgressBarUIView.addSubview(forTimeProgressBar)
          forTimeProgressBar.loadProgress(percentage: progress)
      }
    
      func progressCirclePause(nowTime: Double) {
          answeredCorrect = 100
          totalQuestions = 100

          //Configure Progress Bar
          radius = (forTimeProgressBarUIView.frame.height)/2.60
          progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
          forTimeProgressBar.addProgressBar(radius: radius, progress: progress)
          forTimeProgressBar.center = forTimeProgressBarUIView.center


          //Adding view
          forTimeProgressBarUIView.addSubview(forTimeProgressBar)
          forTimeProgressBar.loadProgressPause(percentage: progress,nowTime: nowTime)
      }
    
      func progressCircleRestart(nowTime: Double) {
          answeredCorrect = 100
          totalQuestions = 100

          //Configure Progress Bar
          radius = (forTimeProgressBarUIView.frame.height)/2.60
          progress = CGFloat(answeredCorrect) / CGFloat (totalQuestions)
          forTimeProgressBar.addProgressBar(radius: radius, progress: progress)
          forTimeProgressBar.center = forTimeProgressBarUIView.center

          //Adding view
          forTimeProgressBarUIView.addSubview(forTimeProgressBar)

          forTimeProgressBar.loadProgressRestart(percentage: progress, nowTime: nowTime)
      }
    
    
    func pauseTimer(){
        playSound(file: "PauseWorkOut", ext: "mp3")
        progressCirclePause(nowTime: Double(countUp))
        countUpTimer.invalidate()
        labelTimer.text = "pause"
        labelTimer.textColor = UIColor.gray
        countUpButtonOnOff = true
        
    }
   
    func restartTimer(){
        
        labelTimer.text = "\(textMinute):\(textSecond)"
        progressCircleRestart(nowTime: Double(countUp))
        countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
        labelTimer.textColor = orangeColor
        countUpButtonOnOff = false
        
    }

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ForTimeCommentSegue"{
            let addNoteView = segue.destination as! ForTimeCommentViewController
       
            addNoteView.receiveItem(Int(getRound)!,currentTime, totalWorked)
           
           
        }
    }
    // segue to return to ForTimeCommentViewController
    @IBAction func unwindForTimeTimer (segue : UIStoryboardSegue) {
        
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
        
        if ForTimeTimerViewController.timeOut <= 20 {
            
            if ForTimeTimerViewController.timeOut - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if ForTimeTimerViewController.timeOut - countUp == ForTimeTimerViewController.timeOut/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
        
        }else{
            if ForTimeTimerViewController.timeOut - countUp == 10{
                playSound(file: "TenSecondLeft", ext: "mp3")
            }
            if ForTimeTimerViewController.timeOut - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if ForTimeTimerViewController.timeOut - countUp == ForTimeTimerViewController.timeOut/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
        }
    }
}

