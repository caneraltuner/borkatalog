//
//  katalogController.swift
//  borkatalog
//
//  Created by Caner Altuner on 8.10.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit
import FirebaseAuth

class katalogController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "giris", sender: nil)
    }
    
}
