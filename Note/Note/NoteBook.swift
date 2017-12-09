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
    var noteCover:UIImage?
    var noteName:String?
    var noteType:NoteType
    
    var notes = [NoteSection]()
    
    init?(photo:UIImage,str:String,type:NoteType)
    {
        if(str.isEmpty){
            return nil
        }
        
        noteCover = photo
        noteName = str
        noteType = type
    }
    
    
    
    
}
