//
//  ViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/11/9.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

var dataManager = DataManager()

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var notebooks = [NoteBook]()
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.notebooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifer = "noteBookCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! NoteBookViewCell
        
        let notebook = dataManager.notebooks[indexPath.row]
        
        let str = notebook.noteName! + String(" ")
        cell.noteNameLabel.text = str
        
        cell.noteCoverImage.image = notebook.noteCover
        cell.noteCoverImage.layer.cornerRadius = 5
        cell.noteCoverImage.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 4
        //cell.layer.borderWidth = 2
        //cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    

    @IBOutlet weak var NoteBookCollectionView: UICollectionView!
    
    private func initNotes(){
        let defaultPhoto = UIImage(named:"default")
        
        if let defaultNote = NoteBook(photo: defaultPhoto!, str: "默认笔记", type: .diary){
            
            notebooks += [defaultNote]
            if let section1 = NoteSection(newTitle: "fff",newContent: "cccccc",newTime: Date()){
                notebooks[0].notes += [section1]
            }
            
        }
        else{
            return
        }
        
        if let secondeNote = NoteBook(photo:defaultPhoto!,str:"日记",type:.diary){
            notebooks += [secondeNote]
        }
        else{
            return
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNotes()
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        
        super.prepare(for: segue, sender: sender)
        if let cell = sender as? NoteBookViewCell,let selectednoteName = cell.noteNameLabel.text{
            //var _ : Int
            for index in stride(from: 0, through: dataManager.notebooks.count - 1, by: 1){
                var name = dataManager.notebooks[index].noteName as! String
                name += " "
                if(name == selectednoteName){
                    if segue.destination is SWRevealViewController{
                            dataManager.setCurrentIndex(index: index)
                            print(index)
                            break
                    }
                    else{
                        fatalError("segue error")
                    }
                    
                    
                }
            }
        }
        else{
            return
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHere(segue:UIStoryboardSegue) {
            
    }


}

