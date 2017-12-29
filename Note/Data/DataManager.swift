//
//  DataManager.swift
//  Note
//
//  Created by ZhengXin on 2017/12/5.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import Foundation

class DataManager{
    
    var memos = [Memo]()
    var notebooks = [NoteBook]()
    var currentIndex : Int
    var currentSectionIndex:Int = 0
    var currentNoteBook : NoteBook!
    
    
       init(){
        self.currentIndex = -1
        self.currentSectionIndex = -1
        //initNotes()
        //initMemo()
        }
    
    
    func initMemo(){
        
    }
    func setCurrentIndex(index : Int){
        currentIndex = index
    }
    
    func setCurrentNoteBook(index:Int){
        currentIndex = index
    }
    
    func loadDataFromCoreData(){
        let coreNoteBooks = coreDataManager.noteBooks
        for coreNoteBook in coreNoteBooks{
            let noteName = coreNoteBook.value(forKeyPath: "noteName") as? String
            let noteBookId = coreNoteBook.value(forKeyPath: "noteBookID") as? Int
            let createTime = coreNoteBook.value(forKeyPath: "createTime") as? Date
            let modifiedTime = coreNoteBook.value(forKeyPath: "modifiedTime") as? Date
            //let imageData = coreNoteBook.value(forKeyPath: "noteCover") as? NSData
            let imageData = coreNoteBook.value(forKey: "noteCover") as? Data
            let image = UIImage(data:imageData!)
            let noteNO = coreNoteBook.value(forKeyPath: "no") as! Int
            
            if let tempNote = NoteBook.init(photo: image!, str: noteName!, ID: noteBookId!,newNO:noteNO) {
                tempNote.setUpTime = createTime!
                tempNote.modifiedTime = modifiedTime!
                notebooks += [tempNote]
                
                
            }
            
            notebooks.sort(by: { (notebook1, notebook2) -> Bool in
                return notebook1.NO < notebook2.NO
            })
        }
        
        let coreNoteSections = coreDataManager.noteSections
        for coreNoteSection in coreNoteSections{
            let noteBookID = coreNoteSection.value(forKeyPath: "noteBookID") as? Int
            let noteSectionID = coreNoteSection.value(forKeyPath: "noteSectionID") as? Int
            let imageData = coreNoteSection.value(forKey: "representImage") as? Data
            let representImage = UIImage(data:imageData!)
            
            let noteSectionName = coreNoteSection.value(forKeyPath: "noteSectionName") as? String
            let noteContent = coreNoteSection.value(forKeyPath: "noteContent") as? String
            
            //let attributedData = coreNoteSection.value(forKeyPath: "attributedContent") as? Data
            
            let noteAttributedContent = coreNoteSection.value(forKeyPath: "attributedContent") as? NSMutableAttributedString
            
            
            let modifiedTime = coreNoteSection.value(forKeyPath: "modifiedTime") as? Date
            let setupTime = coreNoteSection.value(forKeyPath: "setupTime") as? Date
            
            if let tempNoteSection = NoteSection.init(newTitle: noteSectionName!, newContent: noteContent, newTime: setupTime, newAttributedContent: noteAttributedContent!, bookID: noteBookID!, sectionID: noteSectionID!) {
                tempNoteSection.representImage = representImage!
                tempNoteSection.modifiedTime = modifiedTime!
                
                for notebook in notebooks{
                    if(notebook.noteBookId == noteBookID){
                        notebook.notes.append(tempNoteSection)
                        break
                    }
                }
            }
        }
        
        let coreMemos = coreDataManager.memos
        for coreMemo in coreMemos{
            let memoId = coreMemo.value(forKeyPath: "memoID") as? Int
            let content = coreMemo.value(forKeyPath: "content") as? String
            
            let imageData = coreMemo.value(forKey: "backgroundImage") as? Data
            let backgroundImage = UIImage(data:imageData!)
            
            let setupDate = coreMemo.value(forKeyPath: "setupDate") as? Date
            let modifiedDate = coreMemo.value(forKeyPath: "modifiedDate") as? Date
            let no = coreMemo.value(forKeyPath: "no") as? Int
            
            let tempMemo = Memo(newContent: content!, newImage: backgroundImage!, newDate: setupDate!, ID: memoId!, modifiedTime: modifiedDate!, newNo: no!)
                memos.append(tempMemo)
            
        }
        
        memos.sort { (memo1, memo2) -> Bool in
            return memo1.NO < memo2.NO
        }
        
    }
    
    func newNoteBookId()->Int{
        var i = -1
        for notebook in notebooks{
            if(notebook.noteBookId > i){
                i = notebook.noteBookId
            }
        }
        return (i+1)
    }
    
    func newNoteBookNO()->Int{
        return notebooks.count + 1
    }
    
    
    func newMemoId()->Int{
        var i = -1
        for memo in memos{
            if(memo.memoID > i){
                i = memo.memoID
            }
            
        }
        return (i+1)
    }
    
    func newMemoNO()->Int{
        return memos.count + 1
    }
    
    func deleteNoteBook(NoteBookID:Int)
    {
        var i = 0
        for notebook in notebooks{
            if(notebook.noteBookId == NoteBookID){
                notebooks.remove(at: i)
                break
            }
            i = i + 1
        }
        
        print("i \(i)")
        for index in stride(from: i, to: notebooks.count, by: 1){
            notebooks[index].NO -= 1
        }
        
    }
    
    func deleteNoteSection(NoteBookID:Int,NoteSectionID:Int){
        for note in notebooks{
            if note.noteBookId == NoteBookID{
                var i = 0
                for noteSection in note.notes{
                    if(NoteSectionID == noteSection.noteSectionID){
                        note.notes.remove(at: i)
                        break
                    }
                    i = i + 1
                }
            }
        }
    }
    
    
    func deleteMemo(memoID:Int){
        
        var i = 0
        for memo in memos{
            if(memo.memoID == memoID){
                memos.remove(at: i)
                break
            }
            i = i + 1
        }
        
        for index in stride(from: i, to: memos.count, by: 1){
            memos[index].NO -= 1
        }
    }
    
    
    func convertToChineseDate(myDate : Date) -> String? {
        let formatter = DateFormatter()
        let timeZone = TimeZone.init(identifier: "UTC")
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        //formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.string(from: myDate)
        return str
        //return date.components(separatedBy: " ").first!
    }
}
