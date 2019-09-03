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
    let searchController = UISearchController(searchResultsController: nil)
    
    var News = [NewsCard]()
    {
        didSet {
            DispatchQueue.main.async {
                self.CollectionView.reloadData()
            }
        }
    }
    var filteredNews = [NewsCard]()
    {
        didSet {
            DispatchQueue.main.async {
                self.CollectionView.reloadData()
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        print(indexPath.count)
        
        ViewController?.New = News[indexPath.row]
         self.navigationController?.pushViewController(ViewController!, animated: true)
    }
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSearchhText(_ searchText: String){
        filteredNews = News.filter({(SortedNews : NewsCard)-> Bool in
            return SortedNews.title?.lowercased().contains(searchText.lowercased()) ?? " ".contains(searchText.lowercased() )
        })
        
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    
    
    func fetchNews() {
        let urlRequest = URLRequest(url: URL(string:"https://newsapi.org/v2/everything?q=from=2019-08-29&to=2019-08-29&sortBy=popularity&apiKey=\(ApiKey)")!)
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
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        definesPresentationContext = true
       
        fetchNews()
        CollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredNews.count
        }
        return News.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        var New = News[indexPath.item]
        
        if isFiltering(){
            New = filteredNews[indexPath.row]
        }
        else {
            New = News[indexPath.row]
        }
        cell.NewsTitle.text = New.title
        cell.DescLabel.text = New.decs
        do {
            cell.NewsImage.image = try UIImage(data: Data(contentsOf:URL(string: New.urlToImage  ) ?? URL(string: placeHolderInstanseImage )! ))!
        } catch{
            print(error)
        }
        return cell
    }
    
    
    let placeHolderInstanseImage = "https://sun9-3.userapi.com/c851136/v851136266/1a5d71/93ch0jDlauA.jpg"
    let ApiKey = "1e5a72d0fdc146f7a9b9727884df13ed"
    }

extension ViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchhText(searchController.searchBar.text!)
        
    }
}




    



