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
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    var RefreshControl : UIRefreshControl!
     @objc func refresh(){
        NewsDate = Date()
       
        News.removeAll()
      
        DaysDisplay = 0
        IsLoadOne = true
        
        self.fetchNews(dateString: createDateFormat(date: NewsDate))
        
        RefreshControl.endRefreshing()
    }
    var IsLoadOne = true
    var DaysDisplay = 0
    var NewsDate : Date = Date()
    var NewsDataString = ""
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

        if isFiltering(){
            ViewController?.New = filteredNews[indexPath.row]
        }
        else{
        ViewController?.New = News[indexPath.row]
        }
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
    let calendar = Calendar.current
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func createDateFormat(date: Date) -> String {
        print(NewsDate)
        print(IsLoadOne)
        if IsLoadOne{
            let Day = calendar.component(.day, from: NewsDate)
            let Month = calendar.component(.month, from: NewsDate)
            let Year = calendar.component(.year, from: NewsDate)
            return "\(Year)-\(Month)-\(Day)"
        }
        else{
            let PreviosDay  = Calendar.current.date(byAdding: .day, value: DaysDisplay, to: Date())
            let Day = calendar.component(.day, from: PreviosDay!)
            let Month = calendar.component(.month, from: PreviosDay!)
            let Year = calendar.component(.year, from: PreviosDay!)
            NewsDate = PreviosDay!
             return "\(Year)-\(Month)-\(Day)"
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem =  News.count - 1
        if indexPath.row == lastItem {
            loadMore()
        }
    }
    var loadMoreStatus = false
    func loadMore()
    {   print(DaysDisplay)
        print(loadMoreStatus)
        if !loadMoreStatus && DaysDisplay <= 7 {
            self.loadMoreStatus = true
            self.fetchNews(dateString: createDateFormat(date: NewsDate))
            self.loadMoreStatus = false
            
        }
    }
    
    
    
    func fetchNews(dateString:String) {
        self.NewsDataString = dateString
        if !IsLoadOne{
            IsLoadOne = true
        }
        let urlRequest = URLRequest(url: URL(string:"https://newsapi.org/v2/everything?q=from=\(dateString)&to=\(dateString)&apiKey=\(ApiKey)")!)
       print(dateString)
         URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error != nil{
                print(error)
                return
            }
           
            do{
                
                let JSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articlesJSON = JSON["articles"] as? [[String:AnyObject]]{
                    for articleJSON in articlesJSON{
                        
                        let NewsToData : NewsCard = NewsCard()
                        if let title = articleJSON["title"] as? String, let author = articleJSON["author"] as? String,let desc = articleJSON["description"] as? String, let url = articleJSON["url"] as? String, let imageToUrl = articleJSON["urlToImage"] as? String,let content = articleJSON["content"] as? String, let publishedAt = articleJSON["publishedAt"] as? String{
                           
                            NewsToData.author = author
                            NewsToData.title = title
                            NewsToData.content = content
                            NewsToData.decs = desc
                            NewsToData.publishedAt = publishedAt
                            NewsToData.url = url
                            NewsToData.urlToImage = imageToUrl
                        }
                        if NewsToData.decs != nil{
                        self.News.append(NewsToData)
                        }
                        
                    }
                    self.DaysDisplay-=1
                    self.IsLoadOne = false
                }
            }catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RefreshControl = UIRefreshControl()
        RefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        RefreshControl.addTarget(self, action: #selector(ViewController.refresh), for: .valueChanged)
        CollectionView.addSubview(RefreshControl)
     
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        definesPresentationContext = true
       
       fetchNews(dateString: createDateFormat(date: NewsDate))
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredNews.count
        }
        return News.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let queue = DispatchQueue.global(qos: .utility)
        
            
        
            let cell = self.CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        var New = self.News[indexPath.item]
        
        if self.isFiltering(){
            New = self.filteredNews[indexPath.row]
        }
        else {
            New = self.News[indexPath.row]
        }
        queue.async {
            
            let queue2 = DispatchQueue.main
            queue2.async{
                cell.DateLabel.text = self.NewsDataString
        cell.NewsTitle.text = New.title
        cell.DescLabel.text = New.decs
        if cell.DescLabel.text != nil && cell.DescLabel.text!.count > 0
        {
            cell.ShowMoreButton.isHidden = false
            cell.ShowMoreButton.isEnabled = true
        }
        do {
            cell.NewsImage.image = try UIImage(data: Data(contentsOf:URL(string: New.urlToImage  ) ?? URL(string: self.placeHolderInstanseImage )! ))!
        } catch{
            print(error)
        }
            }
        }
        return cell
    }
    func countLabelLine(label:UILabel) -> Int {
        let MyText = label.text as? NSString
        let Rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = MyText?.boundingRect(with: Rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : label.font!], context: nil)
        return Int(ceil(CGFloat(labelSize?.height ?? 1)/label.font.lineHeight))
    }
    
    
    let placeHolderInstanseImage = "https://sun9-3.userapi.com/c851136/v851136266/1a5d71/93ch0jDlauA.jpg"
    let ApiKey = "1e5a72d0fdc146f7a9b9727884df13ed"
    }

extension ViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchhText(searchController.searchBar.text!)
        
    }
}




    



