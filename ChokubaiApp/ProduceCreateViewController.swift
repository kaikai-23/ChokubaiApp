//
//  ProduceCreateViewController.swift
//  Pods
//
//  Created by 寳門海 on 2022/11/19.
//

import UIKit

class ProduceCreateViewController: UIViewController {

    
    @IBOutlet weak var produceNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var produceImageLabel: UILabel!
    @IBOutlet weak var produceTextField: UITextField!
    
    @IBOutlet weak var produceImageBtn: UIButton!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品登録"
        registerBtn.layer.cornerRadius = 15
        produceImageBtn.layer.borderColor = UIColor.systemGray5.cgColor
        produceImageBtn.setTitle("画像を選択してください", for: .normal)
        produceImageBtn.titleLabel?.textAlignment = .center
        produceImageBtn.layer.borderWidth = 1.0
        produceImageBtn.layer.cornerRadius = 5
        
        

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
