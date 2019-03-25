//
//  DragLabelViewController.swift
//  DragAndDrop
//
//  Created by  bochb on 2019/3/20.
//  Copyright © 2019 com.heron. All rights reserved.
//
//uitextfield等可编辑容器,会自动接收拖拽的文字对象
import UIKit

class DragLabelViewController: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var pasteTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建拖拽view(此处我使用xib创建),并为其添加拖拽行为
        lbl.addInteraction(dragInterface)
//        pasteTf.pasteConfiguration = UIPasteConfiguration(forAccepting: NSString.self)
    }
    //创建拖拽行为的对象,并设置相关属性
    private lazy var dragInterface: UIDragInteraction = {
        let drag = UIDragInteraction(delegate: self)
         //在ipad是默认开启的, 在iphone时是默认关闭的, 如果关闭不能推动
        drag.isEnabled = true
        return drag
    }()
    
}

extension DragLabelViewController: UIDragInteractionDelegate{
    /* 提供一个开始拖动的对象数组.
     * 如果提供的这些对象是有序的(比如说tableview的rows), 那么你也要按照这个顺序的正序来提供
     * 如果提供 一个空数组, 那么拖动不会生效
     *
     */
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
       let text = lbl.text
        let provider = NSItemProvider(object: text! as NSItemProviderWriting)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
}
