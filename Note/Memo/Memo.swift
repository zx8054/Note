//
//  Memo.swift
//  Note
//
//  Created by ZhengXin on 2017/12/7.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import Foundation

class Memo{
    var content:String?
    var backgounrdImage:UIImage?
    var date:Date?
    var modifiedDate : Date?
    var length : Int = 160
    var memoID : Int = 0
    var NO : Int = 0
    
    init(newContent:String,newImage:UIImage,newDate:Date,ID:Int,modifiedTime:Date,newNo:Int){
        content = newContent
        backgounrdImage = newImage
        date = newDate
        modifiedDate = modifiedTime
        memoID = ID
        NO = newNo
        length = self.generateHeight(length: (content?.count)!)
        print("length\(length))")
    }
    
    static func getBackgroundImage()->UIImage{
        let y = arc4random() % UInt32(4) + UInt32(1)
        let x = Int(y)
        switch x {
        case 1:
            return UIImage(named:"bluePaper")!
        case 2:
            return UIImage(named:"yellowPaper")!
        case 3:
            return UIImage(named:"pinkPaper")!
        case 4:
            return UIImage(named:"whitePaper")!
        default:
            return UIImage(named:"yellowPaper")!
        }
        
        
    }
    
    func generateHeight(length:Int) -> Int{
        let a = length - 10 < 0 ? 0 : length - 10
        return 160 + a*4
    }
    
    
    
}
