//
//  ShopViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/11.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var crops: [String] = [
        "にんじんスペシャル",
        "ピーマン",
        "10円ブドウ",
    
    ]
    
    @IBOutlet weak var cropNameTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cropNameTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return crops.count
    }
    

    /*
    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // 各行のセルを表示する際に呼ばれる処理です。
    // この中で表示内容を設定するプログラムを記述します。
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {

       // セルのオブジェクトを作成します。
       // "NameCell" の部分はStoryboardでセルに設定したIdentifierを指定しています。
       let cell = tableView.dequeueReusableCell(withIdentifier: "CropNameCell", for: indexPath)



       // namesから該当する行の文字列を取得してセルに設定します。
      // indexPath.rowで何行目かがわかります。
       cell.textLabel?.text = crops[indexPath.row]
        return cell
    }
    
    
}
