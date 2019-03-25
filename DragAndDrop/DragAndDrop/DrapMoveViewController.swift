//
//  DrapMoveViewController.swift
//  DragAndDrop
//
//  Created by  bochb on 2019/3/20.
//  Copyright © 2019 com.heron. All rights reserved.
//

import UIKit

class DrapMoveViewController: UIViewController {

    var img: UIImageView = UIImageView(frame: CGRect(x: 10, y: 80, width: 200, height: 160))
    
    private var dropPoint : CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        img.isUserInteractionEnabled = true
        view.addSubview(img)
        img.image = UIImage(named: "bannerHome")

        // Do any additional setup after loading the view.
        img.addInteraction(dragInterface)
        view.addInteraction(dropInteraction)
    }
    
    //创建拖拽行为的对象,并设置相关属性
    private lazy var dragInterface: UIDragInteraction = {
        let drag = UIDragInteraction(delegate: self)
        //在ipad是默认开启的, 在iphone时是默认关闭的, 如果关闭不能推动
        drag.isEnabled = true
        return drag
    }()
    
    private lazy var dropInteraction: UIDropInteraction = {
        let drop = UIDropInteraction(delegate: self)
        
        return drop
    }()
    

}

extension DrapMoveViewController: UIDragInteractionDelegate{
    /* 提供一个开始拖动的对象数组.
     * 如果提供的这些对象是有序的(比如说tableview的rows), 那么你也要按照这个顺序的正序来提供
     * 如果提供 一个空数组, 那么拖动不会生效
     *
     */
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if interaction.view is UIImageView{
            let imgV = interaction.view as! UIImageView
            let image = imgV.image
            let provider = NSItemProvider(object: image!)
            return [UIDragItem(itemProvider: provider)]
        }
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
//        selectedImageView = interaction.view as! UIImageView
    }
    func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true
    }
    /* Provide a preview to display while lifting the drag item.
     * Return nil to indicate that this item is not visible and should have no lift animation.
     * If not implemented, a UITargetedDragPreview initialized with interaction.view will be used.
     */
//    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview?{
//
//        let preview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 00))
//        preview.backgroundColor = UIColor.red
//
//        return UITargetedDragPreview(view: view, parameters: UIDragPreviewParameters())
//    }
}


extension DrapMoveViewController: UIDropInteractionDelegate{
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) {[weak self] (objcs) in
            
            let p = session.location(in: (self?.view)!)
            let dropImg = UIImageView(frame: .zero)
            dropImg.isUserInteractionEnabled = true
            self?.view.addSubview(dropImg)
            dropImg.center = p
            dropImg.bounds = CGRect(x: 0, y: 0, width: 200, height: 120)
            dropImg.image = objcs.last as! UIImage
            dropImg.addInteraction((self?.dragInterface)!)
            self?.img.removeFromSuperview()
            self?.img = dropImg
        }
    }
}
