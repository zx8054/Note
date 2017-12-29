//
//  NoteBook.swift
//  Note
//
//  Created by ZhengXin on 2017/11/10.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import Foundation
import UIKit

enum NoteType{
    case diary
    
}
class NoteBook{
    var noteCover:UIImage!
    var noteName:String!
    var noteBookId : Int = 0
    var NO : Int = 0
    var setUpTime : Date
    var modifiedTime : Date
    
    var notes = [NoteSection]()

    func newSectionID()->Int{
        var i = -1
        for note in notes{
            if(note.noteSectionID > i){
                i = note.noteSectionID
                
            }
        }
        return (i+1)
    }
    
    init?(photo:UIImage,str:String,ID:Int,newNO:Int){
        noteCover = photo
        noteName = str
        noteBookId = ID
        NO = newNO
        setUpTime = Date()
        modifiedTime = Date()
    }
    
}
