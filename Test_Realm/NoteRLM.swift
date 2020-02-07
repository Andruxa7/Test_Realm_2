//
//  NoteRLM.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/6/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

import Foundation
import RealmSwift

class NoteRLM: Object {
    dynamic var text = ""
    dynamic var identifier = ""
    dynamic var userID = ""
    dynamic var lastModified = Date()
    
    // В Realm нужно обязательно указать первичный ключ
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    // Создаём дополнительный инициализатор
    convenience init(_ note: Note) {
        self.init()
        
        self.text = note.text
        self.identifier = note.identifier
        self.userID = note.userID
        self.lastModified = note.lastModified
    }
    
    // Функция которая создаёт и сохраняет заметку в Реалме (Realm)
    class func createInRealm(_ note: Note) {
        do {
            let realm = try Realm()
            
            let noteRLM = NoteRLM(note)
            
            // 1й способ делаем синхронно
            realm.beginWrite()
            realm.add(noteRLM, update: .all) // realm.add(noteRLM, update: true)
            try realm.commitWrite()
            
            // 2й способ делаем асинхронно
            /*
            try realm.write {
                // ..... some code
            }
            */
        } catch {
            print("fetch error \(error)")
        }
    }
    
    // Функция которая будет возвращать (доставать) наши заметки из базы данных
    // 1я функция класса для массива заметок
    class func getNotes() -> [Note]? {
        let notes: [Note]?
        
        do {
            let realm = try Realm()
            let results = realm.objects(NoteRLM.self)
            
            var buffer = [Note]()
            
            for noteRLM in results {
                let note = Note(text: noteRLM.text, identifier: noteRLM.identifier, userID: noteRLM.userID)
                
                buffer.append(note)
            }
            
            notes = buffer
        } catch {
            notes = nil
            print("fetch error \(error)")
        }
        return notes
    }
    
    // 2я функция класса которая будет возвращать нам заметку по идентификатору
    class func getNote(by identifier: String) -> NoteRLM? {
        let condition = NSPredicate(format: "identifier == %@", identifier)
        
        let note: NoteRLM?
        
        do {
            let realm = try Realm()
            let results = realm.objects(NoteRLM.self).filter(condition)
            
            note = results.first
        } catch {
            note = nil
            print("fetch error \(error)")
        }
        
        return note
    }
    
}


