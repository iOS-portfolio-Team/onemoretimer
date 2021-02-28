//
//  WorkoutLogTableViewController.swift
//  onemoretimer
//
//  Created by dev on 2021/02/23.
//

import UIKit

class WorkoutLogTableViewController: UITableViewController{

  
    @IBOutlet var workOutLogTable: UITableView!
    
    let cellReuseIdentifier = "workoutLogCell"
    var db:DBHelper = DBHelper()
    var workoutLogs:[workoutLog] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        workOutLogTable.delegate = self
        workOutLogTable.dataSource = self
        workoutLogs = db.read()
        workOutLogTable.rowHeight = 100
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutLogs.count
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exerciseSequenceNumber = String(workoutLogs[indexPath.row].exerciseSequenceNumber)
        
            let deleteAlert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
            let cancelAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default, handler: nil)
        
        let yesAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: { [self]ACTION in db.deleteByID(exerciseSequenceNumber: Int(exerciseSequenceNumber)!)
            workoutLogs = db.read()
            workOutLogTable.reloadData()
            
            })

            deleteAlert.addAction(yesAction)
            deleteAlert.addAction(cancelAction)
            present(deleteAlert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = workOutLogTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WorkoutLogTableViewCell
        cell.exerciseSequenceNumber?.text = String(workoutLogs[indexPath.row].exerciseSequenceNumber)
        cell.exerciseName?.text = String(workoutLogs[indexPath.row].exerciseName) + workoutLogs[indexPath.row].exerciseHow
        cell.exerciseJudgment?.text = workoutLogs[indexPath.row].exerciseJudgment
        cell.exerciseComment?.text = workoutLogs[indexPath.row].exerciseComment
        cell.exerciseImage?.image = UIImage(named: String(workoutLogs[indexPath.row].exerciseName)+".png")
        let dateTime = workoutLogs[indexPath.row].exerciseWhen
        let dayEndIdx: String.Index = dateTime.index(dateTime.startIndex, offsetBy: 8)
        let resultDay = String(dateTime[...dayEndIdx])
        let timeStartIdx: String.Index = dateTime.index(dateTime.startIndex,offsetBy: 11)
        let timeEndIdx: String.Index = dateTime.index(dateTime.endIndex,offsetBy: -3)
        let resultTime = String(dateTime[timeStartIdx..<timeEndIdx])
        cell.exerciseWhenDate?.text = resultDay
        cell.exerciseWhenTime?.text = resultTime
        return cell
    }
    // when DB is renewed view will reload
    override func viewWillAppear(_ animated: Bool) {
      
        let db:DBHelper = DBHelper()
        let _:[workoutLog] = []
        
        workOutLogTable.delegate = self
        workOutLogTable.dataSource = self
        
        self.workoutLogs = db.read()
        
        self.workOutLogTable.reloadData()
        
    }



}
