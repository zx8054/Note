//
//  MemoViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/6.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate, MemoUICollectionViewCellDelegate {
    
    var didSelectedItem = -1
    
    func deleteMemo(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "警告", message: "确定要删除吗", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let sureAction = UIAlertAction(title: "确定", style: .default){
            (UIAlertAction) -> Void in
            for memo in dataManager.memos{
                print("NO \(memo.NO)")
                if(sender.tag == memo.NO){
                    print("delete")
                    coreDataManager.deleteData(memoID: memo.memoID)
                    dataManager.deleteMemo(memoID: memo.memoID)
                    break
                }
            }
            
            self.layout.clearCache()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sortByModifiedTime(){
        
        if dataManager.memos.count == 0{
            return
        }
        
        dataManager.memos.sort { (memo1, memo2) -> Bool in
            return memo1.modifiedDate! > memo2.modifiedDate!
        }
        
        var no = 1
        for memo in dataManager.memos{
            memo.NO = no
            coreDataManager.updateData(memoID: memo.memoID, newMemoNO: no)
            no += 1
        }
        self.layout.clearCache()
        self.collectionView.reloadData()
    }
    
    func sortBySetUpTime(){
        
        if dataManager.memos.count == 0{
            return
        }
        
        dataManager.memos.sort { (memo1, memo2) -> Bool in
            return memo1.date! < memo2.date!
        }
        
        var no = 1
        for memo in dataManager.memos{
            memo.NO = no
            coreDataManager.updateData(memoID: memo.memoID, newMemoNO: no)
            no += 1
        }
        self.layout.clearCache()
        self.collectionView.reloadData()
        
    }
    
    func setEdit(){
        inEdit  = true
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
    }
    func endEdit(){
        inEdit = false
        self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
    }
    
    @IBOutlet weak var collectionViewTopLayout: NSLayoutConstraint!
    weak var layout : MyWaterFallLayout!

    var inEdit = false
    var selectedIndex = IndexPath.init(row: -1, section: 0)
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupCollectionView()
        registerNibs()
        
    
        
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
        
        // Do any additional setup after loading the view.
    }
    
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
            
            /*
            if(!inEdit){
                self.editButton.isHidden = false
                self.collectionViewTopLayout.constant = 40
                inEdit  = true
                var arrayIndexPath = [IndexPath]()
                for indexPath in self.collectionView.indexPathsForVisibleItems{
                    if(indexPath != selectedIndexPath){
                        arrayIndexPath.append(indexPath)
                    }
//                let endButton = UIBarButtonItem()
//                endButton.title = "完成"
//                endButton.target = self
//                self.navigationItem.leftBarButtonItem = endButton
                    
                //endButton
                
                }
                self.collectionView.reloadItems(at: arrayIndexPath)
            }
            */
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gestureReconizer.location(in: gestureReconizer.view!))
            
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
            
            layout.clearCache()
            layout.invalidateLayout()
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            
        default:
            collectionView.cancelInteractiveMovement()
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCollectionView(){
        layout = collectionView.collectionViewLayout as! MyWaterFallLayout
        layout.delegate = self
    }
    
    func registerNibs(){
        
        let viewNib = UINib(nibName: "MemoUICollectionViewCell", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print("count + \(dataManager.memos.count)")
        return dataManager.memos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Create the cell and return the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemoUICollectionViewCell
        
        let memo = dataManager.memos[indexPath.row]
        
        cell.imageView.image = memo.backgounrdImage
        cell.contentLabel.text = memo.content
        cell.label.text = dataManager.convertToChineseDate(myDate: memo.date!)
        cell.delegate = self
        
        if(inEdit){
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = memo.NO
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        //let imageSize = model.images[indexPath.row].size
        let memo = dataManager.memos[indexPath.row]
        let length = memo.length
        let size = CGSize(width:150,height: length)
        return size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("viewWillApprea")
        
        super.viewWillAppear(animated)
        layout.clearCache()
        layout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if(sourceIndexPath.row < destinationIndexPath.row){
            for i in stride(from: sourceIndexPath.row, to: destinationIndexPath.row, by: 1){
                dataManager.memos[i].NO = i+2
                dataManager.memos[i+1].NO = i+1
                coreDataManager.updateData(memoID: dataManager.memos[i].memoID, newMemoNO: i+2)
                coreDataManager.updateData(memoID: dataManager.memos[i+1].memoID, newMemoNO: i+1)
                dataManager.memos.swapAt(i, i+1)
            }
        }
        else{
            for i in stride(from: sourceIndexPath.row,  to: destinationIndexPath.row, by: -1){
                dataManager.memos[i].NO = i
                dataManager.memos[i-1].NO = i+1
                coreDataManager.updateData(memoID: dataManager.memos[i].memoID, newMemoNO: i)
                coreDataManager.updateData(memoID: dataManager.memos[i-1].memoID, newMemoNO: i+1)
                dataManager.memos.swapAt(i, i-1)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedItem = indexPath.row
        performSegue(withIdentifier: "memoDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? MemoDetailViewController {
            viewController.memoID = dataManager.memos[didSelectedItem].memoID
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

extension MemoViewController : MyWaterFallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //print("\(indexPath.row)")
        
        return CGFloat(dataManager.memos[indexPath.row].length)
        //return photos[indexPath.item].image.size.height
    }
}

