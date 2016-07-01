//
//  textFieldCustom.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-07-01.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit


class textFieldCustom : UITextField {
    
    // Placeholder position
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let rect: CGRect = super.textRectForBounds(bounds)
        let insets: UIEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        return UIEdgeInsetsInsetRect(rect, insets)
    }
    // Text position
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let rect: CGRect = super.editingRectForBounds(bounds)
        let insets: UIEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        let a =  UIEdgeInsetsInsetRect(rect, insets)
        return a
    }
    // Clear button position
    
    override func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
        let rect: CGRect = super.clearButtonRectForBounds(bounds)
        return CGRectOffset(rect, -5, 0)
    }
    
}