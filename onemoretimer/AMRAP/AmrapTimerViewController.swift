//
//  AmrapTimeTimerViewController.swift
//  onemoretimer
//
//  Created by 최지석 on 2021/02/26.
//

import UIKit
import AVFoundation

class AmrapTimerViewController: UIViewController {


    
    @IBOutlet weak var imageViewSuccess: UIImageView!
    @IBOutlet weak var buttonAddComent: UIButton!
    @IBOutlet weak var buttonTabCount: UIButton!
    
    @IBOutlet weak var buttonAmrapProgressBar: UIButton!
    @IBOutlet weak var labelRound: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var viewAmrapTimer: UIView!
    @IBOutlet weak var labelFinishMent: UILabel!
    
    var labelStrMinute = ""
    var labelStrSecond = ""
    var db:DBHelper = DBHelper()
    var audioPlayer = AVAudioPlayer()
    
    var getExerciseTime:[Int] = []
    var getRestTime:[Int] = []
    var getTime = 0
    

    // 프로그래스바 //
    var amrapTimeProgressBar = AmrapTimeProgressBar()
    var radius: CGFloat!
    var progress: CGFloat!
    var answeredCorrect = 0
    var totalQuestions = 0
    
    // 타이머 //
    let countUpSelector: Selector = #selector(AmrapTimerViewController.updateTime)
    let countDownSelector: Selector = #selector(AmrapTimerViewController.countDownTime)
    static var timeOut = 0 // 시간 얼마나 가는지는 이 변수로 설정.
    let interval = 1.0// 시간 interval  1초
    var countUpTimer = Timer()
    var countDownTimer = Timer()
    var countDown = UserDefaults.standard.integer(forKey: "countOffTime")
    var countUp = 0 // 총 TIMER COUNT
    var minute = 0 // TIMER 분
    var second = 0 // TIMER 초
    var minuteText = ""
    var secondText = ""
    var totalTime = 0
    
    var status = true // true일때 운동중 false일때 휴식중
    
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
    
    
    // button status //
    var countDownButtonStatus = true // 처음에는 카운트다운버튼 활성화
    var countUpButtonStatus = false // 처음에는 카운트업버튼 비활성화
    var countUpButtonOnOff = true // true 일때가 restart, false 일때가 pause
    let orangeColor = #colorLiteral(red: 1, green: 0.5215686275, blue: 0.2039215686, alpha: 1)                  // true 일때 누르면 false 로 바뀌면서 pause
    
    // To Segue
    var currentTime: String = ""
    
    var roundCount = 1
    
    var isTimerStarted = false
    var isTimerEnd = false

    var totalWorked = 0
    
    // 탭 카운트
    var tabCount = 0 // 초기값 설정
    var tapOneMore = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmrapTimerViewController.timeOut = getExerciseTime[0] // timeOut 변수에 segue로 가져온 값 Int변환 및 초로 변환
        print("\(AmrapTimerViewController.timeOut) 나 타임아웃")
        
        // --------------- 라벨 초기값 설정 --------------- //
        if getRestTime[0] / 60 < 10{
            labelStrMinute = "총\(getRestTime.count) 회중 \(roundCount)회차 0\(getExerciseTime[0]/60):"
        }else{
            labelStrMinute = "총\(getRestTime.count) 회중 \(roundCount)회차 \(getExerciseTime[0]/60):"
        }
        
        
        if getRestTime[0] % 60 < 10{
            labelStrSecond = "0\(getExerciseTime[0] % 60)"
        }else{
            labelStrSecond = "\(getExerciseTime[0] % 60)"
        }
        labelRound.text = labelStrMinute+labelStrSecond
        
        getTime = getExerciseTime[0]
        // --------------- 라벨 초기값 설정 --------------- //
        
        viewAmrapTimer.layer.masksToBounds = true
        viewAmrapTimer.layer.cornerRadius = 20
        buttonTabCount.layer.masksToBounds = true
        buttonTabCount.layer.cornerRadius = 20

        buttonTabCount.setTitle("COUNT : \(tabCount)", for: .normal)
        buttonTabCount.isHidden = true
        buttonTabCount.backgroundColor = UIColor.gray
        
