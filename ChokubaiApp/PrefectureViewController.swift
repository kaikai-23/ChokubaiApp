//
//  PrefectureViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/20.
//

import UIKit

let prefecture:[String] = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]

class PrefectureViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var prefectureTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prefectureTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prefecture.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->   UITableViewCell {

      // セルのオブジェクトを作成します。
      // "NameCell" の部分はStoryboardでセルに設定したIdentifierを指定しています。
      let cell = tableView.dequeueReusableCell(withIdentifier: "PrefectureNameCell", for: indexPath)



      // namesから該当する行の文字列を取得してセルに設定します。
     // indexPath.rowで何行目かがわかります。
      cell.textLabel?.text = prefecture[indexPath.row]
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
