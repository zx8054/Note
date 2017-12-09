//
//  AddNoteBookViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class AddNoteBookViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    var selectedNumber : Int = -1
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self as! UICollectionViewDelegate
        collectionView.dataSource = self as! UICollectionViewDataSource
        
        let viewNib = UINib(nibName: "NotebookCoverCollectionViewCell", bundle: nil)
        self.collectionView.register(viewNib, forCellWithReuseIdentifier: "cell")
        
        self.navigationController?.navigationBar.tintColor = UIColor.white// Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.size.width-30)/3, height: 140)
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

extension AddNoteBookViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NotebookCoverCollectionViewCell
        
        cell.image.image = UIImage(named:"cover3")
        
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
    
    
    
    
    
}
