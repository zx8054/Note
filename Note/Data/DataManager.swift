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
        initNotes()
        initMemo()
        }
    
    
    func initMemo(){
        let memo1 = Memo(newContent: "今天",newImage: UIImage(named:"whitePaper")!,newDate: Date())
        let memo2 = Memo(newContent: "明天", newImage: UIImage(named:"yellowPaper"
            )!, newDate: Date())
        let memo3 = Memo(newContent: "后天",newImage: UIImage(named:"pinkPaper")!,newDate: Date())
        let memo4 = Memo(newContent: "大后天", newImage: UIImage(named:"bluePaper"
            )!, newDate: Date())
        
        memos.append(memo1)
        memos.append(memo2)
        memos.append(memo3)
        memos.append(memo4)
    }
    func setCurrentIndex(index : Int){
        currentIndex = index
    }
    
    func setCurrentNoteBook(index:Int){
        currentIndex = index
    }
    
    func initNotes(){
        let defaultPhoto = UIImage(named:"cover3")
        
        if let defaultNote = NoteBook(photo: defaultPhoto!, str: "默认笔记", type: .diary){
            
            notebooks += [defaultNote]
            if let section1 = NoteSection(newTitle: "封面",newContent: "cccccc",newTime: Date()){
                notebooks[0].notes += [section1]
            }
            
        }
        else{
            return
        }
        
        if let secondeNote = NoteBook(photo:defaultPhoto!,str:"日记",type:.diary){
            notebooks += [secondeNote]
            notebooks += [secondeNote]
            notebooks += [secondeNote]
            notebooks += [secondeNote]
            notebooks += [secondeNote]
            notebooks += [secondeNote]
        }
        else{
            return
        }
    }
}
