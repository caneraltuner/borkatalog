//
//  SendEmailViewController.swift
//  borkatalog
//
//  Created by Caner Altuner on 6.12.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit
import MessageUI

class SendEmailViewController: UIViewController,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    let picker = MFMailComposeViewController()
    var imagePicker = UIImagePickerController()
    var selectedFileName : String = ""
    let randomErrorCode : Int = Int.random(in: 00000..<99999)
    var stringedErrorCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject.delegate = self
        body.delegate = self
        imagePicker.delegate = self
        body.text = "Buraya sorununuzu yazın..."
        body.textColor = UIColor.lightGray
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tap))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        self.hideKeyboardWhenTappedAround()
        stringedErrorCode = "\(randomErrorCode)" //Stringe dönüştürme
        print(stringedErrorCode)
    }
    
    @objc func tap() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        if let imageUrl = info[.imageURL] as? URL {
            selectedFileName = imageUrl.lastPathComponent
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMail(_ sender: Any) {
        //Simulatorde çökmeyi engellemek için guard statement kullandım.
        guard MFMailComposeViewController.canSendMail() else {
           let alert = UIAlertController(title: "Hata", message: "E-posta servisi şu anda aktif değildir daha sonra tekrar deneyiniz.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
            return self.present(alert, animated: true,completion: nil)
        }
        //Default değerler ile e-posta gönderilmemesi için if-else bloğu kullandım
        if subject.text != "" && body.text != "" && body.textColor != UIColor.darkGray {
            picker.mailComposeDelegate = self
            picker.setToRecipients(["bmbihrstaj@borusan.com"])
            if let subjectText = subject.text {
                picker.setSubject(subjectText + " Mesaj No:" + stringedErrorCode)
            }
            picker.setMessageBody(body.text, isHTML: true)
            picker.addAttachmentData(imageView.image!.jpegData(compressionQuality: 1.0)!, mimeType: "image/jpeg", fileName: selectedFileName)
            present(picker,animated: true,completion: nil)
        } else {
            let alert = UIAlertController(title: "Hata", message: "Boş değerlerler ile mesaj gönderemezsiniz", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "backToMain", sender: nil)
            }
        case .cancelled:
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "backToMain", sender: nil)
            }
        case .saved:
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "backToMain", sender: nil)
            }
        case .failed:
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "backToMain", sender: nil)
            }
        @unknown default:
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "backToMain", sender: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        body.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
