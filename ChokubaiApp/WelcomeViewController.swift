//
//  WelcomeViewController.swift
//  ChokubaiApp
//
//  Created by 寳門海 on 2022/11/13.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class WelcomeViewController: UIViewController {
    var user:User?{
        didSet{
            print("user:",user?.email)
        }
    }
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var createBtn: UIButton!
    
    @IBAction func tappedToCreateBtn(_ sender: Any) {
    }
    
    @IBAction func tappedLogoutBtn(_ sender: Any) {
        handleLogout()
    }
    private func handleLogout(){
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }catch(let err){
            print("ログアウトに失敗しました\(err)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        createBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        if let user = user{
            emailLabel.text = user.email
            let dateString = dateFormatterForCreatedAt(date: user.createdAt.dateValue())
            dataLabel.text = "作成日:" + dateString
        }
        
    }
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        confirmLoggedUser()
    //    }
    //    private func confirmLoggedUser(){
    //        if Auth.auth().currentUser?.uid == nil || user == nil{
    //            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    //            let signUpViewController = storyBoard.instantiateViewController(identifier:"SignUpVC") as! SignUpViewController
    //            //welcomeViewControllerで定義したuserにletで定義したuserを代入する
    //
    //            signUpViewController.modalPresentationStyle = .fullScreen
    //
    //            self.present(signUpViewController, animated: true, completion: nil)
    //        }
    //    }
    
    private func dateFormatterForCreatedAt(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
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
