//
//  Note.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/5/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

import Foundation

public struct Note {

    public let text: String
    public var identifier: String
    public let userID: String
    public let lastModified: Date

    public init(text: String, identifier: String, userID: String) {
        self.text = text
        self.identifier = identifier
        self.userID = userID
        self.lastModified = Date()
    }
    
    static func == (left: Note, right: Note) -> Bool {
        return left.identifier == right.identifier
    }
    
}

public struct Notes {
    
    let notes: [Note]

    public init(notes: [Note]) {
        self.notes = notes
    }
    
}

