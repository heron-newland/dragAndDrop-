//
//  DragImageViewController.swift
//  DragAndDrop
//
//  Created by  bochb on 2019/3/20.
//  Copyright © 2019 com.heron. All rights reserved.
//

import UIKit

class DragImageViewController: UIViewController {
    
    var isDroppable: Bool = false
    var pasteImg: UIImageView!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureImage()
        if isDroppable {
            configurePasteImage()
        }
    }


    func configureImage() {
        img.addInteraction(drapInteraction)
    }

    
    /// 创建放置位置控件
    func configurePasteImage() {
         pasteImg = UIImageView(frame: CGRect(x: 10, y: 400, width: 300, height: 140))
        pasteImg.backgroundColor = UIColor.lightGray
        
        //设置图层之后drop不生效
//        let textLayer: CATextLayer =   CATextLayer()
//        let shapeLayer: CAShapeLayer = CAShapeLayer()
//        shapeLayer.frame = pasteImg.bounds
//        shapeLayer.path = UIBezierPath(rect: pasteImg.bounds).cgPath
//        shapeLayer.fillColor = UIColor.lightGray.cgColor
//        shapeLayer.borderColor = UIColor.red.cgColor
//        shapeLayer.borderWidth = 3
//        shapeLayer.lineCap = .round
//        shapeLayer.lineDashPattern = [10, 10]
//        pasteImg.layer.addSublayer(shapeLayer)
        
//        textLayer.frame = pasteImg.bounds
//        textLayer.font = UIFont.systemFont(ofSize: 17)
//        textLayer.alignmentMode = .center
//        textLayer.string = "drag here"
//        textLayer.foregroundColor = UIColor.red.cgColor
//        pasteImg.layer.addSublayer(textLayer)
        
        pasteImg.isUserInteractionEnabled = true
        pasteImg.addInteraction(dropInteraction)
        view.addSubview(pasteImg)
    }
    
    
    /// 配置drag
    lazy var drapInteraction: UIDragInteraction = {
        let drag = UIDragInteraction(delegate: self)
        drag.isEnabled = true
        return drag
    }()

    //配置drop
    lazy var dropInteraction: UIDropInteraction = {
        let drop = UIDropInteraction(delegate: self)
        return drop
    }()
}


extension DragImageViewController: UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let dragImage = img.image
        let itemProvider = NSItemProvider.init(object: dragImage!)
        let dragItem = UIDragItem.init(itemProvider: itemProvider)
        return [dragItem]
    }
    func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true
    }

}


// MARK: - UIDropInteractionDelegate代理方法
extension DragImageViewController: UIDropInteractionDelegate{
    //是否响应此放置目的地的放置请求
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    //以何种方式响应拖放会话行为
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        return UIDropProposal(operation: .move)
    }
    //松开手指,已经应用拖放行为后执行的操作
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) {[weak self] (obj) in
            self?.pasteImg.image = obj.last as! UIImage
        }
    }
}
