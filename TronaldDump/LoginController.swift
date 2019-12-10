//
//  LoginController.swift
//  TronaldDump
//
//  Created by SUP'Internet 05 on 25/11/2019.
//  Copyright © 2019 Louis Loiseau-Billon. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


class LoginController: UIViewController, UITextFieldDelegate {
    
    let LoginTitle = UILabel()
    let EmailTitle = UITextField()
    let PasswordTitle = UITextField()
    
    @objc func login() {
        let api = ApiManager()
        api.login(email: EmailTitle.text!, password: PasswordTitle.text!, completion: { data in
            let results = data as! [String: Any]
            let statusCode = results["status"] as! Int
            
            if (statusCode == 403) {
                print("Forbidden")
                UserDefaults.standard.removeObject(forKey: "token")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error, forbidden", message: "Invalid credentials.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            } else if (statusCode == 200) {
                let resultsData = results["data"] as! [String: Any]
                let token = resultsData["token"] as! String
                UserDefaults.standard.set(token, forKey: "token")
                print("Authorized")
                DispatchQueue.main.async {
                 self.performSegue(withIdentifier: "login_success", sender: self)
                }
            }
    
        })
    }
    
    
    override func viewDidLoad() {
        
        LoginTitle.text = "Login"
        LoginTitle.font = UIFont.boldSystemFont(ofSize: 35)
        
        EmailTitle.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        EmailTitle.setLeftPaddingPoints(10)
        EmailTitle.layer.cornerRadius = 5
        EmailTitle.layer.borderWidth = 1.0
        EmailTitle.tag = 0
        EmailTitle.delegate = self
        EmailTitle.returnKeyType = UIReturnKeyType.next
        EmailTitle.keyboardType = UIKeyboardType.emailAddress
        EmailTitle.placeholder = "Email"
        EmailTitle.autocapitalizationType = .none
        
        PasswordTitle.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        PasswordTitle.setLeftPaddingPoints(10)
        PasswordTitle.layer.cornerRadius = 5
        PasswordTitle.isSecureTextEntry = true
        PasswordTitle.tag = 1
        PasswordTitle.layer.borderWidth = 1.0
        PasswordTitle.delegate = self
        PasswordTitle.returnKeyType = UIReturnKeyType.next
        PasswordTitle.placeholder = "Mot de passe"
        PasswordTitle.autocapitalizationType = .none
        
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 5
        btn.setTitle("Se connecter", for: .normal)
        
        self.view.grid(child: LoginTitle, x: 4.7, y: 0.5, width: 12, height: 1)
        self.view.grid(child: EmailTitle, x: 3, y: 4, width: 6, height: 0.7)
        self.view.grid(child: PasswordTitle, x: 3, y: 5, width: 6, height: 0.7)
        self.view.grid(child: btn, x: 3, y: 9, width: 6, height: 0.7)

        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
       
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
