//
//  SaveNotesOperation.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/7/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

import Foundation
import RealmSwift

class SaveNotesOperation: OperationWhithFinished {
    let notes: [Note]
    
    init(notes: [Note]) {
        self.notes = notes
    }
    
    override func main() {
        
        do {
            let realm = try Realm()
            
            realm.beginWrite()
            for note in notes {
                let noteRLM = NoteRLM(note)
                realm.add(noteRLM, update: .all) // realm.add(noteRLM, update: true)
            }
            try realm.commitWrite()
        } catch {
            let saveError = error as NSError
            print("Unable to Save Changes of Managed Object Context \(saveError)")
        }
        
//        for note in notes {
//            NoteRLM.createInRealm(note)
//        }
        
        self.isFinished = true
    }
    
}

