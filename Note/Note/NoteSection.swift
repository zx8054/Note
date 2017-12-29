//
//  NoteSeccion.swift
//  Note
//
//  Created by ZhengXin on 2017/12/4.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import Foundation
import UIKit

class NoteSection{
    
    var title:String?
    var content: String? //NSMutableAttributedString?
    var attributedContent: NSMutableAttributedString
    var time : Date?
    var representImage : UIImage = UIImage(named:"defaultRepresent")!
    var modifiedTime = Date()
    var noteSectionID : Int = 0
    var noteBookID : Int = 0
    

    init?(newTitle:String,newContent:String?,newTime:Date?,newAttributedContent:NSMutableAttributedString,bookID:Int,sectionID:Int){
        
        noteBookID = bookID
        noteSectionID = sectionID
        title = newTitle
        content = newContent
        time = newTime
        attributedContent = newAttributedContent
        
    }
    
    
}

