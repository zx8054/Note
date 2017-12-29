//
//  AddNoteBookViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class AddNoteBookViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var imageSet = [UIImage]()
    var selectedNumber : Int = -1
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if(selectedNumber != -1){
            //var note:NoteBook = NoteBook(photo: imageSet[selectedNumber], str: self.textField.text!, type: .diary)!
            let note:NoteBook = NoteBook(photo: imageSet[selectedNumber], str: self.textField.text!, ID: dataManager.newNoteBookId(), newNO: dataManager.newNoteBookNO())!
            
            dataManager.notebooks.append(note)
            coreDataManager.addData(noteCover: note.noteCover!, noteID: note.noteBookId, noteName: note.noteName!, setupTime: Date(), modifiedTime: Date(),noteNO:note.NO)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initIamgeSet()
        collectionView.delegate = self as! UICollectionViewDelegate
        collectionView.dataSource = self as! UICollectionViewDataSource
        
        let viewNib = UINib(nibName: "NotebookCoverCollectionViewCell", bundle: nil)
        self.collectionView.register(viewNib, forCellWithReuseIdentifier: "cell")
        
        self.navigationController?.navigationBar.tintColor = UIColor.white// Do any additional setup after loading the view.
        
    }

    func initIamgeSet(){
        
        imageSet.append(UIImage(named:"cover1")!)
        imageSet.append(UIImage(named:"cover2")!)
        imageSet.append(UIImage(named:"cover3")!)
        imageSet.append(UIImage(named:"cover4")!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectedPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.size.width-30)/3, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                  withReuseIdentifier: "headerView", for: indexPath)
            //设置头部标题
            let label = reusableview.viewWithTag(1) as! UILabel
            label.text = "请选择封面"
            
            let button = reusableview.viewWithTag(2) as! UIButton
            //button.setBackgroundImage(UIImage(named:"camera"), for:UIControlState())
        }
        return reusableview
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)
        imageSet.append(selectedImage)
        self.collectionView.reloadData()
        
        
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

extension AddNoteBookViewController:UICollectionViewDataSource,UITextFieldDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NotebookCoverCollectionViewCell
        
        cell.image.image = imageSet[indexPath.row]
        
        if(selectedNumber != indexPath.row){
            cell.selectedButton.isHidden = true
        }
        else{
            cell.selectedButton.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedNumber = indexPath.row
        collectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.endEditing(true)
        self.view.endEditing(true)
        return true
    }
}
