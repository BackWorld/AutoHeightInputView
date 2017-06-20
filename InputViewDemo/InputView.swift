//
//  InputView.swift
//  InputViewDemo
//
//  Created by zhuxuhong on 2017/6/19.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit


public enum InputViewActionType: String {
    case buttonDidClick
    case editingBegan
    case editingChanged
    case editingEnded
    case returnKeyDidClick
    case needsUpdateLayoutOfHeight
}

public typealias InputViewCallback = ((_ type: InputViewActionType, _ info: Any?) -> Void)

class InputView: UIView {

// MARK: - IBOutlet
    @IBOutlet weak var placeholderLabel: UILabel!{
        didSet{
            placeholderLabel.isUserInteractionEnabled = false
            placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var actionBtn: UIButton!{
        didSet{
            actionBtn.layer.cornerRadius = 5
            setStyleOfActionBtn(enabled: false)
        }
    }
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = nil
            textView.font = UIFont.systemFont(ofSize: 15)
            textView.textColor = UIColor.darkGray
            textView.textContainerInset = UIEdgeInsetsMake(10, 6, 10, 28)
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 5
            textView.layer.borderColor = UIColor.clear.cgColor
            textView.backgroundColor = UIColor.white            
        }
    }

// MARK: - properties
    fileprivate var placeholder = "请输入内容"{
        didSet{
            placeholderLabel.text = placeholder
        }
    }
    
    public var maxiumLines = 5{
        didSet{
            if maxiumLines > 5 {
                maxiumLines = 5
            }
        }
    }
    
    fileprivate var text = ""{
        didSet{
            textView.text = text
            configureUI()
            updateSelfHeightLayout()
        }
    }
    
    fileprivate var callback: InputViewCallback?{
        didSet{
            updateSelfHeightLayout()
        }
    }
    
    public var enabled = false{
        didSet{
            textView.isEditable = enabled
        }
    }
    
// MARK: - initial method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSettings()
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
    }
    
    fileprivate func initialSettings() {
        addSubview(container)
        
    }
    
    
    
// MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
// MARK: - action & IBOutletAction
    @IBAction func actionForButtonClicked(_ sender: UIButton) {
        if sender == clearBtn {
            textView.text = nil
            configureUI()
            textViewDidChange(textView)
        }
        else if sender == actionBtn{
            callback?(.buttonDidClick, textView.text)
        }
    }
    
// MARK: - inherit method

// MARK: - private method
    fileprivate func setStyleOfActionBtn(enabled: Bool){
        actionBtn.isUserInteractionEnabled = enabled
        let bgColor = enabled ? UIColor.blue : UIColor.blue.withAlphaComponent(0.3)
        let titleColor = enabled ? UIColor.white : UIColor.white.withAlphaComponent(0.5)

        actionBtn.backgroundColor = bgColor
        actionBtn.titleLabel?.textColor = titleColor
        actionBtn.setTitleColor(titleColor, for: .normal)
    }
    
    fileprivate func updateSelfHeightLayout(){
        let lines = linesOfInputText > maxiumLines ? maxiumLines : linesOfInputText

        let height = CGFloat(lines)*textView.font!.lineHeight + textView.textContainerInset.bottom + textView.textContainerInset.top + layoutMargins.top + layoutMargins.bottom
        
        callback?(.needsUpdateLayoutOfHeight, height)
    }
    
    fileprivate func configureUI(){
        let hasNoContent = textView.text == ""
        
        placeholderLabel.text = hasNoContent ? placeholder : nil
        
        clearBtn.isHidden = hasNoContent
        
        setStyleOfActionBtn(enabled: !hasNoContent)
    }
    
// MARK: - getters
    fileprivate var rectOfInputText: CGRect{
        let size = CGSize(width: textView.bounds.width - textView.textContainerInset.left - textView.textContainerInset.right, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = (textView.text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textView.font!], context: nil)
        
        return rect
    }
    
    fileprivate var linesOfInputText: Int{
        return Int(rectOfInputText.height / textView.font!.lineHeight)
    }
    
    fileprivate lazy var container: UIView = {
        let v: UIView = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.first as! UIView
        v.frame = self.bounds
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.backgroundColor = nil
        return v
    }()
    
// MARK: - setters
    
// MARK: - delegate method
    
// MARK: - public method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    public func configure(placeholder: String, actionTitle: String, callback: InputViewCallback?){
        self.placeholder = placeholder
        self.actionBtn.setTitle(actionTitle, for: .normal)
        self.callback = callback
    }
}

extension InputView: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        configureUI()
        
        callback?(.editingBegan, textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        configureUI()
        
        callback?(.editingEnded, textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        configureUI()
        updateSelfHeightLayout()
        
        callback?(.editingChanged, textView.text)
    }
}
