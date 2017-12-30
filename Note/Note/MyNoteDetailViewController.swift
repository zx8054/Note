//
//  MyNoteDetailViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/4.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit
import TesseractOCR


class MyNoteDetailViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,G8TesseractDelegate{
    
    var isOCR:Bool = false
    
    var noteDetail = NoteSection(newTitle: "s", newContent: "s", newTime: Date(), newAttributedContent: NSMutableAttributedString(), bookID: 0, sectionID: 0)
    
    var tempContent = NSMutableAttributedString()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
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
    
    @IBAction func saveCurrentNote(_ sender: Any) {
        dataManager.notebooks[dataManager.currentIndex].notes[dataManager.currentSectionIndex].attributedContent
         = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let attributedString = textView.attributedText
        
        var getFirstImage:Bool = false
        let range = NSMakeRange(0, (attributedString?.length)!)
        attributedString?.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
            
            if object.keys.contains(NSAttributedStringKey.attachment) {
                if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                    if let image = attachment.image {
                        if(!getFirstImage){ dataManager.notebooks[dataManager.currentIndex].notes[dataManager.currentSectionIndex].representImage = image
                            getFirstImage = true
                        }
                    }
                }
            }
        }
        
        let noteSection = dataManager.notebooks[dataManager.currentIndex].notes[dataManager.currentSectionIndex]
        noteSection.modifiedTime = Date()
            coreDataManager.updateData(NoteBookID: noteSection.noteBookID, NoteSectionID: noteSection.noteSectionID, noteSectionContent: noteSection.content!, noteSectionAttributedContent: noteSection.attributedContent, modifiedTime: Date(), representImage: noteSection.representImage)
        
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
            let textAttachment = NSTextAttachment()
            textAttachment.image = selectedImage.scaleImageToFixedSize(width: textView.bounds.width-50, height: 200)
            
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
            textView.textStorage.insert(attrStringWithImage, at: textView.selectedRange.location)
            tempContent =  NSMutableAttributedString(attributedString: textView.attributedText)
            dismiss(animated: true, completion: nil)
        }
        
    }

    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBAction func unwindToDetailView(segue:UIStoryboardSegue) {
        if let myView = segue.source as? addNoteSectionViewController{
            if let menuViewController = self.revealViewController().rearViewController as?
                NoteMenuTableViewController{
                menuViewController.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let menuViewController = self.revealViewController().rearViewController as?
            NoteMenuTableViewController{
            menuViewController.tableView.reloadData()
        }
        
        
        if(dataManager.currentSectionIndex == -1){
        var ttext = "\n\n\t\t\t\t目录"
        for index in stride(from: 0, to: dataManager.notebooks[dataManager.currentIndex].notes.count, by: 1){
            
            ttext += "\n\n\t \(index+1). "+dataManager.notebooks[dataManager.currentIndex].notes[index].title!
            
        }
        
        self.textView.isEditable = false
        self.textView.text = ttext
        self.navigationItem.title = dataManager.notebooks[dataManager.currentIndex].noteName
        }
        else {
            self.setSection(index: dataManager.currentSectionIndex)
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if(self.revealViewController() != nil){
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        var ttext = "\n\n\t\t\t\t目录"
        print(dataManager.currentIndex)
        for index in stride(from: 0, to: dataManager.notebooks[dataManager.currentIndex].notes.count, by: 1){
            
            ttext += "\n\n\t \(index+1). "+dataManager.notebooks[dataManager.currentIndex].notes[index].title!
            
        }
        
        self.textView.isEditable = false
        self.textView.text = ttext
        self.navigationItem.title = dataManager.notebooks[dataManager.currentIndex].noteName
        
        self.toolBar.isHidden = true
        NotificationCenter.default.addObserver(self,                                               selector:#selector(keyBoardWillShow(notification:)),
            name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.textView.delegate = self
        self.activityIndicator.isHidden = true
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
        self.textViewBottomConstraint.constant = -40-deltaY
        
    }
    @objc func keyBoardWillHide(notification:NSNotification){
        self.toolBar.isHidden = true
        
        //print("dd")
        self.textViewBottomConstraint.constant = 0
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNoteBook(index:Int) -> Void{

    }
    
    public func setSection(index:Int) -> Void{
        
        dataManager.currentSectionIndex = index
        self.textView.endEditing(true)
        noteDetail = dataManager.notebooks[dataManager.currentIndex].notes[index]
        self.navigationItem.title = noteDetail?.title

        if let text : NSMutableAttributedString? = dataManager.notebooks[dataManager.currentIndex].notes[index].attributedContent{
            textView.attributedText = text
            self.textView.isEditable = true
        }        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.textView.scrollRangeToVisible(self.textView.selectedRange)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
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
