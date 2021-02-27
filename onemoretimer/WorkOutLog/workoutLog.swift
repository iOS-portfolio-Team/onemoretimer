//
//  workoutLog.swift
//  onemoretimer
//
//  Created by dev on 2021/02/23.
//


import Foundation

class workoutLog
{
    //빈역할 대신해주는 얘들같음 ㅋㅋ
    // 필드값 - 운동명 / 어떻게 / 언제 / 중단했는지 여부 / 코멘트
    
    var exerciseSequenceNumber: Int = 0
    // 시퀀스넘버
    
    var exerciseName: String = ""
    // 운동 이름
    
    var exerciseHow: String = ""
    // 운동을 어떻게 했는지
    
    var exerciseWhen: String = ""
    // 언제 운동했는지
    
    var exerciseJudgment: String = ""
    // 중단했는지 여부
    
    var exerciseComment: String = ""
    // 운동 코멘트 (널값 가능)
    
    
    init(exerciseSequenceNumber:Int, exerciseName:String, exerciseHow:String, exerciseWhen:String, exerciseJudgment:String, exerciseComment:String)
    {
        self.exerciseSequenceNumber = exerciseSequenceNumber
        self.exerciseName = exerciseName
        self.exerciseHow = exerciseHow
        self.exerciseWhen = exerciseWhen
        self.exerciseJudgment = exerciseJudgment
        self.exerciseComment = exerciseComment
    }
    
}
