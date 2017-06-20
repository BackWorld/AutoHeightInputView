//
//  ViewController.swift
//  InputViewDemo
//
//  Created by zhuxuhong on 2017/6/19.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var input: InputView!
    @IBOutlet weak var inputHeightCons: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        input.configure(placeholder: "输入评论", actionTitle: "回复")
        {[unowned self]
            (type, info) in
            if type == .needsUpdateLayoutOfHeight{
                self.inputHeightCons.constant = info as! CGFloat
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }


}

