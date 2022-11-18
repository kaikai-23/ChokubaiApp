//
//  ShopCreateViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/16.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire
import FirebaseStorage

//MARK: JSONをフラットマップにするためのStruct
struct ZipCloudResponse: Codable {
    let message: String?
    let results : [Address]?
    let status : Int
}

struct Address: Codable {
    let address1: String
    let address2: String
    let address3: String
    let kana1: String
    let kana2: String
    let kana3: String
    let prefcode: String
    let zipcode: String
}

class ShopCreateViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tappedToCreateBtn: UIButton!
    
    @IBOutlet weak var shopNameTextField: UITextField!
    
    @IBOutlet weak var personNameTextField: UITextField!
    
    @IBOutlet weak var shopImageBtn: UIButton!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var introductionTextField: UITextField!
    

    
    @IBOutlet weak var zipcodeSearchBar: UISearchBar!
    

    
    @IBAction func shopImageBtn(_ sender: Any) {
        print("ボタンが押されました")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController,animated: true,completion: nil)
    }
    
    @IBAction func tappedToCreateBtn(_ sender: Any) {
        guard let shopName = shopNameTextField.text else {return}
        guard let personName = personNameTextField.text else {return}
        guard let address = addressTextField.text else {return}
        guard let introduction = introductionTextField.text else {return}
        //画像関連
        guard let shopImage = shopImageBtn.imageView?.image else {return}
        guard let uploadShopImage = shopImage.jpegData(compressionQuality: 0.3) else {return}
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("shop_image").child(fileName)
        storageRef.putData(uploadShopImage, metadata:nil){(metadata,err)in
            if let err = err{
                print("FireStorageへの保存に失敗しました\(err)")
                return
            }
            print("FireStorageへの保存に成功しました")
            
            storageRef.downloadURL{(url, err)in
                if let err = err{
                    print("FireStorageからの保存に失敗しました\(err)")
                    return
                }
                guard let urlString = url?.absoluteString else {return}
                print("urlString:",urlString)
                
            }
           
        }

        guard let uid = Auth.auth().currentUser?.uid else {return}
        let shopData = [
            "shopname":shopName,
            "personname":personName,
            "address":address,
            "shopImageUrl":urlString,
            "introduction":introduction,
        ] as [String:Any]
        
        Firestore.firestore().collection("users").document(uid).collection("shop") .addDocument(data: shopData){
            (err)in
            if let err = err{
               print("Firestoreへの保存に失敗しました\(err)")
                return
            }
            print("Firestoreへの情報の保存が成功しました")
        }
    }
    var results: [Address] = []
    let baseUrlStr = "https://zipcloud.ibsnet.co.jp/api/search"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedToCreateBtn.layer.cornerRadius = 18
        self.title = "店舗情報登録"
        shopImageBtn.layer.borderColor = UIColor.systemGray5.cgColor
        shopImageBtn.layer.borderWidth = 1.0
        shopImageBtn.layer.cornerRadius = 5
        shopNameTextField.delegate = self
        personNameTextField.delegate = self
        addressTextField.delegate = self
        introductionTextField.delegate = self
        zipcodeSearchBar.delegate = self
        tappedToCreateBtn.isEnabled = false
        
        //キーボード閉じる処理
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
        
    
//        //doneボタン
//        let f = UITextField()
//        f.addDoneToolbar()
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    //リクエスト送信用のメソッド
    func requestAddressFromZipCode(zipCode: String) {
        //検索バーに入力された文字(検索する郵便番号)
        let parameters: [String: Any] = ["zipcode": zipCode]
          
        //Alamofireを使ってリクエストを送信
        AF.request(
            baseUrlStr,    //リクエストを送るためのURLの共通部分
            method: .get,  //HTTPメソッドを指定(GETの場合は省略可能)
            parameters: parameters  //リクエストに含ませるパラメータ
        ).responseDecodable(of: ZipCloudResponse.self) { response in
            //返ってきたレスポンス(response)を場合分けして処理
            switch response.result {
            case .success(let value):
                guard let results = value.results else {return} //レスポンスに住所が無いときはreturnで処理を抜ける
                self.results = results
                
                var address = self.results.first!.address1 + self.results.first!.address2 + self.results.first!.address3
                self.addressTextField.text = address
//                var content = results[address].address1
//                + results.address.address2
//                + results.address.address3
                
//                self.addressTableView.reloadData() //tableViewの表示を更新
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
        shopNameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        personNameTextField.resignFirstResponder()
        introductionTextField.resignFirstResponder()
//        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
//        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//               tapGR.cancelsTouchesInView = false
//               self.view.addGestureRecognizer(tapGR)
//
//    }
//
//    @objc func dismissKeyboard(){
//        self.view.endEditing(true)
//    }
//    @objc func showKeyboard(notification:Notification){
//        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//        guard let keyboardMinY = keyboardFrame?.minY else {return}
//        let tappedToCreateBtnMaxY = tappedToCreateBtn.frame.maxY
//        let distance = tappedToCreateBtnMaxY - keyboardMinY + 20
//
//        let transform = CGAffineTransform(translationX: 0, y: -distance)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
//            self.view.transform = transform
//    })
//                       }
                       
                       
//                       @objc func hideKeyboard(notification:Notification){
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
//                self.view.transform = .identity
//    }
//                           }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
                       }

extension ShopCreateViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage]as? UIImage{
            shopImageBtn.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage]as? UIImage{
            shopImageBtn.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        shopImageBtn.setTitle("", for: .normal)
        shopImageBtn.imageView?.contentMode = .scaleAspectFill
        shopImageBtn.contentHorizontalAlignment = .fill
        shopImageBtn.contentVerticalAlignment = .fill
        shopImageBtn.clipsToBounds = true
        
        dismiss(animated: true,completion: nil)
    }
}
extension ShopCreateViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField:UITextField){
        print("textField:", textField.text)
        
        let shopNameIsEmpty = shopNameTextField.text?.isEmpty ?? false
        let personNameIsEmpty = personNameTextField.text?.isEmpty ?? false
        let addressIsEmpty = addressTextField.text?.isEmpty ?? false
        //    let introductionEmpty = introductionTextField.text?.isEmpty ?? false
        if shopNameIsEmpty || personNameIsEmpty || addressIsEmpty{
            tappedToCreateBtn.isEnabled = false
        }else{
            tappedToCreateBtn.isEnabled = true
        }
    }

}
extension ShopCreateViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
             guard let zipcodeSearchText = zipcodeSearchBar.text else { return }
             print(zipcodeSearchText)
        requestAddressFromZipCode(zipCode: zipcodeSearchText) //検索ボタンを押したときにリクエストを送信
          }
}

////キーボードにdoneボタンを実装
//extension UITextField {
//
//    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
//
//
//
//        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
//
//        let toolbar: UIToolbar = UIToolbar()
//
//        toolbar.barStyle = .default
//
//        toolbar.items = [
//
//            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
//
//            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
//
//        ]
//
//        toolbar.sizeToFit()
//
//        toolbar.translatesAutoresizingMaskIntoConstraints = false
//
//        inputAccessoryView = toolbar
//
//    }
//
//    @objc func doneButtonTapped() { self.resignFirstResponder() }
//
//}
