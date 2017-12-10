//
//  AddViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController{

    var selectNumber = -1
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelName: UILabel!
    var inChoose = false
    @IBOutlet weak var contentView: UIView!
//    var pickerView = UIPickerView
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
//    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if(selectNumber == -1){
            var memo = Memo(newContent: self.textView.text, newImage: UIImage(named:"whitePaper")!, newDate: Date())
            dataManager.memos.append(memo)
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
//        pickerView.isHidden = true
        
        
        
        chooseButton.setBackgroundImage(UIImage(named:"bookblack"), for: UIControlState())
        labelName.text = "<左边按钮选择(默认便笺)>"
        blurView.isHidden = true

        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        return dataManager.notebooks.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row > 0){
            return dataManager.notebooks[row-1].noteName
        }
        else {
            return "便笺"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row > 0){
        self.labelName.text = String("<") + dataManager.notebooks[row-1].noteName! + String(">")
            selectNumber = row-1
        }
        else{
            selectNumber = -1
            self.labelName.text = String("<便笺>")
        }
    }
    
    
}


