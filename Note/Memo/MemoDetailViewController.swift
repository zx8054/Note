//
//  MemoDetailViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/28.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit
import TesseractOCR

class MemoDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,G8TesseractDelegate,UITextViewDelegate{

    var memoID = -1
    var editMode = true
    
    var isOCR = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBAction func addOCR(_ sender: Any) {
        
        isOCR = true
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toolBar.isHidden = true
        NotificationCenter.default.addObserver(self,                                               selector:#selector(keyBoardWillShow(notification:)),
                                               name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.textView.delegate = self
        self.activityIndicator.isHidden = true
        
        if(editMode == true){
            let saveButton = UIBarButtonItem()
            saveButton.title = "保存"
            saveButton.target = self
            saveButton.action = #selector(saveAction(_:))
            self.navigationItem.rightBarButtonItem = saveButton
        }
        else{
            self.textView.isEditable = false
        }
        
        for memo in dataManager.memos{
            if memo.memoID == memoID{
                self.backgroundImage.image = memo.backgounrdImage!
                self.textView.text = memo.content
                self.navigationItem.title = dataManager.convertToChineseDate(myDate: memo.modifiedDate!)
            }
        }
        
        let length = textView.text.count
        numberLabel.text = "\(length) \\ 140"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyBoardWillShow(notification:NSNotification)
    {
        let userInfo  = notification.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        var deltaY = keyBoardBounds.size.height
        print(deltaY)
        
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.heightAnchor.constraint(equalToConstant: 40)
        self.toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.toolBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -deltaY).isActive = true
        self.toolBar.isHidden = false
        
        self.textViewBottomConstraint.constant = 40+deltaY
        
    }
    @objc func keyBoardWillHide(notification:NSNotification){
        self.toolBar.isHidden = true
        
        self.textViewBottomConstraint.constant = 0
    }
    
    @objc func saveAction(_ sender:UIBarButtonItem){
        for memo in dataManager.memos{
            if(memo.memoID == memoID){
                memo.content = textView.text
                memo.modifiedDate = Date()
                coreDataManager.updateData(memoID: memoID, newContent: textView.text!)
                memo.generateHeight(length: (memo.content?.count)!)
                break
            }
            
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if(isOCR){
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            dismiss(animated: true, completion: {
                self.InOCR(image: selectedImage)
            })
        }
        
    }
    
    public func InOCR(image:UIImage){
        if let tesseract = G8Tesseract(language:"chi_sim+eng") {
            
            tesseract.engineMode = .tesseractOnly
            tesseract.delegate = self
            tesseract.image = image.scaleImage(640)?.g8_blackAndWhite()
            tesseract.recognize()
            if let text = tesseract.recognizedText{
                textView.insertText(text)
            }
        }
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.textViewDidChange(self.textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.count > 140){
            let str = textView.text!
            let endIndex = str.index((str.startIndex), offsetBy: 139)
            let substr = str[str.startIndex...endIndex]
            textView.text = String(substr)
                
        }
        let length = textView.text.count
        numberLabel.text = "\(length) \\ 140"
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