        //buttonTabCount.layer.masksToBounds = true
        //buttonTabCount.layer.cornerRadius = 20
        
    }
    
    
    

    func insertData(_ isEnd : String) {
        print("is End ======\(isEnd)======== ")
        
        
        var strMinute = ""
        var strSecond = ""
        for i in 0..<getExerciseTime.count{
            print(getExerciseTime[i])
            totalTime += getExerciseTime[i]
            print("\(totalTime)difojewiofwejfiowefioew")
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
        
        
        
        
        let InsertExerciseName: String = "AMRAPTIME"
        // 운동 이름 꼭꼭 대문자여야함 안지키면 혼난다
                
        let InsertExerciseHow: String = " / \(strMinute):\(strSecond) min"
        // 운동을 어떻게 했는지
        
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yy-MM-dd / HH:mm:ss"
        let current_year_string = formatter_year.string(from: Date())
        //현재 시간 출력

        let InsertExerciseWhen: String = current_year_string
        // 토탈타임 넣기
        currentTime = current_year_string
        // print("나 토탈타임" + getTotalTime)
        // 언제 운동했는지 위에서 찍은 시간 그대로 입력
        
        let InsertExerciseJudgment: String = isEnd
        // 중단했는지 여부
        // 중단했으면 중단했습니다. 중단 안했으면 그냥 빈값
        
        let InsertExerciseComment: String = " "
        
        // id 는 시퀀스 넘버로, 0으로 입력해놓으면 AI
        db.insert(exerciseSequenceNumber: 0, exerciseName: "\(InsertExerciseName)", exerciseHow: "\(InsertExerciseHow)", exerciseWhen: "\(InsertExerciseWhen)", exerciseJudgment: "\(InsertExerciseJudgment)", exerciseComment: "\(InsertExerciseComment)")
        
    }
    
    // 타이머 버튼
    @IBAction func buttonAmrapProgressBar(_ sender: UIButton) {
        print("")
        if countUpButtonStatus{
            // 카운트 업일때 버튼 ACTION
            // TRUE 일때 누르면 STOP
            if countUpButtonOnOff{
                progressCirclePause(nowTime: Double(countUp))
                countUpTimer.invalidate()
                labelTimer.text = "pause"
                labelTimer.textColor = UIColor.gray
                countUpButtonOnOff = false
                // 탭버튼 비활성화
                buttonTabCount.isEnabled = false
                buttonTabCount.backgroundColor = UIColor.gray
                
            // FALSE 일때 누르면 RESTART
            }else{
                
                labelTimer.text = "\(minuteText):\(secondText)"
                progressCircleRestart(nowTime: Double(countUp))
                // 휴식일때 퍼즈 -> 재시작때 회색 유지
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
            // 카운트 다운일때 버튼 ACTION
            // 카운트다운 START
            if countDownButtonStatus{
                labelRound.isHidden = false
                imageViewSuccess.isHidden = true
                buttonTabCount.isHidden = false
                labelTimer.text = "\(countDown)"
                countDownTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countDownSelector, userInfo: nil, repeats: true)
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
        
        if segue.identifier == "amrapTimeAddComent"{
            let addNoteView = segue.destination as! AmrapCommentViewController
           print("\(totalTime)zzzzz")
            addNoteView.receiveItem(getExerciseTime.count, currentTime, String(totalTime))
            
            
            
        }
    }
    
    
    
    // segue 연결
    func receiveItem(_ rest: [Int], _ exercise: [Int]) {
        getRestTime = rest
        getExerciseTime = exercise
    }

    // COUNTDOWN
    @objc  func countDownTime(){
        
        labelTimer.text = "\(countDown)"
        countDown -= 1
        if countDown == -1{
            countDownTimer.invalidate()
            countUpButtonStatus = true
            labelTimer.text = "GO"
            countUpTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: countUpSelector, userInfo: nil, repeats: true)
            progressCircle()
            buttonTabCount.backgroundColor = orangeColor
            buttonTabCount.isEnabled = true
        }
    }
    
    
    // COUNTUP
    @objc func updateTime(){

        if countUp == 0{

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
      
        print(AmrapTimerViewController.timeOut)
        
        countSound()
        
        // 타임아웃 //
        
        if countUp == AmrapTimerViewController.timeOut{
            
            
            progressCircle()
            if status{
                // 운동끝
                tapOneMore = tabCount + 1
                
                status = false
                labelTimer.textColor = UIColor.gray
                amrapTimeProgressBar.shapeLayer.strokeColor = UIColor.gray.cgColor
                AmrapTimerViewController.timeOut = getRestTime[roundCount-1]
                countUp = 0
                minute = 0
                second = 0
                
                buttonTabCount.backgroundColor = UIColor.gray
                buttonTabCount.isEnabled = false
                getTime = getRestTime[roundCount]
                
                
            }else{
                // 휴식끝
                if roundCount == getRestTime.count{
                    
                    insertData("")
                    isTimerEnd = true
                    countUpTimer.invalidate()
                    buttonAmrapProgressBar.isEnabled = false
                    labelTimer.text = "END"
                    buttonTabCount.isEnabled = false
                    buttonTabCount.backgroundColor = UIColor.gray
                    buttonAddComent.isHidden = false
                    buttonTabCount.isHidden = true
                    labelRound.isHidden = true
                    viewAmrapTimer.isHidden = true
                    imageViewSuccess.isHidden = false
                    labelTimer.isHidden = true
                    labelFinishMent.text = randomText[random]
                    playSound(file: "EndWorkOut", ext: "mp3")
                    
                }else{
                    roundCount += 1
                    AmrapTimerViewController.timeOut = getExerciseTime[roundCount-1]
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
                    
                    // --------------- 라벨 초기값 설정 --------------- //
                    if getRestTime[roundCount-1] / 60 < 10{
                        labelStrMinute = "총\(getRestTime.count) 회중 \(roundCount)회차 0\(getExerciseTime[roundCount-1]/60):"
                    }else{
                        labelStrMinute = "총\(getRestTime.count) 회중 \(roundCount)회차 \(getExerciseTime[roundCount-1]/60):"
                    }
                    
                    if getRestTime[roundCount-1] % 60 < 10{
                        labelStrSecond = "0\(getExerciseTime[roundCount-1] % 60)"
                    }else{
                        labelStrSecond = "\(getExerciseTime[roundCount-1] % 60)"
                    }
                    labelRound.text = labelStrMinute+labelStrSecond
                    // --------------- 라벨 초기값 설정 --------------- //
                }
            }
            
        }
    
    }
    
    
    
    @IBAction func buttonBack(_ sender: Any) {
        if isTimerStarted && isTimerEnd == false { // 타이머 시작된 경우
            
            // 카운트 다운 정지
            labelTimer.text = "Pause"
            countDownTimer.invalidate()
            labelTimer.textColor = UIColor.gray
//            buttonAddComent.backgroundColor = UIColor.gray
            countDownButtonStatus = true
            
          
            // 타이머 정지.
            progressCirclePause(nowTime: Double(countUp))
            countUpTimer.invalidate()
            labelTimer.text = "pause"
            labelTimer.textColor = UIColor.gray
//            buttonAddComent.backgroundColor = UIColor.gray
//            buttonAddComent.isEnabled = false
            countUpButtonOnOff = false
            
            // 운동 그만할지 Alert 띄우기
            let alertEnd = UIAlertController( title: "운동을 그만하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)

            let alertActionEnd = UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: { [self]ACTION in
                navigationController?.popViewController(animated: true)
            })
            let alertActionCancel = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
            
            alertEnd.addAction(alertActionEnd)
            alertEnd.addAction(alertActionCancel)
            present(alertEnd, animated: true, completion: nil)
            
        }else{ // 타이머 시작 안된 경우
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    //처음 시작 프로그래스바 (기본)
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
    
    
    
    // 프로그래스바 일시정지
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
    
    // 프로그래스바 재시작
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
    
    
    
    
    func playSound(file: String , ext: String) -> Void {
        //사운드 옵션이 켜져있을때
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
    
    func countSound(){
        // 설정한 카운트가 20초보다 작은경우
        if getTime <= 20 {
            
            if getTime - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if getTime - countUp == getTime/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
        // 설정한 카운트가 20초보다 큰경우
        }else{
            if getTime - countUp == 10{
                playSound(file: "TenSecondLeft", ext: "mp3")
            }
            if getTime - countUp == 3{
                playSound(file: "CountDown", ext: "wav")
            }
            if getTime - countUp == getTime/2 {
                playSound(file: "HalfInWorkOut", ext: "mp3")
            }
            
        }
        
      
        
    }
    
}
