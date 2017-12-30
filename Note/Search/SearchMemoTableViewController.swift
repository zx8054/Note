//
//  SearchMemoTableViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/8.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit
import Foundation

/*便笺搜索界面*/
struct MemoSearchResult{
    var memoContent : NSMutableAttributedString
    var dateString : String
    var memoIndex : Int
}

class SearchMemoTableViewController: UITableViewController {

    var selectedRow = -1
    var searchMemos = [MemoSearchResult]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewNib = UINib(nibName: "SearchCommonTableViewCell", bundle: nil)
        self.tableView.register(viewNib, forCellReuseIdentifier: "cell")
        
        self.tableView.rowHeight = 80
        // Uncomment the following line to preserve selection between presentations

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchMemos.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 1)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! SearchCommonTableViewCell
        
        let memo = searchMemos[indexPath.row]
        // Add image to cell\
        cell.titleLabel.text = "便笺"
        cell.contentLabel.attributedText = memo.memoContent
        cell.DateLabel.text = memo.dateString       // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "searchMemoDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? MemoDetailViewController {
            
            
            viewController.memoID = dataManager.memos[searchMemos[selectedRow].memoIndex].memoID
            viewController.editMode = false
            //viewController.noteBookIndex = searchNotes[selectedRow].noteBookIndex
            //viewController.noteBookSectionIndex = searchNotes[selectedRow].noteSectionIndex
            
        }
        
    }
    
    
    func Search(forSearchString:String){
        searchMemos.removeAll()
        
        for index in stride(from: 0, to: dataManager.memos.count, by: 1){
            let str = dataManager.memos[index].content!
            if let range : NSRange = (str as NSString).range(of: forSearchString, options: NSString.CompareOptions.caseInsensitive){
                if(range.location != NSNotFound)
                {
                    let newLowerBound = (range.lowerBound-3) < 0 ? 0 :range.lowerBound - 3
                    
                    let newUpperBound = (range.upperBound + 3) > str.count - 1 ? str.count - 1 : range.upperBound + 3
                    
                    let startIndex = str.index(str.startIndex,offsetBy:newLowerBound)
                    let endIndex = str.index(startIndex,offsetBy:newUpperBound-newLowerBound)
                    
                    let  substr = "..." + String(str[startIndex...endIndex]) + "..."
                    
                    substr.trimmingCharacters(in: .whitespacesAndNewlines)
                
                    let attributedString = NSMutableAttributedString(string:substr)
                    
                    let newRange:NSRange = (substr  as NSString).range(of: forSearchString, options: NSString.CompareOptions.caseInsensitive)
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: newRange)
                    
                    let dateStr = dataManager.convertToChineseDate(myDate: dataManager.memos[index].date!)
                    
                    var searchResult : MemoSearchResult = MemoSearchResult(memoContent: attributedString, dateString: dateStr!, memoIndex: index)
                    
                    searchMemos.append(searchResult)
                }
                
             self.tableView.reloadData()
            }
        }
    }
}
