//
//  SearchNoteTableViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/8.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//
import UIKit
import Foundation

/*搜素笔记本*/
struct NoteSearchResult{
    
    var noteBookName : String
    var noteSectionName : String
    var noteSearchKeyWords : NSMutableAttributedString
    var noteBookIndex : Int
    var noteSectionIndex : Int
    var dateString : String
    
}


class SearchNoteTableViewController: UITableViewController {

    var selectedRow = -1
    var searchNotes = [NoteSearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewNib = UINib(nibName: "SearchCommonTableViewCell", bundle: nil)
        self.tableView.register(viewNib, forCellReuseIdentifier: "cell")
        
        self.tableView.rowHeight = 80
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
        return searchNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCommonTableViewCell
        
        cell.titleLabel.text = searchNotes[indexPath.row].noteBookName + "-" + searchNotes[indexPath.row].noteSectionName
        //cell.contentLabel.text = searchNotes[indexPath.row]
        cell.contentLabel.attributedText = searchNotes[indexPath.row].noteSearchKeyWords
        cell.DateLabel.text = searchNotes[indexPath.row].dateString
        
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: 0)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "SelectSearchNote", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination as? SearchResultViewController {
            viewController.noteBookIndex = searchNotes[selectedRow].noteBookIndex
            viewController.noteBookSectionIndex = searchNotes[selectedRow].noteSectionIndex
            
        }
        
    }
    
    
    
    func Search(forSearchString:String) {
        
        searchNotes.removeAll()
        
        for noteBookIndex in stride(from: 0, to: dataManager.notebooks.count, by: 1) {
            for noteSectionIndex in stride(from: 0, to: dataManager.notebooks[noteBookIndex].notes.count, by: 1){
                
                let str =  dataManager.notebooks[noteBookIndex].notes[noteSectionIndex].attributedContent.string
                if let range : NSRange = (str as NSString).range(of: forSearchString, options: NSString.CompareOptions.caseInsensitive)
                    {   /*根据是否包含子字符串搜索*/
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

                            let dateStr = dataManager.convertToChineseDate(myDate: dataManager.notebooks[noteBookIndex].notes[noteSectionIndex].time!)
//
                            let searchResult : NoteSearchResult = NoteSearchResult(noteBookName: dataManager.notebooks[noteBookIndex].noteName!, noteSectionName: dataManager.notebooks[noteBookIndex].notes[noteSectionIndex].title!, noteSearchKeyWords: attributedString, noteBookIndex: noteBookIndex,noteSectionIndex:noteSectionIndex, dateString: dateStr!)
                            
                            searchNotes.append(searchResult)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
}


