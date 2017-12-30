//
//  ViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/11/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

var coreDataManager = CoreDataManager()
var dataManager = DataManager()

/*笔记本界面*/
class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate{
    
    var selectedBookNO = -1
    var inEdit = false
    var selectedIndex = IndexPath.init(row: -1, section: 0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.notebooks.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    /*排序*/
    func sortByModifiedTime(){
        dataManager.notebooks.sort { (notebook1, notebook2) -> Bool in
            return notebook1.modifiedTime > notebook2.modifiedTime
        }
        
        var no = 1
        for notebook in dataManager.notebooks{
            notebook.NO = no
            coreDataManager.updateData(noteBookID: notebook.noteBookId, newNoteBookNo: no)
            no += 1
        }
        self.collectionView.reloadData()
    }
    
    func sortBySetUpTime(){
        dataManager.notebooks.sort { (notebook1, notebook2) -> Bool in
            return notebook1.setUpTime < notebook2.setUpTime
        }
        
        var no = 1
        for notebook in dataManager.notebooks{
            notebook.NO = no
            coreDataManager.updateData(noteBookID: notebook.noteBookId, newNoteBookNo: no)
            no += 1
        }
        self.collectionView.reloadData()
        
    }
 
    /*编辑模式*/
    func setEdit(){
        inEdit  = true
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
    }
    func endEdit(){
        inEdit = false
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifer = "noteBookCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! NoteBookViewCell
        
        let notebook = dataManager.notebooks[indexPath.row]
        
        let str = notebook.noteName! + String("\t")
        cell.noteNameLabel.text = str
        
        cell.noteCoverImage.image = notebook.noteCover
        cell.noteCoverImage.layer.cornerRadius = 5
        cell.noteCoverImage.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 4
        
        if(inEdit){
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = indexPath.row + 1
            if(cell.layer.animation(forKey: "position") == nil){
                cell.shake()
            }
        }
        else{
            cell.deleteButton.isHidden = true
            cell.layer.removeAllAnimations()
        }
        
        if(selectedIndex == indexPath)
        {
            cell.layer.removeAllAnimations()
            selectedIndex.row = -1
        }
        
        return cell
    }
    
    /*删除*/
    @IBAction func deleteButtonTouched(_ sender: UIButton) {
        let alertController = UIAlertController(title: "警告", message: "确定要删除吗", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let sureAction = UIAlertAction(title: "确定", style: .default){
            (UIAlertAction) -> Void in
        for notebook in dataManager.notebooks{
            print("NO \(notebook.NO)")
            if(sender.tag == notebook.NO){
                print("delete")
                coreDataManager.deleteData(NoteBookID: notebook.noteBookId)
                dataManager.deleteNoteBook(NoteBookID: notebook.noteBookId)
                break
            }
        }
        self.collectionView.reloadData()
        }
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    @IBOutlet weak var NoteBookCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*添加长按手势*/
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
    
    }
    
    /*collectionViewCell 移动*/
    @objc func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        switch(gestureReconizer.state) {
            
        case UIGestureRecognizerState.began:
            
            if(!inEdit){
                return
            }
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gestureReconizer.location(in: self.collectionView)) else {
                break
            }
            selectedIndex = selectedIndexPath
            var path = [IndexPath]()
            path.append(selectedIndexPath)
            self.collectionView.reloadItems(at: path)
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gestureReconizer.location(in: gestureReconizer.view!))
            
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
            print("reloadData")
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            
        default:
            collectionView.cancelInteractiveMovement()
            print("reloadData")
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedBookNO = indexPath.row
        return true
    }

    override func prepare(for segue:UIStoryboardSegue,sender:Any?){

        //print("hasSelected \(selectedBookNO)")
        dataManager.setCurrentIndex(index: selectedBookNO)
        dataManager.currentSectionIndex = -1
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHere(segue:UIStoryboardSegue) {
            
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if(sourceIndexPath.row < destinationIndexPath.row){
            for i in stride(from: sourceIndexPath.row, to: destinationIndexPath.row, by: 1){
                dataManager.notebooks[i].NO = i+2
                dataManager.notebooks[i+1].NO = i+1
                coreDataManager.updateData(noteBookID: dataManager.notebooks[i].noteBookId, newNoteBookNo: i+2)
                coreDataManager.updateData(noteBookID: dataManager.notebooks[i+1].noteBookId, newNoteBookNo: i+1)
                dataManager.notebooks.swapAt(i, i+1)
            }
        }
        else{
            for i in stride(from: sourceIndexPath.row,  to: destinationIndexPath.row, by: -1){
                
                dataManager.notebooks[i].NO = i
                dataManager.notebooks[i-1].NO = i+1
                coreDataManager.updateData(noteBookID: dataManager.notebooks[i].noteBookId, newNoteBookNo: i)
                coreDataManager.updateData(noteBookID: dataManager.notebooks[i-1].noteBookId, newNoteBookNo: i+1)
                dataManager.notebooks.swapAt(i, i-1)
            }
            
        }
    }
}

extension UIImage {
    /*将图片按比例缩放*/
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /*将图片缩放成固定尺寸，以便插入textView*/
    func scaleImageToFixedSize(width:CGFloat,height:CGFloat)->UIImage?{
        let scaledSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
extension UIView {
    /*自定义抖动效果*/
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.fromValue = CGPoint.init(x: self.center.x - 5, y: self.center.y)
        animation.toValue = CGPoint.init(x: self.center.x + 5, y: self.center.y)
        self.layer.add(animation, forKey: "position")
    }
    
}

