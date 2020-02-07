//
//  ModifyNoteOperation.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/5/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

import Foundation

class ModifyNoteOperation: OperationWhithFinished {
    
    var error: Error?
    
    let modification: NoteModificationTask
    let note: Note!

    init(note: Note, task: NoteModificationTask) {
        self.note = note
        self.modification = task
    }

    override func main() {
        
        print("ModifyNoteOperation started")
        
        if isCancelled {
            return
        }
    }

}
