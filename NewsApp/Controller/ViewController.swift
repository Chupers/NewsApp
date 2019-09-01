//
//  ViewController.swift
//  NewsApp
//
//  Created by Eugenie Chupris on 8/30/19.
//  Copyright © 2019 Eugenie Chupris. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    var News = [NewsCard]()
    {
        didSet {
            DispatchQueue.main.async {
                self.CollectionView.reloadData()
                
              
            }
        }
        
    }
    
    func fetchNews() {
        let urlRequest = URLRequest(url: URL(string:"https://newsapi.org/v2/everything?q=apple&from=2019-08-21&to=2019-08-29&sortBy=popularity&apiKey=\(ApiKey)")!)
       print("Sestion")
         URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error != nil{
                print(error)
                return
            }
            else{
                print("NEERROR")
            }
            do{
                print("DO")
                let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articlesJSON = JSON["articles"] as? [[String:AnyObject]]{
                    for articleJSON in articlesJSON{
                        
                        let NewsToData : NewsCard = NewsCard()
                        if let title = articleJSON["title"] as? String, let author = articleJSON["author"] as? String,let desc = articleJSON["description"] as? String, let url = articleJSON["url"] as? String, let imageToUrl = articleJSON["urlToImage"] as? String,let content = articleJSON["content"] as? String, let publishedAt = articleJSON["publishedAt"] as? String{
                            print(title)
                            NewsToData.author = author
                            NewsToData.title = title
                            NewsToData.content = content
                            NewsToData.decs = desc
                            NewsToData.publishedAt = publishedAt
                            NewsToData.url = url
                            NewsToData.urlToImage = imageToUrl
                        }
                        else{
                            print("LOX")
                        }
                        self.News.append(NewsToData)
                    }
                }
            }catch let error {
                print(error)
            }
            
        }.resume()
         CollectionView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HI")
       
        fetchNews()
        CollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return News.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let New = News[indexPath.item]
        cell.NewsTitle.text = New.title
        do {
            cell.NewsImage.image = try UIImage(data: Data(contentsOf:URL(string: New.urlToImage)!))!
        } catch{
            print(error)
        }
        return cell
    }
    
    
    
    let ApiKey = "1e5a72d0fdc146f7a9b9727884df13ed"
    }



    



