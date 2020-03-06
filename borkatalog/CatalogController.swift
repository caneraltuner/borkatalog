//
//  CatalogController.swift
//  borkatalog
//
//  Created by Caner Altuner on 8.10.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAuth

var myIndex = 0
let data = ["EN 10305-2","EN 10305-3","EN 10305-5"]//Arayacağımız kelimeler ve resimlerin adları
let filedata = ["EN 10305-2","EN 10305-3","EN 10305-5"]//PDF Dosyaların adları


class CatalogController: UIViewController,UITableViewDataSource,UISearchBarDelegate,UITableViewDelegate {
    
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NavigationBar'daki yazı rengini beyaza ayarlıyorum(Normun gösterildiği sayfadaki geri butonunun mavi gözükmesi üzerine böyle bir çözüme başvuruldu).
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        filteredData = data
        //Giriş kısmında extension'a yazdığımız fonksiyonumuz rahatlıkla çağırdık.
        self.hideKeyboardWhenTappedAround()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? CellTableViewCell
        cell?.cellImage.image = UIImage(named: filteredData[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PdfViewController") as? PdfViewController
        vc?.normTitle = filteredData[indexPath.row]
        vc?.normFileName = filedata[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter({ (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        tableView.reloadData()
    }
    
    @IBAction func logOutSecond(_ sender: Any) {
        
        //Seçenekler Penceresi açılacak
        
        let seceneklerPopUp = UIAlertController(title: "Seçenekler", message: "Hangisini yapacaksınız ?", preferredStyle: .alert)
        seceneklerPopUp.addAction(UIAlertAction(title: "Hesaptan Çıkış Yap", style: .default, handler: { (action) in
            //Kullanıcıya çıkış yapmak isteyip istemediğini soruyorum ve bu sorguyu yapacağım UIAlertController adlı elementi oluşturuyorum.
            let uyari = UIAlertController(title: "Çıkış İşlemi", message: "Hesabınızdan çıkış yaparsanız uygulamayı birdahaki açışınızda tekrar giriş yapmak zorunda kalacaksınız.Çıkmak istediğinize emin misiniz ?", preferredStyle: .alert)
            //Oluşturduğum alert'a iki tane buton ekliyorum birisi çıkış işlemini yapacak diğeri bu pencereyi kapatacak.
            //Çıkış işlemini yapacak buton ve kodu.
            uyari.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { (alert) in
                //Çıkış işlemi sırasında hata oluşmaması eğer oluşursa uygulamanın çökmemesi için çıkış yapan kod try-catch bloğu içine yazıyorum.
                do {
                    try Auth.auth().signOut() //Çıkış yapan kod.
                } catch let logouterror {
                    print(logouterror) //Hata olması durumunda hata debug'a bildiriliyor.
                }
                //Giriş sayfasına gitmek için önce storyboard'u tanımlıyorum.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //Ardından kullanıcın giriş yaptığı sayfayı tanımlıyorum.Tabi bunu yukarıda oluşturduğum storyboard üzerinden tanımlıyorum.
                let logInController = storyboard.instantiateViewController(withIdentifier: "newLogIn")
                //En sonunda kullanıcı başarılı bir şekilde hesabından çıkış yapmış bir halde giriş ekranına geliyor.
                self.present(logInController,animated: true,completion: nil)
            }))
            //Pencereyi kapatan buton
            uyari.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))
            //Pencerenin kullanıcıya gösterilmesi
            self.present(uyari,animated: true,completion: nil)
        }))
        seceneklerPopUp.addAction(UIAlertAction(title: "Hata Bildir", style: .destructive, handler: { (action) in
            self.performSegue(withIdentifier: "toEmailService", sender: nil)
        }))
        present(seceneklerPopUp,animated: true) {
            //Kullanıcının buton olmadan pencerenin dışına dokunup onu kapatmasını sağlıyoruz
            seceneklerPopUp.view.superview?.isUserInteractionEnabled = true
        seceneklerPopUp.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

