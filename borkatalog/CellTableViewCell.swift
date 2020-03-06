//
//  CellTableViewCell.swift
//  borkatalog
//
//  Created by Caner Altuner on 31.10.2019.
//  Copyright © 2019 Caner Altuner. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    //Celldeki resmi manipüle etmek için oluşturduğumuz bu class'a imageView'ı tanımlıyoruz
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
