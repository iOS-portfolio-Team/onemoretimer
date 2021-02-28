//
//  workoutLog.swift
//  onemoretimer
//
//  Created by dev on 2021/02/23.
//


import Foundation

class workoutLog
{
   
    var exerciseSequenceNumber: Int = 0
    var exerciseName: String = ""
    var exerciseHow: String = ""
    var exerciseWhen: String = ""
    var exerciseJudgment: String = ""
    var exerciseComment: String = ""

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
