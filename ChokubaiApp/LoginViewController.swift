//
//  LoginViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/14.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var backToSignUpBtn: UIButton!
    
    @IBAction func backToSignUpBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        HUD.show(.progress, onView: self.view)
        print("ログインボタンが押されました")
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password){(res, err)in
            if let err = err{
                print("ログイン情報の取得に失敗しました")
                return
            }
            print("ログインに成功しました")
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let userRef = Firestore.firestore().collection("users").document(uid)
            userRef.getDocument{(snapshot, err)in
                if let err = err{
                    print("ユーザー情報の取得に失敗しました\(err)")
                    HUD.hide{(_)in
                        HUD.flash(.error,delay:1)}
                    return
                }
                guard let data = snapshot?.data() else {return}
                //Userモデルのやつ
                let user = User.init(dic: data)
                print("ユーザー情報の取得ができました\(user.email)")
                HUD.hide{(_)in
                    HUD.flash(.success,
                              onView:self.view ,delay: 1){(_)in
                        self.presentToWelcomeViewController(user: user)
                    }
                }
            }
            
        }
    }
    private func presentToWelcomeViewController(user:User){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyBoard.instantiateViewController(identifier:"WelcomeVC") as! WelcomeViewController
        //welcomeViewControllerで定義したuserにletで定義したuserを代入する
        welcomeViewController.user = user
        welcomeViewController.modalPresentationStyle = .fullScreen
        
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("login")
        loginBtn.layer.cornerRadius = 10
        loginBtn.isEnabled = false
        mailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
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

//UItextFieldDelegateの処理
extension LoginViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEnpty = mailTextField.text?.isEmpty ?? true
        let passwordIsEnpty = passwordTextField.text?.isEmpty ?? true
        if emailIsEnpty || passwordIsEnpty {
            loginBtn.isEnabled = false
            //            loginBtn.backgroundColor = UIColor(red: 234, green: 241, blue: 253, alpha: 1.0)
        }else{
            loginBtn.isEnabled = true
            //            loginBtn.backgroundColor = UIColor(red: 0, green: 150, blue: 255, alpha: 1.0)
        }
        print("textField.text:",textField.text)
    }
}
