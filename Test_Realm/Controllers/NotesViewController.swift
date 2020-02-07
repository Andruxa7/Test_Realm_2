//
//  NotesViewController.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/5/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var noNotesLabel: UILabel!
    
    
    // MARK: - Properties

    var notes = [Note]()
    var loggedIn = false
    
    let dataController = DataController()


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // подписываемся на делегата
        dataController.delegate = self
        
        //dataController.getNotes()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditNoteSegue", sender: nil)
    }
    
    
    // MARK: - Add Functions

    func deleteNoteAt(index: Int) {
        notes.remove(at: index)
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddNoteViewController {
            if segue.identifier == "EditNoteSegue" {
                addVC.dataController = self.dataController

                if let index = sender as? Int {
                    addVC.note = notes[index]
                }
                
            }
        }
    }

}


// MARK: - Extensions

extension NotesViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let notesCount = notes.count

        if notesCount > 0 {
            noNotesLabel.isHidden = true
        } else {
            noNotesLabel.isHidden = false
        }

        return notesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell")! as UITableViewCell

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text

        return cell
    }

}

extension NotesViewController: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataController.modify(note: notes[indexPath.row], task: .delete)

            //deleteNoteAt(index: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditNoteSegue", sender: indexPath.row)
    }

    // сделаем так что после появления ячейки внизу не будет лишних видимых ячеек (сетки). Добавим два метода Футера.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}

extension NotesViewController: DataControllerDelegate {

    // MARK: - DataControllerDelegate

    func dataSourseChanged(dataSourse: [Note]?, error: Error?) {
        
        if let notes = dataSourse {
            self.notes = notes.sorted(by: {$0.lastModified > $1.lastModified})
            
            // перезагрузку таблицы нужно обязательно вызывать из главного потока
            DispatchQueue.main.async {
                self.notesTable.reloadData()
            }
        }
    }

}
