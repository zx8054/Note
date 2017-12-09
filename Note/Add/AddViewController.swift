//
//  AddViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController{

    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var labelName: UILabel!
    var inChoose = false
    @IBOutlet weak var contentView: UIView!
//    var pickerView = UIPickerView
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
//    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
//        pickerView.isHidden = true
        
        
        
        chooseButton.setBackgroundImage(UIImage(named:"bookblack"), for: UIControlState())
        labelName.text = "<左边按钮选择>"
        blurView.isHidden = true

        //blurView.addSubview(pickerView)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func chooseButtonTouched(_ sender: UIButton) {
        inChoose = !inChoose
        if(inChoose){
            pickerView.isHidden = false
            blurView.isHidden = false
//            textView.isHidden = true
            
            chooseButton.setBackgroundImage(UIImage(named:"bookgreen"), for: UIControlState())

        }
        else{
            pickerView.isHidden = true
            blurView.isHidden = true
            chooseButton.setBackgroundImage(UIImage(named:"bookblack"), for: UIControlState())
        
        }
        
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

extension AddViewController:UIPickerViewDelegate{
    
    
}

extension AddViewController : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataManager.notebooks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataManager.notebooks[row].noteName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.labelName.text = String("<") + dataManager.notebooks[row].noteName! + String(">")
    }
    
    
}


