# dragAndDrop-
iOS11拖拽的使用方法

在使用PC进行操作时，你一定遇到过这样的场景，可以将图片直接拖入聊天软件进行发送，可以将文档、音乐、视频文件等文件拖入相应应用程序直接进行使用。这种拖拽操作交互极大的方便了电脑的使用。在`iOS11`中，你可以在`iPhone`或`iPad`上构建这种交互体验！

拖拽操作在`iPad`上是支持跨应用程序的，你可以从一个应用中拖取项目，通过`Home`键回到主界面并且打开另一个应用程序，然后将被拖拽的项目传递给这个应用程序中。在`iPhone`上，拖拽操作只支持当前应用程序内，你可以将某个元素从一个界面拖拽到另一个，这种维度的操作可以给设计人员更大的灵活性。接下来由浅入深讲解拖拽操作的使用法法

### 拖拽源

对于拖拽操作，至少要有两个组件，一个组件作为拖拽源用来提供数据，一个组件作为拖拽目的用来接收数据，当前，同一个组件既可以是拖拽源也可以是拖拽目的。首先我们先来看拖拽源，在UIKit框架中，iOS11默认实现了一些组件可以作为拖拽源， 例如`UITextField、UITextView、UITableView`和`UICollectionView`等。文本组件默认支持拖拽操作进行文本的传递，对于列表组件则默认支持元素的拖拽。例如，在`UITextField`选中的文案中进行拖拽，可以将文字拖拽出来，效果如下图：


所有继承自UIView的控件都可以作为拖拽源，让其成为拖拽源其实也十分简单，只需要3步：

1. 创建一个UIDragInteraction行为对象。(<b style="color:gray">*并将其 `isEnabled` 属性设为`true`, 在`ipad`是默认开启的, 在`iphone`时是默认关闭的, 如果关闭不能拖拽*</b>)

2. 设置UIDragInteraction对象的代理并实现相应方法。
3. 将UIDragInteraction对象添加到指定View上。

代码如下:

1.创建拖拽行为的对象,并设置相关属性

    private lazy var dragInterface: UIDragInteraction = {
        let drag = UIDragInteraction(delegate: self)
         //在ipad是默认开启的, 在iphone时是默认关闭的, 如果关闭不能推动
        drag.isEnabled = true
        return drag
    }()
    
2.创建拖拽view(此处我使用xib创建),并为其添加拖拽行为

        lbl.addInteraction(dragInterface)

3.实现提供数据源的代理方法 UIDragInteractionDelegate

        /* 提供一个开始拖动的对象数组.
     * 如果提供的这些对象是有序的(比如说tableview的rows), 那么你也要按照这个顺序的正序来提供
     * 如果提供 一个空数组, 那么拖动不会生效
     *
     */
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    //将拖拽对象的文字作为数据源
       let text = lbl.text
        let provider = NSItemProvider(object: text! as NSItemProviderWriting)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
下面简单介绍一下实现拖拽对象使用的几个类:

#### UIDragInteraction类
所有可以接收拖拽行为的组件都必须通过这个类实现，其继承自 `UIInteraction`, 这个类中属性意义列举如下
	
	//初始化方法
    public init(delegate: UIDragInteractionDelegate)
-

    //代理
    weak open var delegate: UIDragInteractionDelegate? { get }

-
    
    /* 在拖拽开始后是否支持其他手势
     * true: 支持其他手势, 那么其他手势开始后拖拽手势会取消
     * false: 在拖拽开始后不支持其他手势
     */
    open var allowsSimultaneousRecognitionDuringLift: Bool
-
    
    /* 是否允许拖动
     * iPad默认开始, iPhone默认关闭
     */
    open var isEnabled: Bool

-
  
    /* 获取默认是否有效 不同的设备这个值将有所区别,iPad默认开始, iPhone默认关闭
     */
    open class var isEnabledByDefault: Bool { get }


#### UIDragInteractionDelegate协议
用来处理拖拽源的行为与数据。其中定义了一个必须实现的方法和许多可选实现的方法。解析如下：

	    /* 提供一个开始拖动的对象数组.
	     * 如果提供的这些对象是有序的(比如说tableview的rows), 那么你也要按照这个顺序的正序来提供
	     * 如果提供 一个空数组, 那么拖动不会生效
	     *
	     */
	    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem]

