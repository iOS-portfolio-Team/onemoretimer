
import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }
    let dbPath: String = "WorkOutLog.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            return nil
        }
        else
        {
            return db
        }
    }

    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS WorkoutLog(exerciseSequenceNumber INTEGER PRIMARY KEY, exerciseName TEXT, exerciseHow TEXT, exerciseWhen TEXT, exerciseJudgment TEXT, exerciseComment TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
            } else {
            }
        } else {
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(exerciseSequenceNumber:Int, exerciseName:String, exerciseHow:String, exerciseWhen:String, exerciseJudgment:String, exerciseComment: String)
    {

        let insertStatementString = "INSERT INTO WorkoutLog(exerciseSequenceNumber, exerciseName, exerciseHow, exerciseWhen, exerciseJudgment, exerciseComment) VALUES (NULL, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (exerciseName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (exerciseHow as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (exerciseWhen as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (exerciseJudgment as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (exerciseComment as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
            } else {
            }
        } else {
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [workoutLog] {
        let queryStatementString = "SELECT * FROM WorkoutLog"
        var queryStatement: OpaquePointer? = nil
        var prepareStatement : [workoutLog] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let exerciseSequenceNumber = sqlite3_column_int(queryStatement, 0)
                let exerciseName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let exerciseHow = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let exerciseWhen = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let exerciseJudgment = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let exerciseComment = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
              
                prepareStatement.append(workoutLog(exerciseSequenceNumber: Int(exerciseSequenceNumber), exerciseName: exerciseName, exerciseHow: exerciseHow, exerciseWhen: exerciseWhen, exerciseJudgment: exerciseJudgment, exerciseComment: exerciseComment))
            }
        } else {
        }
        sqlite3_finalize(queryStatement)
        return prepareStatement
    }
    
    func deleteByID(exerciseSequenceNumber : Int) {
        let deleteStatementString = "DELETE FROM WorkoutLog WHERE exerciseSequenceNumber = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(exerciseSequenceNumber))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
            } else {
            }
        } else {
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func updateByID(exerciseWhen : String, exerciseComment : String) {
        let updateStatementString = "UPDATE WorkoutLog set exerciseComment = ? WHERE exerciseWhen = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateStatement, 1, (exerciseComment as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (exerciseWhen as NSString).utf8String, -1, nil)

            if sqlite3_step(updateStatement) == SQLITE_DONE {
            } else {
            }
        } else {
        }
        sqlite3_finalize(updateStatement)
    }
}
