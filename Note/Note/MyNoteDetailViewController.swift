//
//  MyNoteDetailViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/4.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class MyNoteDetailViewController: UIViewController {
    
    var noteDetail = NoteSection(newTitle: "s",newContent: "s",newTime: Date())
    
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func unwindToDetailView(segue:UIStoryboardSegue) {
        if let myView = segue.source as? addNoteSectionViewController{
            var section = NoteSection(newTitle: myView.textField.text!, newContent: myView.textView.text, newTime: Date())
            dataManager.notebooks[dataManager.currentIndex].notes.append(section!)
            if let menuViewController = self.revealViewController().rearViewController as?
                NoteMenuTableViewController{
                menuViewController.tableView.reloadData()
                
            }
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
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNoteBook(index:Int) -> Void{

    }
    
    public func setSection(index:Int) -> Void{
        
        noteDetail = dataManager.notebooks[dataManager.currentIndex].notes[index]
        self.navigationItem.title = noteDetail?.title
        self.textView.text = noteDetail?.content
    }
    
    
//    var noteItem:NoteSection?{
//        didSet{
//            //tview.backgroundColor = menuItem?.color
//            //symbol.text = menuItem?.symbol
//            textView.text = noteItem?.content
//
//            UIView.animate(withDuration: 0.4, animations: {
//                self.view.transform = CGAffineTransform.identity
//            })
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
