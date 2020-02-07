//
//  GetNotesOperation.swift
//  Test_Realm
//
//  Created by Andrey Stecenko on 2/5/20.
//  Copyright © 2020 Andrey Stecenko. All rights reserved.
//

import Foundation

class GetNotesOperation: OperationWhithFinished {
    
    var data: Data?
    var error: Error?

    override func main() {
        print("GetNotesOperation started")
        
        if isCancelled {
            return
        }
    }

}
