//
//  AddViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit
import TesseractOCR

/*快速添加界面*,采用pickerView 和 blurView实现*/
class AddViewController: UIViewController,UITextViewDelegate,G8TesseractDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var isOCR = false
    var selectNumber = -1
    var  textViewBeginEditing = false
    
    @IBOutlet weak var photoButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var inChoose = false
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
        @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if(selectNumber == -1){

            let memo = Memo(newContent: self.textView.text, newImage: Memo.getBackgroundImage(), newDate: Date(), ID: dataManager.newMemoId(), modifiedTime: Date(),newNo:dataManager.newMemoNO())
            
            dataManager.memos.append(memo)
            coreDataManager.addData(memoId: memo.memoID, memoContent: memo.content!, backgroundImage: memo.backgounrdImage!, setupDate: memo.date!,NO:memo.NO)
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let alertController = UIAlertController(title: "标题", message: "输入标题", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let saveAction = UIAlertAction(title: "保存", style: .default, handler: {
                alert -> Void in
                
                let firstTextField = alertController.textFields![0] as UITextField
                var title = firstTextField.text
                if(title == nil || title?.count == 0){
                    title = dataManager.convertToChineseDate(myDate: Date())
                }
                
                let section = NoteSection(newTitle: title!, newContent: self.textView.text, newTime: Date(), newAttributedContent: NSMutableAttributedString(attributedString:self.textView.attributedText), bookID: dataManager.notebooks[self.selectNumber].noteBookId, sectionID: dataManager.notebooks[self.selectNumber].newSectionID())
                
                let attributedString = self.textView.attributedText
                var getFirstImage:Bool = false
                let range = NSMakeRange(0, (attributedString?.length)!)
                attributedString?.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
                    
                    if object.keys.contains(NSAttributedStringKey.attachment) {
                        if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                            if let image = attachment.image {
                                if(!getFirstImage){
                                    section?.representImage = image
                                    getFirstImage = true
                                }
                                
                            }
                        }
                    }
                }
                
                if(getFirstImage == false){
                    section?.representImage = UIImage(named:"cover1")!
                }
                dataManager.notebooks[self.selectNumber].notes.append(section!)
                dataManager.notebooks[self.selectNumber].modifiedTime = Date()
                
                coreDataManager.addData(noteBookId: (section?.noteBookID)!, noteSectionId: (section?.noteSectionID)!, noteSectionName: (section?.title)!, noteSectionContent: (section?.content)!, noteSectionAttributedContent: (section?.attributedContent)!, setupTime: (section?.time)!, modifiedTime: (section?.modifiedTime)!, representImage: (section?.representImage)!)
                
                self.navigationController?.popViewController(animated: true)
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "标题"
            }
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        self.activityIndicator.isHidden = true
        
        chooseButton.setBackgroundImage(UIImage(named:"bookblack"), for: UIControlState())
        labelName.text = "<左边按钮选择(默认便笺)>"
        blurView.isHidden = true
        textView.delegate = self
        
        textView.text = "输入"
        textView.textColor = UIColor.lightGray
        toolBar.isHidden = true

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self,                                               selector:#selector(keyBoardWillShow(notification:)),
                                               name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(selectNumber == -1){
            
            if(textView.text.count > 140){
                let str = textView.text!
                let endIndex = str.index((str.startIndex), offsetBy: 139)
                let substr = str[str.startIndex...endIndex]
                textView.text = String(substr)
                
            }
            let length = textView.text.count
            numberLabel.text = "\(length) \\ 140"
        }
    }
    
    @objc func keyBoardWillShow(notification:NSNotification)
    {
        let userInfo  = notification.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        let deltaY = keyBoardBounds.size.height
        
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.heightAnchor.constraint(equalToConstant: 40)
        self.toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.toolBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -deltaY).isActive = true
        
        if(selectNumber == -1){
            self.photoButton.isEnabled = false
        }
        else{
            self.photoButton.isEnabled = true
        }
        
        if(self.textViewBeginEditing == true){
            self.toolBar.isHidden = false
        }
        
        self.textViewBottomConstraint.constant = 40+deltaY
        
    }
    @objc func keyBoardWillHide(notification:NSNotification){
        self.toolBar.isHidden = true
        self.textViewBottomConstraint.constant = 0
        
    }
    
    

    @IBAction func chooseButtonTouched(_ sender: UIButton) {
        inChoose = !inChoose
        if(inChoose){
            pickerView.isHidden = false
            blurView.isHidden = false
            self.view.endEditing(true)
            chooseButton.setBackgroundImage(UIImage(named:"bookgreen"), for: UIControlState())

        }
        else{
            pickerView.isHidden = true
            blurView.isHidden = true
            chooseButton.setBackgroundImage(UIImage(named:"bookblack"), for: UIControlState())
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewBeginEditing = true
        self.toolBar.isHidden = false
        if textView.textColor == UIColor.lightGray{
            textView.attributedText = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func keyboardArrow(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func addOCR(_ sender: Any) {
        
        isOCR = true
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }    
    @IBAction func addImage(_ sender: Any) {
        isOCR = false
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
        else{
            let originalAttributedString = textView.attributedText
            let attributedString = NSMutableAttributedString(attributedString: originalAttributedString!)
            let textAttachment = NSTextAttachment()
            
            //textAttachment.bounds = CGRect.init(x:0,y:1,width:textView.bounds.width-50,height:200)
            textAttachment.image = selectedImage.scaleImageToFixedSize(width:textView.bounds.width-50, height: 200)
            
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            
            textView.textStorage.insert(attrStringWithImage, at: textView.selectedRange.location)
            
            dismiss(animated: true, completion: nil)
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
    
    //选择
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row > 0){
        self.labelName.text = String("<") + dataManager.notebooks[row-1].noteName! + String(">")
            selectNumber = row-1
            self.textView.allowsEditingTextAttributes = true
            self.numberLabel.isHidden = true
            
        }
        else{
            self.textView.allowsEditingTextAttributes = false
            selectNumber = -1
            self.labelName.text = String("<便笺>")
            self.numberLabel.isHidden = false
        }
    }
}


