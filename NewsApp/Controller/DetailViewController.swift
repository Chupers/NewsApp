//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Eugenie Chupris on 9/2/19.
//  Copyright © 2019 Eugenie Chupris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    var New : NewsCard = NewsCard()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageView.layer.cornerRadius = 18
     
            ContentLabel.text = New.decs!
        do{
            ImageView.image = try UIImage(data: Data(contentsOf:URL(string: New.urlToImage  )!))!
        }
        catch{
            print(error)
        }
            TitleLabel.text = New.title!
        
    }
    

 

}
