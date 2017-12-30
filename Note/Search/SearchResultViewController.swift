//
//  SearchResultViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/23.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

/*note粗略展示*/
class SearchResultViewController: UIViewController {

    
    var noteBookIndex  = -1
    var noteBookSectionIndex = -1
    
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sectionName = dataManager.notebooks[noteBookIndex].noteName! + " - " +  dataManager.notebooks[noteBookIndex].notes[noteBookSectionIndex].title!
        
        self.navigationItem.title = sectionName
        
        self.textView.attributedText = dataManager.notebooks[noteBookIndex].notes[noteBookSectionIndex].attributedContent
        self.textView.isEditable = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
