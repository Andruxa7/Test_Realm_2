//
//  DataController.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/5/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

protocol DataControllerDelegate {
    func dataSourseChanged(dataSourse: [Note]?, error: Error?)
}

enum NoteModificationTask {
    case create
    case edit
    case delete
}

import Foundation
import  RealmSwift

class DataController {
    
    // var notes: [Note]?
    var notes: [Note] = []
    var delegate: DataControllerDelegate?
    
    // создаем и инициализируем очередь для операций
    var modifyNotesQueue = OperationQueue()
    
    
    func getNotes() {
        // загрузка заметок из памяти телефона будет происходить синхронно (почти мгновенно!), ещё до того как мы обратимся к сети
//        self.notes = notes.sorted(by: {$0.lastModified < $1.lastModified})
//        self.delegate?.dataSourseChanged(dataSourse: self.notes, error: nil)
        
        if let notes = NoteRLM.getNotes() {
            self.notes = notes.sorted(by: {$0.lastModified < $1.lastModified})
            self.delegate?.dataSourseChanged(dataSourse: self.notes, error: nil)
        }
    }
    
    func modify(note: Note, task: NoteModificationTask) {
        var noteToAdd = note
        
        switch task {
        case .create:
            noteToAdd.identifier = UUID().uuidString
            NoteRLM.createInRealm(noteToAdd)
            //notes.append(noteToAdd)
            notes.insert(noteToAdd, at: 0)
            break
        case .edit:
            // тут мы говорим что верни нам индекс который равен заметке "note"
            if let index = notes.firstIndex(where: {$0 == note}) {
                notes[index] = note
            }
            
            // для изменения заметки в Realm используем сущность NoteRLM и её метод getNote(by: identifier) и ищем заметку в контексте по идентификатору
            if let noteRLM = NoteRLM.getNote(by: note.identifier) {
                // записываем текст заметки в базу данных (Realm)
                noteRLM.text = note.text
                
                // теперь нужно обязательно сохранить наши изменения
                do {
                    let realm = try Realm()
                    
                    // добавление делаем синхронно
                    realm.beginWrite()
                    realm.add(noteRLM, update: .all) // realm.add(noteRLM, update: true)
                    try realm.commitWrite()
                } catch {
                    //
                }
            }
            break
        case .delete:
            // тут мы говорим что нужно удалить заметку по индексу который равен заметке "note"
            if let index = notes.firstIndex(where: {$0 == note}) {
                notes.remove(at: index)
            }
            
            // для удаления заметки из Realm используем сущность NoteRLM и её метод getNote(by: identifier) и ищем заметку в контексте по идентификатору
            if let noteRLM = NoteRLM.getNote(by: note.identifier) {
                // удаляем заметку из базы данных (Realm)
                do {
                    let realm = try Realm()
                    
                    // удаление делаем синхронно
                    realm.beginWrite()
                    realm.delete(noteRLM)
                    try realm.commitWrite()
                } catch {
                    //
                }
            }
            break
        }
        
        // теперь нам нужно оповестить об обновлении значений нашего подписчика (делегата)
        self.delegate?.dataSourseChanged(dataSourse: self.notes, error: nil)
        
        // создаем операцию, например под названием "modification"
        let modification = ModifyNoteOperation(note: noteToAdd, task: task)
        
        // в нашу очередь добавляем операцию "modification" и заметка будет (добавляться, изменяться или удаляться)!!!!!
        modifyNotesQueue.addOperation(modification)
    }
    
}
