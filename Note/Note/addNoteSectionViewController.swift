//
//  addNoteSectionViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/4.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class addNoteSectionViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBAction func addImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func keyboardArrow(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    var textViewBeginEditing = false
    //var textFieldBeginEditing = false
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    
    @IBAction func savaAction(_ sender: UIBarButtonItem) {
        if(textField.text?.isEmpty == true){
            let alertController = UIAlertController(title: "警告", message: "标题为空", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
        
        var section = NoteSection(newTitle: textField.text!, newContent: textView.text, newTime: Date(), newAttributedContent: NSMutableAttributedString(attributedString:textView.attributedText))
        
        dataManager.notebooks[dataManager.currentIndex].notes.append(section!)
        let attributedString = textView.attributedText
        
        var getFirstImage:Bool = false
        let range = NSMakeRange(0, (attributedString?.length)!)
        attributedString?.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
            
            if object.keys.contains(NSAttributedStringKey.attachment) {
                if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                    if let image = attachment.image {
                        if(!getFirstImage){
        
                            let index = dataManager.notebooks[dataManager.currentIndex].notes.count - 1
                dataManager.notebooks[dataManager.currentIndex].notes[index].representImage = image
                            getFirstImage = true
                        }
                        
                    }
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let originalAttributedString = textView.attributedText
        let attributedString = NSMutableAttributedString(attributedString: originalAttributedString!)
        let textAttachment = NSTextAttachment()
        
        textAttachment.bounds = CGRect.init(x:0,y:1,width:textView.bounds.width-10,height:200)
        textAttachment.image = selectedImage
        
        var attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
        textView.textStorage.insert(attrStringWithImage, at: textView.selectedRange.location)
        //tempContent =  NSMutableAttributedString(attributedString: textView.attributedText)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "输入" 
        textView.textColor = UIColor.lightGray
        toolBar.isHidden = true
        self.textView.delegate = self
        self.textField.delegate = self
        
        NotificationCenter.default.addObserver(self,                                               selector:#selector(keyBoardWillShow(notification:)),
                                               name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func keyBoardWillShow(notification:NSNotification)
    {
        let userInfo  = notification.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        var deltaY = keyBoardBounds.size.height
        
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.heightAnchor.constraint(equalToConstant: 40)
        self.toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.toolBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -deltaY).isActive = true
        
        if(self.textViewBeginEditing == true){
            //print("first")
            self.toolBar.isHidden = false
        }

        self.textViewBottomConstraint.constant = 40+deltaY
        
    }
    @objc func keyBoardWillHide(notification:NSNotification){
        self.toolBar.isHidden = true
        self.textViewBottomConstraint.constant = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewBeginEditing = true
        self.toolBar.isHidden = false
        if textView.textColor == UIColor.lightGray{
            textView.attributedText = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewBeginEditing = false
        print("endEditing")
        if(textView.attributedText == nil)
        {
            textView.attributedText = NSAttributedString(string: "输入")
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.toolBar.isHidden = true
        
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
