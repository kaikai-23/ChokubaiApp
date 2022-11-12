//
//  SearchViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/12.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var popularCropCollectionView: UICollectionView!
    
    
    let items = ["野菜１","野菜2","野菜3","野菜4","野菜5","野菜6"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
//    var terms: [String] = [
//        "現在地から探す",
//        "新着野菜から探す",
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularCropCollectionView.dataSource = self
//        termsNameTableView.dataSource = self
        // Do any additional setup after loading the view.
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


    let cell = tableView.dequeueReusableCell(withIdentifier: "Term1NameCell", for: indexPath)
//    let cell2 = tableView.dequeueReusableCell(withIdentifier: "Term2NameCell", for: indexPath)
//        cell.textLabel?.text = terms[indexPath.row]
         return cell
    }
    

//MARK: UICollectionViewDelegate
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCropCell", for: indexPath) as! PopularCropCollectionViewCell
        
        cell.itemLabel.text = items[indexPath.row]
        
        return cell
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

