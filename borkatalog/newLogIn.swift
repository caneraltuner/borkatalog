//
//  newLogIn.swift
//  borkatalog
//
//  Created by Caner Altuner on 20.10.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyJSON

class newLogIn: UIViewController {

    @IBOutlet weak var eposta: UITextField!
    @IBOutlet weak var sifre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sifre.isSecureTextEntry = true
        //Extension'a yazdığımız klavyeyi indirme metodunu çağırıyoruz
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Kullanıcının internete bağlı olup olmadığını denetliyoruz bağlı değil ise kullanıcıya interneti açmasını söylüyoruz.Ardından kullanıcıyı uyarıyoruz.
        
        if CheckInternet.Connection() {
            //Kullanıcımız daha öncesinde giriş yapmış mı diye kontrol ediyoruz.Yapmış ise bir Timer başlatıp bu süre içerisinde bunu kontrol edip kontrol tamamlandıktan sonra kullanıcıyı uygulamaya alıyoruz.
            if Auth.auth().currentUser != nil {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    self.performSegue(withIdentifier: "goToCatalog", sender: nil)
                }
            }
        } else {
            //Kullanıcının internete bağlı olmadığına dair uyarı penceremiz.
            let uyari = UIAlertController(title: "Bağlantı Sorunu", message: "Lütfen cihazınızı bir kablosuz ağa bağlayın yada cihazınızın mobil verisini açıp ardından 'Tamam' butonuna basın.Eğer daha önceden uygulamaya giriş yaptıysanız İNTERNETİNİZ OLMASA BİLE otomatik olarak ana sayfaya yönlendirileceksiniz", preferredStyle: .alert)
            uyari.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (action) in
                //Ardından kullanıcıya uyarı penceresi gözükürken interneti açma imkanı sunuyoruz.Kullanıcı interneti açtıktan sonra tamam butonuna tıklayınca ana sayfaya yönlendirilecek.
                if Auth.auth().currentUser != nil {
                    //Burası yukarıya göre daha hızlı çalışacak
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                        self.performSegue(withIdentifier: "goToCatalog", sender: nil)
                    }
                } else {
                    print("Kullanıcı daha önceden giriş yapmamış")
                }
            }))
            self.present(uyari,animated: true,completion: nil)
        }
        
    }
    
    @IBAction func girisKismi(_ sender: Any) {
        if !CheckInternet.Connection() { //Kullanıcının internetinin olup olmadığını kontrol ediyoruz.Yoksa kullanıcıya bir uyarı gönderiyoruz.
            let internetUyarisi = UIAlertController(title: "Bağlantı Sorunu", message: "İnternet bağlantınızda bir sıkıntı var ya da bağlantınız yok.Lütfen internete bağlanıp öyle giriş yapmayı deneyin.", preferredStyle: UIAlertController.Style.alert)
            internetUyarisi.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
            self.present(internetUyarisi,animated: true,completion: nil)
        } else {
            if eposta.text != "" && sifre.text != "" {
                Auth.auth().signIn(withEmail: eposta.text!, password: sifre.text!) { (result, error) in
                    if error != nil {
                        let uyari = UIAlertController(title: "Hata", message: "Kullanıcı adınız veya şifreniz yanlış ya da hesabınız sistemde kayıtlı değil.", preferredStyle: .alert)
                        uyari.addAction(UIAlertAction(title: "Tamam", style: .destructive, handler: nil))
                        self.present(uyari,animated: true,completion: nil)
                    } else {
                        let uyari = UIAlertController(title: "Giriş İşlemi", message: "Sisteme başarılı bir şekilde giriş yaptınız.Hoşgeldiniz.", preferredStyle: .alert)
                        uyari.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: { (action) in
                            self.performSegue(withIdentifier: "goToCatalog", sender: nil)
                        }))
                        self.present(uyari,animated: true,completion: nil)
                    }
                }
            } else {
                let uyari = UIAlertController(title: "Hata", message: "Lütfen kutucukları boş bırakmayınız", preferredStyle: .alert)
                uyari.addAction(UIAlertAction(title: "Tamam", style: .destructive, handler: nil))
                self.present(uyari,animated: true,completion: nil)
            }
        }
    }
}
extension UIViewController {
    //Extension'da tüm UIViewController classlarını kapsayacak şekilde yazdığımız için bu fonksiyonu başka bir viewda da rahatlıkla çağırabiliriz (örnek normların listelendiği viewda olduğu gibi)
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
