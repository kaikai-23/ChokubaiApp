//
//  SignUpViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
        print("押されたよ")
    }
    private func handleAuthToFirebase(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        //Authが緑にならない問題、認証情報の保存に失敗しましたと表示される問題
        Auth.auth().createUser(withEmail: email, password: password){(res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました\(err)")
            }
            print("認証情報の保存に成功しました")
            
            //ユーザーのidを取得
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let docData = ["email":email,"createdAt": Timestamp()] as [String:Any]
            Firestore.firestore().collection("users").document(uid).setData(docData){(err)in
                if let err = err{
                    print("Firestoreへの保存に失敗しました\(err)")
                    return
                }
                print("Firestoreへの保存に成功しました")
            }
        }
    
    }
    private func addUserInfoToFirestore(email:String){
        //ユーザーのidを取得
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let docData = ["email":email,"createdAt": Timestamp()] as [String:Any]
        Firestore.firestore().collection("users").document(uid).setData(docData){(err)in
            if let err = err{
                print("Firestoreへの保存に失敗しました\(err)")
                return
            }
            print("Firestoreへの保存に成功しました")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.isEnabled = false
        registerBtn.layer.cornerRadius = 10
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func showKeyboard(notification: Notification){
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerButtonMaxY = registerBtn.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })

    }
    @objc func hideKeyboard(){
      
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
extension SignUpViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEnpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEnpty = passwordTextField.text?.isEmpty ?? true
        if emailIsEnpty || passwordIsEnpty {
            registerBtn.isEnabled = false
//            registerBtn.backgroundColor = UIColor(red: 234, green: 241, blue: 253, alpha: 1.0)
        }else{
            registerBtn.isEnabled = true
//            registerBtn.backgroundColor = UIColor(red: 0, green: 150, blue: 255, alpha: 1.0)
        }
    print("textField.text:",textField.text)
    }
}