-
    
    /* 这个方法用来自定义拖拽效果的预览视图，系统默认会提供一个预览视图，不实现这个方法即是使用系统默认的
	  * 如果返回nil，则会去除预览动画.
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview?

-
    
    /* 拖拽动画即将开始
     * 可以通过 animator 改变动画,
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession)

    
如下是拖拽的声明周期回调
    
    /* 拖拽行为会话即将开始
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession)

    
    /* 是否允许数据的移动操作，需要注意，这个只有在app内有效，跨app的操作会总是复制数据
     * 默认返回true
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool

    
    /* 否允许跨应用程序进行拖拽,默认为false
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool

    
    /* 预览视图是否显示原始大小, 默认为false
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, prefersFullSizePreviewsFor session: UIDragSession) -> Bool

    
    /* 当拖拽源被移动时调用，可以用如下方法获取其坐标
     * [UIDragSession locationInView:] .
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession)

    
    /* 拖拽行为将要结束时调用.
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation)

    
    /* 拖拽行为已经结束时调用
     *
     * 如果时 UIDropOperationCopy 或者 UIDropOperationMove, 
     * 会开始数据传输并且 -dragInteraction:sessionDidTransferItems: 会被调用.
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation)

    
    /* 拖拽源进行了放置操作后调用
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, sessionDidTransferItems session: UIDragSession)

    
 添加项目到已经有现有的拖动
    
    /* 返回数据载体数组 当拖拽过程中 点击可拖拽的组件时会触发     
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, itemsForAddingTo session: UIDragSession, withTouchAt point: CGPoint) -> [UIDragItem]

    
    /* 设置允许进行拖拽中追加数据的拖拽行为会话
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, sessionForAddingItems sessions: [UIDragSession], withTouchAt point: CGPoint) -> UIDragSession?

    
    /* 将要向拖拽组件中追加数据时调用
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willAdd items: [UIDragItem], for addingInteraction: UIDragInteraction)

    
拖拽取消动画
    
    /* 拖动取消的时候调用
     * 可提供item回到拖拽原始位置的动画
     * return:
     * - defaultPreview 提供了默认还原的动画
     * - nil, 没有动画, 在原地小时
     * - [defaultPreview retargetedPreviewWithTarget:] 移动预览到其他视图
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, previewForCancelling item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview?

    
    /* 拖拽动作即将取消时调用的方法
     * 可以在此处调整动画.
     */
    optional public func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating)


### 放置目的地

拖拽源是数据的提供者，放置目的地就是数据的接收者。前面我们也实验过，将自定义的拖拽源拖拽进UITextField后，文本框中会自动填充我们提供的文本数据。同样，对于任何自定义的UIView视图，我们也可以让其成为放置目的地，需要完成如下3步：

1. 创建一个UIDropInteraction行为对象。

2. 设置UIDropInteraction对象的代理并实现协议方法。
3. 将其添加到自定义的视图中。

代码如下:

	 //配置drop
	lazy var dropInteraction: UIDropInteraction = {
	        let drop = UIDropInteraction(delegate: self)
	        return drop
	    }()
	    
	        /// 创建放置位置控件
    func configurePasteImage() {
         pasteImg = UIImageView(frame: CGRect(x: 10, y: 400, width: 300, height: 140))
        pasteImg.backgroundColor = UIColor.lightGray
        pasteImg.isUserInteractionEnabled = true
        pasteImg.addInteraction(dropInteraction)
        view.addSubview(pasteImg)
    }
    
    //UIDropInteractionDelegate代理方法   
    //是否响应此放置目的地的放置请求
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    //以何种方式响应拖放会话行为
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    //松开手指,已经应用拖放行为后执行的操作
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) {[weak self] (obj) in
            self?.pasteImg.image = obj.last as! UIImage
        }
    }
    
#### 关于UIDropInteraction类
与UIDragInteraction类类似，这个类的作用是让组件有相应放置操作的能力。其属性和方法很少, 非常简单.

#### UIDropInteractionDelegate协议
UIDropInteractionDelegate协议中所定义的方法全部是可选实现的，其用来处理用户放置交互行为。

/* 是否响应放置行为, 默认值为true
     * 放回true: 其他一些列的代理方法会被调用
     * 返回false:会略这次放置行为
     * 此方法应常用来检验此session是否包含代理能处理的items, 方法如下:`-hasItemsConformingToTypeIdentifiers:`, 		`-canLoadObjectsOfClass:`, etc.
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool

    
    /* 拖动item到放置控件内时调用
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession)

    
    /* 将item拖动到放置控件中, 并移动时会调用
     * 必须返回UIDropProposal,来指定是移动,复制,还是其他操作
     * 使用session的`-locationInView:` 方法可以做hit test.
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal

    
    /* 移出放置控件时调用
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession)

    
    /* 松开手指,已经应用拖放行为后执行的操作
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession)

    
    /* 放置动画完成后会调用这个方法
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession)

    
    /* 整个拖放行为结束后会调用
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession)

    
下面这些方法用来自定义放置动画
    
    /* 设置放置预览动画
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview?

    
    /* 这个函数每当有一个拖拽数据项放入时都会调用一次 可以进行动画
     */
    optional public func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating)
    
