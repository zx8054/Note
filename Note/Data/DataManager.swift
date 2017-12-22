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
        let memo1 = Memo(newContent: "概率论考试",newImage: UIImage(named:"whitePaper")!,newDate: Date())
        let memo2 = Memo(newContent: "数据库考试", newImage: UIImage(named:"yellowPaper"
            )!, newDate: Date())
        let memo3 = Memo(newContent: "抢火车票",newImage: UIImage(named:"pinkPaper")!,newDate: Date())
        let memo4 = Memo(newContent: "移动开发大作业", newImage: UIImage(named:"bluePaper"
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
        
        if let defaultNote = NoteBook(photo: UIImage(named:"cover3")!, str: "数学", type: .diary){
            notebooks += [defaultNote]
            if let section1 = NoteSection(newTitle: "概率论",newContent: "c",newTime: Date(), newAttributedContent: NSMutableAttributedString(string: " ")){
                
                section1.content = "概率论"
                section1.representImage = UIImage(named:"math1")!
                notebooks[0].notes += [section1]
            }
            if let section2 = NoteSection(newTitle: "统计",newContent: "c",newTime: Date(), newAttributedContent: NSMutableAttributedString(string: " ")){
                
                section2.representImage = UIImage(named:"math2")!
                section2.content = "统计"
                notebooks[0].notes += [section2]
            }
            
        }
        
        if let secondeNote = NoteBook(photo:UIImage(named:"cover1")!,str:"英语",type:.diary){
            notebooks += [secondeNote]

        }

    }
}
