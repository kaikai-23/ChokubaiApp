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
import PKHUD

//Userモデルの作成(保存するときの値と一致させる必要がある)
struct User{
    let email: String
    let createdAt: Timestamp
    
    init(dic:[String:Any]){
        self.email = dic["email"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
    }
}

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
        print("押されたよ")
    }
    
    @IBAction func tappedToLLoginBtn(_ sender: Any) {
    }
    
    private func handleAuthToFirebase(){        HUD.show(.progress, onView: view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password){(res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました\(err)")
                HUD.hide{(_)in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            
            self.addUserInfoToFirestore(email: email)
        }
        
    }
    private func addUserInfoToFirestore(email:String){
        //ユーザーのidを取得
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let docData = ["email":email,"createdAt": Timestamp()] as [String:Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData){(err) in
            if let err = err{
                print("Firestoreへの保存に失敗しました\(err)")
                HUD.hide{(_)in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("Firestoreへの保存に成功しました")
            
            userRef.getDocument{(snapshot, err)in
                if let err = err{
                    print("ユーザー情報の取得に失敗しました\(err)")
                    HUD.hide{(_)in
                        HUD.flash(.error, delay: 1)
                    }
                    return
                }
                
                
                //Userモデルのやつ
                guard let data = snapshot?.data() else {return}
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
