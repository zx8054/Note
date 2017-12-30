//
//  CoreDataManager.swift
//  Note
//
//  Created by ZhengXin on 2017/12/24.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    var noteBooks = [NSManagedObject]()
    var noteSections = [NSManagedObject] ()
    var memos = [NSManagedObject]()
    var loads = [NSManagedObject]()
    
    var appDelegate : AppDelegate
    var managedContext : NSManagedObjectContext
    
    
    init(){
        /*获取core data context*/
        appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        managedContext =
            appDelegate.persistentContainer.viewContext

    }
    
    public func fetchFromCoreData(){
        
        let fetchRequestNoteBook =
            NSFetchRequest<NSManagedObject>(entityName: "NoteBookCoreData")
        let fetchRequestNoteSection =
            NSFetchRequest<NSManagedObject>(entityName: "NoteSectionCoreData")
        let fetchRequestMemo =
            NSFetchRequest<NSManagedObject>(entityName: "MemoCoreData")
        
        do {
            noteBooks = try managedContext.fetch(fetchRequestNoteBook)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            noteSections = try managedContext.fetch(fetchRequestNoteSection)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        do {
            memos = try managedContext.fetch(fetchRequestMemo)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let fetchRequestFirst = NSFetchRequest<NSManagedObject>(entityName: "FirstLoad")
        do{
            loads = try managedContext.fetch(fetchRequestFirst)
            if(loads.count == 0){
                let entity =
                    NSEntityDescription.entity(forEntityName: "FirstLoad",
                                               in: managedContext)!
                let firstLoad = NSManagedObject(entity: entity,
                                                  insertInto: managedContext)
                firstLoad.setValue(true, forKey: "isFirst")
                do {
                    try managedContext.save()
                    loads.append(firstLoad)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                self.setDefaulData()
            }
        }  catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print("sectionNum \(noteSections.count)")
        
    }
    
    func addData(noteBookId:Int,noteSectionId:Int,noteSectionName:String,noteSectionContent:String,noteSectionAttributedContent:NSMutableAttributedString,setupTime:Date,modifiedTime:Date,representImage:UIImage){
        
        let entity =
            NSEntityDescription.entity(forEntityName: "NoteSectionCoreData",
                                       in: managedContext)!
        let noteSection = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        noteSection.setValue(noteBookId, forKeyPath: "noteBookID")
        noteSection.setValue(noteSectionId, forKeyPath: "noteSectionID")
        noteSection.setValue(noteSectionName, forKeyPath: "noteSectionName")
        noteSection.setValue(noteSectionContent, forKeyPath: "noteContent")
        noteSection.setValue(noteSectionAttributedContent, forKeyPath: "attributedContent")
        
        noteSection.setValue(setupTime, forKey: "setupTime")
        noteSection.setValue(modifiedTime, forKey: "modifiedTime")
        
        guard let imageData = UIImageJPEGRepresentation(representImage, 1) else {
            print("jpg error")
            return
        }
        
        for notebook in noteBooks{
            if notebook.value(forKeyPath: "noteBookID") as! Int == noteBookId{
                notebook.setValue(Date(), forKeyPath: "modifiedTime")
                break
            }
            
        }
        
        noteSection.setValue(imageData, forKeyPath: "representImage")
        
        do {
            try managedContext.save()
            noteSections.append(noteSection)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addData(memoId:Int,memoContent:String,backgroundImage:UIImage,setupDate:Date,NO:Int){
        
        let entity =
            NSEntityDescription.entity(forEntityName: "MemoCoreData",
                                       in: managedContext)!
        let memo = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        memo.setValue(memoId, forKeyPath: "memoID")
        memo.setValue(memoContent, forKeyPath: "content")
        memo.setValue(setupDate, forKeyPath: "setupDate")
        memo.setValue(setupDate, forKeyPath: "modifiedDate")
        memo.setValue(NO, forKey: "no")
        
        
        guard let imageData = UIImageJPEGRepresentation(backgroundImage, 1) else {
            print("jpg error")
            return
        }
        
        memo.setValue(imageData, forKeyPath: "backgroundImage")
        
        do {
            try managedContext.save()
            memos.append(memo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    public func addData(noteCover:UIImage,noteID:Int,noteName:String,setupTime:Date,modifiedTime:Date,noteNO:Int){
        
        let entity =
            NSEntityDescription.entity(forEntityName: "NoteBookCoreData",
                                       in: managedContext)!
        let noteBook = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        noteBook.setValue(noteID, forKeyPath: "noteBookID")
        noteBook.setValue(noteName, forKeyPath: "noteName")
        noteBook.setValue(setupTime, forKeyPath: "createTime")
        noteBook.setValue(modifiedTime, forKeyPath: "modifiedTime")
        noteBook.setValue(noteNO, forKey: "no")
        
        
        guard let imageData = UIImageJPEGRepresentation(noteCover, 1) else {
            print("jpg error")
            return
        }
        
        noteBook.setValue(imageData, forKeyPath: "noteCover")
        
        do {
            try managedContext.save()
            noteBooks.append(noteBook)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    /*增加数据*/
    
    func deleteData(NoteBookID:Int){
        
        var i = 0
        for notebook in noteBooks{
            if(notebook.value(forKeyPath: "noteBookID") as! Int  == NoteBookID)
            {
                managedContext.delete(notebook)
                noteBooks.remove(at: i)
                break
            }
            i = i + 1
        }
        
        i = 0
        for NoteSection in noteSections{
            if(NoteSection.value(forKeyPath: "noteBookID") as! Int == NoteBookID){
                managedContext.delete(NoteSection)
                noteSections.remove(at: i)
                i = i - 1
            }
            i = i + 1
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteData(noteBookID:Int,noteSectionID:Int){
        var i = 0
        for notesection in noteSections{
            if(notesection.value(forKeyPath: "noteBookID") as! Int == noteBookID &&
                notesection.value(forKeyPath: "noteSectionID") as! Int == noteSectionID
                ){
                managedContext.delete(notesection)
                noteSections.remove(at: i)
                break
            }
            i = i + 1
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func deleteData(memoID:Int){
        var i = 0
        for memo in memos{
            if(memo.value(forKeyPath: "memoID") as! Int == memoID){
                managedContext.delete(memo)
                memos.remove(at: i)
                break
            }
            i = i + 1
            
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    /*删除数据*/
    
    func updateData(NoteBookID:Int,NoteSectionID:Int,noteSectionContent:String,noteSectionAttributedContent:NSMutableAttributedString,modifiedTime:Date,representImage:UIImage){
        
        for notesection in noteSections{
            if(notesection.value(forKeyPath: "noteBookID") as! Int == NoteBookID && notesection.value(forKeyPath: "noteSectionID") as! Int == NoteSectionID){
                
                    notesection.setValue(noteSectionContent, forKeyPath: "noteContent")
                    notesection.setValue(noteSectionAttributedContent, forKeyPath: "attributedContent")
                    guard let imageData = UIImageJPEGRepresentation(representImage, 1) else {
                        print("jpg error")
                        return
                    }
                    notesection.setValue(imageData, forKeyPath: "representImage")
                    notesection.setValue(modifiedTime, forKey: "modifiedTime")

                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not update. \(error), \(error.userInfo)")
                    }
            }
        }
        
        for notebook in noteBooks{
            if notebook.value(forKeyPath: "noteBookID") as! Int == NoteBookID{
                notebook.setValue(Date(), forKeyPath: "modifiedTime")
                break
            }
            
        }
        
    }
    
    func updateData(noteBookID:Int,newNoteBookNo:Int){
        for notebook in noteBooks{
            if(notebook.value(forKeyPath: "noteBookID") as! Int == noteBookID){
                    notebook.setValue(newNoteBookNo, forKeyPath: "no")
                break
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
    func updateData(memoID:Int,newMemoNO:Int){
        for memo in memos{
            if(memo.value(forKeyPath: "memoID") as! Int == memoID){
                memo.setValue(newMemoNO, forKeyPath: "no")
                break
            }

        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
    func updateData(memoID:Int,newContent:String){
        for memo in memos{
            if(memo.value(forKeyPath: "memoID") as! Int == memoID){
                memo.setValue(newContent, forKeyPath: "content")
                memo.setValue(Date(), forKeyPath: "modifiedDate")
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    /*更新数据*/
    
    func setDefaulData(){
        /*设置初始数据*/
        self.addData(memoId: 0, memoContent: "右上角添加按钮可以添加笔记或者便笺", backgroundImage: UIImage.init(named: "whitePaper")!, setupDate: Date(), NO: 1)
        self.addData(memoId: 1, memoContent: "左上角点击编辑后可以移动位置（长按）或者删除", backgroundImage: UIImage.init(named: "yellowPaper")!, setupDate: Date(), NO: 2)
        self.addData(memoId: 2, memoContent: "笔记中可以选择添加图片，便笺只能添加文字，二者都能使用OCR来添加内容", backgroundImage: UIImage.init(named: "bluePaper")!, setupDate: Date(), NO: 3)
        
        self.addData(noteCover: UIImage.init(named: "cover2")!, noteID: 0, noteName: "默认", setupTime: Date(), modifiedTime: Date(), noteNO: 1)
        self.addData(noteBookId: 0, noteSectionId: 0, noteSectionName: "提示", noteSectionContent: "左滑或左上角菜单拉出目录", noteSectionAttributedContent: NSMutableAttributedString(string:"左滑或左上角菜单拉出目录"), setupTime: Date(), modifiedTime: Date(), representImage: UIImage.init(named: "defaultRepresent")!)
        self.addData(noteBookId: 0, noteSectionId: 1, noteSectionName: "假装有内容", noteSectionContent: "假装有内容", noteSectionAttributedContent: NSMutableAttributedString(), setupTime: Date(), modifiedTime: Date(), representImage: UIImage.init(named: "wallpaper1")!)
        
        self.addData(noteCover: UIImage.init(named: "cover4")!, noteID: 1, noteName: "数学", setupTime: Date(), modifiedTime: Date(), noteNO: 2)
        self.addData(noteBookId: 1, noteSectionId: 0, noteSectionName: "概率论", noteSectionContent: "假装有内容", noteSectionAttributedContent: NSMutableAttributedString(), setupTime: Date(), modifiedTime: Date(), representImage: UIImage.init(named: "math1")!)
    }
    
}
