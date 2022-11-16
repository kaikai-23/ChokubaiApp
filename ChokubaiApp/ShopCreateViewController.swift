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

class ShopCreateViewController: UIViewController {

    @IBOutlet weak var tappedToCreateBtn: UIButton!
    
    @IBOutlet weak var shopNameTextField: UITextField!
    
    @IBOutlet weak var personNameTextField: UITextField!
    
    @IBOutlet weak var shopImageBtn: UIButton!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var introductionTextField: UITextField!
    
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

        guard let uid = Auth.auth().currentUser?.uid else {return}
        let shopData = [
            "shopname":shopName,
            "personname":personName,
            "address":address,
            "introduction":introduction,
        ] as [String:Any]
        
        Firestore.firestore().collection("user").document(uid).setData(shopData){
            (err)in
            if let err = err{
               print("Firestoreへの保存に失敗しました\(err)")
                return
            }
            print("Firestoreへの情報の保存が成功しました")
        }
    }
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
        tappedToCreateBtn.isEnabled = false
//        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
               tapGR.cancelsTouchesInView = false
               self.view.addGestureRecognizer(tapGR)
        
    }
   
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
//    @objc func showKeyboard(notification:Notification){
//        let key
//    }
//    @objc func hideKeyboard(notification:Notification){
//
//    }
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
