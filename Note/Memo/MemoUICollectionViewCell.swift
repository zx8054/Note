//
//  MemoUICollectionViewCell.swift
//  Note
//
//  Created by ZhengXin on 2017/12/6.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit


protocol  MemoUICollectionViewCellDelegate  {
    func deleteMemo(_ sender:UIButton)
}

class MemoUICollectionViewCell: UICollectionViewCell {

    var delegate:MemoUICollectionViewCellDelegate? = nil
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteMemo(_ sender: UIButton) {
        if (delegate != nil){
            delegate?.deleteMemo(sender)
        }
    }
    
}
