//
//  PdfViewController.swift
//  borkatalog
//
//  Created by Caner Altuner on 10.10.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit
import PDFKit


class PdfViewController: UIViewController,PDFDocumentDelegate,UISearchBarDelegate {
    
    var normTitle: String = ""
    var normFileName: String = ""
    @IBOutlet weak var pdfSearch: UISearchBar!
    @IBOutlet weak var secondView: UIView!
    var searchedItem: PDFSelection?
    var document: PDFDocument!
    var pdfView: PDFView!
    var currentPage = 0
    var page: PDFPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sayfanın başlığını tıklanan norma göre alıyoruz.
        self.title = normTitle
        //PDFView elementimizi subview olarak ana view'ımıza ekliyoruz.
        pdfView = PDFView(frame: self.view.bounds) //webView'ı ana view'a oturtuyoruz.Ölçü olarak main view kullanıldı ki farklı ekranlarda uyumluluk sıkıntısı olmasın
        self.secondView.addSubview(pdfView) //pdfview'ı second view'a ekliyoruz
        //İçeriğimizi PDFView'a göre ayarlıyoruz.
        pdfView.autoScales = true
        //Tıkladığımız cell'e göre otomatik olarak yüklüyor.Bu sayede kod fazlalığından kurtuluyoruz.
        let fileURL = Bundle.main.url(forResource: normFileName, withExtension: "pdf")
        document = PDFDocument(url: fileURL!)
        pdfView.document = document
        pdfView.document?.delegate = self
        pdfSearch.delegate = self
        pdfView.displayDirection = .vertical
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        removeAllAnnotations()
        return highlight(searchTerms: [searchText])
    }
    
    public func highlight(searchTerms: [String]?)
    {
        var highlight = PDFAnnotation()
       searchTerms?.forEach { term in
        let selections = pdfView?.document?.findString(term, withOptions: [.caseInsensitive])
          selections?.forEach { selection in
             selection.pages.forEach { page in
                highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
                highlight.endLineStyle = .square
                highlight.color = UIColor.yellow.withAlphaComponent(0.5)
                page.addAnnotation(highlight)
             }
          }
       }
    }
    
    @IBAction func moveToNextAnnotation(_ sender: Any) {
        if pdfSearch.text!.isEmpty {
            let uyari = UIAlertController(title: "Hata", message: "Boş bir şekilde arama yapamazsınız", preferredStyle: .alert)
            uyari.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
            self.present(uyari,animated: true,completion: nil)
        } else {
            let validPageIndex: Int = currentPage + 1
            guard let targetPage = pdfView.document?.page(at: validPageIndex) else { return }
            print(targetPage.index)
            currentPage = currentPage + 1
            pdfView.go(to: targetPage)
        }
    }
    
    func removeAllAnnotations() {
        guard let document = pdfView.document else { return }
        for index in 0..<document.pageCount {
            if let page = document.page(at: index) {
                let annotations = page.annotations
                for annotation in annotations {
                    page.removeAnnotation(annotation)
                }
            }
        }
    }
    
}
