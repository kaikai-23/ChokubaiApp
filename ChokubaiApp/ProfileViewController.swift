////Shopクラス
//struct Shop{
//    let shopImageUrl:String
//    let address:String
//    let introduction:String
//    let shopname: String
//    let personname: String
//    
//    init(dic:[String:Any]){
//        self.shopImageUrl = dic["shopImageUrl"] as? String ?? ""
//        self.address = dic["address"]as? String ?? ""
//        self.introduction = dic["introduction"]as? String ?? ""
//        self.shopname = dic["shopname"] as? String ?? ""
//        self.personname = dic["personname"]as? String ?? ""
//    }
//}


import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var shopImageView: UIImageView!
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var introductionLabel: UILabel!
    var shopImageUrl:String?
    var address:String?
    var introduction:String?
    var shopname: String?
    var personname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let shopNM =
        shopname else {return}
        print("NM:",shopNM)
        guard let personNM = personname else{return}
        guard let addressNM = address else{return}
        guard let introDuction = introduction else{return}
        guard let shopImage = shopImageUrl else {return}
        shopImageView.image = UIImage(url: shopImage)

//       let image:UIImage = UIImage(url: "\(shopImage)")
//        let _:UIImage = UIImage(url: "\(shopImage)")
//
//        }
        
        shopNameLabel.text = "店舗名: " + "\(shopNM)"
        addressLabel.text = "住所: " + "\(addressNM)"
        personNameLabel.text = "店舗管理者" + "\(personNM)"
        introductionLabel.text = introDuction
        //        print("profileVC:",shopImageUrl)
//        print("profileVC:",address)
//        print("profileVC:",introduction)
//        print("profileVC:",shopname)

//        self.present(ShopCreateViewController,animated: true,completion: nil)
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchShopInfoFromFirestore()
    }
    
    private func fetchShopInfoFromFirestore(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
//        //全てのユーザー情報を取ってくる場合は、Firestore.firestore().collection("users").getDocuments...でいける
//       Firestore.firestore().collection("users").document(uid).collection("shop").getDocuments{(snapshots, err)in
//            if let err = err{
//                print("shop情報の取得に失敗しました\(err)")
//                return
//            }
//            snapshots?.documents.forEach({(snapshot)in
//                let dic = snapshot.data()
//                let shopdata = Shop.init(dic: dic)
//                self.shopdatas.append(shopdata)
//                self.shopdatas.forEach{(shopdata)in
//                    print("shopdata.shopname:",shopdata.shopname)
//                }
////                print("data:", data)
//            })
//        }
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
extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
