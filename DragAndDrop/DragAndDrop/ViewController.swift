//
//  ViewController.swift
//  DragAndDrop
//
//  Created by  bochb on 2019/3/20.
//  Copyright © 2019 com.heron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let data = TableModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: data.cellId)
    }

    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: data.cellId, for: indexPath)
        cell.textLabel?.text = data.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0  {
            navigationController?.pushViewController(DragImageViewController(), animated: true)
        }else if indexPath.row == 1  {
            let vc = DragImageViewController()
            vc.isDroppable = true
          navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
              navigationController?.pushViewController(DragLabelViewController(), animated: true)
        }else if indexPath.row == 3  {
            navigationController?.pushViewController(DrapMoveViewController(), animated: true)
        }else if indexPath.row == 4 {
           
        }
    }
}