### 拖拽数据载体UIDragItem类

UIDragItem类用来承载要传递的数据. 其通过NSItemProvider类来进行构建，传递的数据类型是有严格规定的，必须遵守一定的协议，系统的NSString，NSAttributeString，NSURL，UIColor和UIImage是默认支持的，你可以直接传递这些数据。
UIDragItem中提供的属性方法：

	//初始化方法
    public init(itemProvider: NSItemProvider)

    //数据提供者的实例, 用来封装数据
    open var itemProvider: NSItemProvider { get }

    
    //用来传递一些关联信息
    open var localObject: Any?

    
    //为每个item提供一个自定义的预览
    open var previewProvider: (() -> UIDragPreview?)?

### UIDropSession与UIDragSession

在与拖拽交互相关的接口中，这两个是面向协议编程的绝佳范例，首先在UIKit框架中只定义了这两个协议，而并没有相关的实现类，在拖拽行为的相关回调接口中，很多id类型的参数都遵守了这个协议，我们无需知道是哪个类实现的，直接进行使用即可：


#### UIDragSession 

  	/* 设置要传递的额外信息 只有在同个APP内可见
     */
    public var localContext: Any? { get set }

#### UIDropSession

继承于UIDragDropSession(提供基础数据), NSProgressReporting(提供数据读取进度)
    
 /* 原始的dragSesstion会话 如果是跨应用的 则为nil
     */
    
    /* 设置进度的风格
     */
    public var progressIndicatorStyle: UIDropSessionProgressIndicatorStyle { get set }

    
    /* A convenience method that can be used only during the UIDropInteractionDelegate's
     * implementation of `-dropInteraction:performDrop:`.
     * Asynchronously instantiates objects of the provided class for each
     * drag item that can do so. The completion handler is called on the
     * main queue, with an array of all objects that were created, in the
     * same order as `items`.
     * The progress returned is an aggregate of the progress for all objects
     * that are loaded.
     */
    public func loadObjects(ofClass aClass: NSItemProviderReading.Type, completion: @escaping ([NSItemProviderReading]) -> Void) -> Progress

#### UIDragDropSession: 以上两个session的基类,其属性和方法如下所示

 
    
    /* session中传递的数据数组
    */
    public var items: [UIDragItem] { get }

    
    /* 当前操作行为的坐标
     */
    public func location(in view: UIView) -> CGPoint

    
    /* 此次行为是否允许移动操作
     */
    public var allowsMoveOperation: Bool { get }

    
    /* 是否支持应用程序层面的拖拽
     */
    public var isRestrictedToDraggingApplication: Bool { get }

    
    /* 验证传递的数据是否支持某个数据类型协议
     */
    public func hasItemsConforming(toTypeIdentifiers typeIdentifiers: [String]) -> Bool

    
    /* 验证传递的数据是否可以加载某个类
     */
    public func canLoadObjects(ofClass aClass: NSItemProviderReading.Type) -> Bool
    
### 交互预览类UITargetedDragPreview
UITargetedDragPreview专门用来处理拖放交互过程中的动画与预览视图

    //创建一个预览对象 
	/*
	view：要创建的预览视图 需要注意，这个视图必须在window上
	param：配置参数
	target：容器视图，用来展示预览，一般设置为view的父视图
	*/
    public init(view: UIView, parameters: UIDragPreviewParameters, target: UIDragPreviewTarget)

    

    public convenience init(view: UIView, parameters: UIDragPreviewParameters)

    
    public convenience init(view: UIView)

    //动画实施者
    open var target: UIDragPreviewTarget { get }

    //动画view
    open var view: UIView { get }

    //动画参数
    @NSCopying open var parameters: UIDragPreviewParameters { get }

    
    //预览视图的尺寸
    open var size: CGSize { get }

    
    /* 返回一个视图和尺寸一样但是target不一样的动画预览
     */
    open func retargetedPreview(with newTarget: UIDragPreviewTarget) -> UITargetedDragPreview
    
###  UIDragPreviewTarget
主要用来设置动画的起始视图与结束时回归的视图,介绍如下:

	/*
	初始化方法
	container：必须是在window上的view
	center：动画起点与终点
	transform:进行变换
	*/
    public init(container: UIView, center: CGPoint, transform: CGAffineTransform)

    public convenience init(container: UIView, center: CGPoint)

    //下面时对应的属性
    open var container: UIView { get }

    open var center: CGPoint { get }

    open var transform: CGAffineTransform { get }
    
### UIDragPreviewParameters
用来进行拖拽动画的配置，解析如下：

	
    public convenience init(textLineRects: [NSValue]) /* CGRect */

    
    //路径
    @NSCopying open var visiblePath: UIBezierPath?

    
    //背景颜色
    @NSCopying open var backgroundColor: UIColor!
    
    