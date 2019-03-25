//
//  BorderImageView.swift
//  DragAndDrop
//
//  Created by  bochb on 2019/3/20.
//  Copyright © 2019 com.heron. All rights reserved.
//

import UIKit

class BorderImageView: UIImageView {


    let textLayer: CATextLayer
    let shapeLayer: CAShapeLayer
    

    override init(frame: CGRect) {
        textLayer = CATextLayer()
        shapeLayer = CAShapeLayer()
        super.init(frame: frame)
        configureBorder()
    }

    
    func configureBorder() {
        
        shapeLayer.frame = bounds
        shapeLayer.path = UIBezierPath(rect: bounds).cgPath
        shapeLayer.fillColor = UIColor.lightGray.cgColor
        shapeLayer.borderColor = UIColor.red.cgColor
        shapeLayer.borderWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.lineDashPattern = [10, 10]
        layer.addSublayer(shapeLayer)
        
        textLayer.frame = bounds
        textLayer.font = UIFont.systemFont(ofSize: 17)
        textLayer.alignmentMode = .center
        textLayer.string = "drag here"
        textLayer.foregroundColor = UIColor.red.cgColor
        layer.addSublayer(textLayer)
    }
    
//    override func paste(itemProviders: [NSItemProvider]) {
//        
//            for dragItem in itemProviders {
//                if dragItem.canLoadObject(ofClass: UIImage.self) {
//                    dragItem.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
//                        if image != nil {
//                            DispatchQueue.main.async {
//                                self.textLayer.removeFromSuperlayer()
//                                self.shapeLayer.removeFromSuperlayer()
//                                self.image = (image as! UIImage)
//                            }
//                        }
//                    })
//                }
//            }
//        
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
