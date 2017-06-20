# AutoHeightInputView
A customized input view which can automatically update the height of input box by it's text.

![最终效果](http://upload-images.jianshu.io/upload_images/1334681-5a34cec713b2ecb4.gif?imageMogr2/auto-orient/strip)

### 要求：
- Platform: iOS8.0+ 
- Language: Swift3.1
- Editor: Xcode8.3+

### 实现：
- **xib布局**

![InputView.xib](http://upload-images.jianshu.io/upload_images/1334681-c32a09bd42139217.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- **核心代码**

**原理：当文本输入改变时，计算出当前输入文本的行数，再相应计算出view对应的高度height，然后回调到父vc中更新当前view的高度约束。**

> 1.获取输入文本的rect

```
    fileprivate var rectOfInputText: CGRect{
        let size = CGSize(width: textView.bounds.width - textView.textContainerInset.left - textView.textContainerInset.right, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = (textView.text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textView.font!], context: nil)
        
        return rect
    }
```


> 2.根据font的lineHeight计算当前输入文本的行数

```
    fileprivate var linesOfInputText: Int{
        return Int(rectOfInputText.height / textView.font!.lineHeight)
    }
```

> 3.根据输入的文本计算当前view对应的最大高度

```
 fileprivate func updateSelfHeightLayout(){
        let lines = linesOfInputText > maxiumLines ? maxiumLines : linesOfInputText

        let height = CGFloat(lines)*textView.font!.lineHeight + textView.textContainerInset.bottom + textView.textContainerInset.top + layoutMargins.top + layoutMargins.bottom
        // 回调
        callback?(.needsUpdateLayoutOfHeight, height)
    }
```

> 4.UITextViewDelegate输入改变时计算高度

```
extension InputView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        updateSelfHeightLayout() //计算高度，回调更新
    }
}
```

### 用法

![Storyboard设置](http://upload-images.jianshu.io/upload_images/1334681-037990ee8b7bc8a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
@IBOutlet weak var input: InputView!
@IBOutlet weak var inputHeightCons: NSLayoutConstraint!

override func viewDidLoad() 
{
        super.viewDidLoad()
        
// 配置方法
        input.configure(placeholder: "输入评论", actionTitle: "回复")
        {[unowned self]
            (type, info) in
            // 改变高度回调
            if type == .needsUpdateLayoutOfHeight{ 
                self.inputHeightCons.constant = info as! CGFloat
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
```
### 注意
**这个Demo我主要讲述了如何根据输入的文本内容，动态计算并更新输入框的高度，并没有加入键盘弹出相关的事件处理。**

### 简书
http://www.jianshu.com/p/ad4cbe76fed5
> 如果对你有帮助，别忘了给个star哦。
