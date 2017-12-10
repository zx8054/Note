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
    var time : Date?
    var representImage : UIImage = UIImage(named:"math1")!
    
    init?(newTitle:String,newContent:String?,newTime:Date?){
        
        title = newTitle
        content = newContent
        time = newTime
      
    }
    
    static var sharedNoteSection:[NoteSection]{
        var items = [NoteSection]()
        items.append(NoteSection(newTitle: "first",newContent: "firstContent",newTime: Date())!)
        items.append(NoteSection(newTitle: "Second",newContent: "firstContent",newTime: Date())!)
        
        return items
    }
    
    
}

