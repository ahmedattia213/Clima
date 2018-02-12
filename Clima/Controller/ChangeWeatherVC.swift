//
//  ChangeWeatherVC.swift
//  climaTest
//
//  Created by Ahmed Amr on 2/9/18.
//  Copyright © 2018 Ahmed Amr. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate  {
    func userEnteredCityANewName ( city : String )
}
class ChangeWeatherVC: UIViewController {
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        let cityName = cityTextField.text!
        delegate?.userEnteredCityANewName(city: cityName)
        self.dismiss(animated: true, completion: nil)
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

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
