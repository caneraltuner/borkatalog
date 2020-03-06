//
//  ViewController.swift
//  borkatalog
//
//  Created by Caner Altuner on 7.10.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logInAction(_ sender: Any) {
        /*
        if emailfield.text != "" || passwordfield.text != "" {
            Auth.auth().signIn(withEmail: emailfield.text!, password: passwordfield.text!) { (userdata, error) in
                if error != nil {
                    let uyari = UIAlertController(title: "Hata", message: "Lütfen kullanıcı adınızı ve şifrenizi doğru giriniz", preferredStyle: UIAlertController.Style.alert)
                    let buton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
                    uyari.addAction(buton)
                } else {
                    
                }
            }
        } else {
            // Eğer bu emailtext veya passwordtext boşsa kullanıcımıza uyarı gösteriyoruz
            let uyari = UIAlertController(title: "Hata", message: "Lütfen boş kutucuk bırakmayın", preferredStyle: UIAlertController.Style.alert)
            let buton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
            uyari.addAction(buton)
        }
    */
    }
}

