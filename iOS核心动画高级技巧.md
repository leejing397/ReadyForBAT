### 1.UIView和CALayer的关系

* CALayer在概念上和UIView类似，同样也是一些被层级关系树，同样也可以包含一些内容（像图像、文本或者背景色），管理子图层的位置。并且它们有一些方法和属性用来做动画和变化，但是CALayer不能响应事件。

* UIView是基于CALayer的一种封装，每一个View都有一个CALayer实例的图层属性，也就是所谓的backing layer,视图的职责就是创建并管理这个图层，以确保当子视图在层级关系中添加或者被移除的时候，他们关联的图层也同样对应在层级关系树当中有相同操作。

实际上，backing laye负责屏幕上你看到的展示以及动画等。

为啥不合二为一呢？是为了分离责任，避免耦合代码，比如mac和ios俩平台需要处理的事件就不一样，Mac需要鼠标键盘等，iOS需要多触碰处理。但是界面最终的渲染可以保持一致。
事实上是<mark>4层</mark>而不是两层，除了**<mark>视图树</mark>**和**<mark>图层树</mark>**，还有**<mark>展现树(presentation tree)</mark>**，**<mark>渲染树(render tree)</mark>**这俩。

* 大多数情况我们使用UIView而不使用CALayer的原因是，首先CALayer不能响应事件，其次是CALayer不方便自动布局，最重要的是苹果已经基于CALayer封装好了UIView,我们在使用UIView高级接口的同时（比如自动排版，布局和事件处理）可可以使用CALayer的底层功能。

* 既然这里提到了层级树，顺便提一下事件响应链：

```
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIResponder * next = [self nextResponder];
    NSMutableString * prefix = @"-".mutableCopy;
    while (next != nil) {
        NSLog(@"%@%@", prefix, [next class]);
        [prefix appendString: @"--"];
        next = [next nextResponder];
    }
}
```

打印台：

```
2018-12-20 15:27:20.212371+0800 CALayerDemo[6499:282130] -UIWindow
2018-12-20 15:27:20.212579+0800 CALayerDemo[6499:282130] ---UIApplication
2018-12-20 15:27:20.212698+0800 CALayerDemo[6499:282130] -----AppDelegate
```

### 2. CALayer可以做，UIView不能做的
* 阴影、圆角、太颜色的边框
* 3D变换
* 透明遮罩
* 多级非线性动画

### 3.CALayer相关属性
* **<mark>contents</mark>**

```
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    redView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"小姐姐"].CGImage);
```
**效果图，如下：**
![](https://ws2.sinaimg.cn/large/006tNbRwly1fyd94vwm3mj30u01hcwk9.jpg)

* **<mark>contentsGravity**
 
可以类似设置`UIView`的`contentMode`一样，设置`CALayer`的`contentsGravity`

`contentMode`在`UIImageView`中使用频率最多，它有以下几种形式

```
typedef NS_ENUM(NSInteger, UIViewContentMode) {
    UIViewContentModeScaleToFill,
    UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
    UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
    UIViewContentModeTop,
    UIViewContentModeBottom,
    UIViewContentModeLeft,
    UIViewContentModeRight,
    UIViewContentModeTopLeft,
    UIViewContentModeTopRight,
    UIViewContentModeBottomLeft,
    UIViewContentModeBottomRight,
};
```

`contentsGravity`有以下取值

```
/** Layer `contentsGravity' values. **/

//图片没有做任何处理和改变，只是中心位置和图层的中心位置对齐
CA_EXTERN NSString * const kCAGravityCenter
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    
//图片没有做任何处理和改变，只是底部和图层对齐
CA_EXTERN NSString * const kCAGravityTop
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
    
//图片没有做任何处理和改变，仅顶部和图层对齐
CA_EXTERN NSString * const kCAGravityBottom
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
 
//图片本身没有改变，仅图片左边和图层左边对齐
CA_EXTERN NSString * const kCAGravityLeft
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//图片本身没有变化，仅右边和图层右边对齐
CA_EXTERN NSString * const kCAGravityRight
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//对齐左下角
CA_EXTERN NSString * const kCAGravityTopLeft
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//对齐右下角
CA_EXTERN NSString * const kCAGravityTopRight
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//对齐左上角
CA_EXTERN NSString * const kCAGravityBottomLeft
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//对齐左下角
CA_EXTERN NSString * const kCAGravityBottomRight
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);


CA_EXTERN NSString * const kCAGravityResize
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//我们可以看到kCAGravityResizeAspect枚举值时，图片比例很协调，图片会等比例缩放，如果是缩小，那么会等比例的缩小，知道整个图片能够完全放进图层。如果是放大，那么就是等比例放大，直到长和宽有一边达到图层的边界。
CA_EXTERN NSString * const kCAGravityResizeAspect
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

//这个枚举值和上面的很相似，都是等比例的缩放，不同的是这一个是，在缩小时，缩小到长和宽有一个和图层一致就停止缩小。放大时。等到长和宽都达到图层的边界就停止放大。
CA_EXTERN NSString * const kCAGravityResizeAspectFill
    CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
```

* **<mark>contentsRect**

图层的这个属性决定了显示图层的那一部分，它使用的是单位坐标
`redView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5)`就是显示图片的左上角这四分之一的区域。

```
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(10, 200, 400, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];

    redView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"小姐姐"].CGImage);
    redView.layer.contentsGravity = kCAGravityResizeAspect;
    redView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
```

![](https://ws4.sinaimg.cn/large/006tNbRwly1fyd9rybnsbj30u01hcn29.jpg)

功能2：使用大图展示不同小图

```
UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(10, 300, 200, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];

    redView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"小姐姐"].CGImage);
    redView.layer.contentsGravity = kCAGravityResize;
    redView.layer.contentsScale = [UIScreen mainScreen].scale;

    redView.layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);

    UIView *redView1 = [[UIView alloc]initWithFrame:CGRectMake(100, 150, 100, 50)];
    redView1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:redView1];
    
    redView1.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"小姐姐"].CGImage);
    redView1.layer.contentsGravity = kCAGravityResize;
    redView1.layer.contentsScale = [UIScreen mainScreen].scale;

    redView1.layer.contentsRect = CGRectMake(0.5, 0.5, 0.5, 0.5);
    redView.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
```

效果如图：
![](https://ws2.sinaimg.cn/large/006tNbRwly1fydacg7yqcj30u01hcdnv.jpg)

<mark>**好处:**
>拼合不仅给app提供了一个整洁的载入方式，还有效地提高了载入性能（单张大图比多张小图载入地更快），但是如果有手动安排的话，他们还是有一些不方便的，如果你需要在一个已经创建好的品和图上做一些尺寸上的修改或者其他变动，无疑是比较麻烦的。

>Mac上有一些商业软件可以为你自动拼合图片，这些工具自动生成一个包含拼合后的坐标的XML或者plist文件，拼合图片的使用大大简化。这个文件可以和图片一同载入，并给每个拼合的图层设置contentsRect，这样开发者就不用手动写代码来摆放位置了。

* **<mark>contentsCenter**

`contentsCenter`是一个`CGRect`，其定义了图片进行拉伸时其在图片上可拉伸的区域。

* **<mark>contentsScale**

`CALayer`的`contentsScale`属性可以用以适配`retina`屏幕，该属性值默认为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的`Retina`屏幕。

### 3.CALayer位置坐标相关的属性
对应于`UIView`的`frame`、`bounds`、`center`，`CALayer`有`frame`、`bounds`、`position`，访问`UIView`的这三个属性，返回的其实就是`CALayer`对应的这三个值。但是`CALayer`另外还有一个比较难于理解的属性`anchorPoint`。

* **<MARK>3.1 anchorPoint**

简单来说，`position`是`layer`中的`anchorPoint`点在`superLayer`中的位置坐标。因此可以说, `position`点是相对`suerLaye`r的，`anchorPoint`点是相对`layer`的，两者是相对不同的坐标空间的一个重合点。

**<mark>参考：**[这将是你最后一次纠结position与anchorPoint](http://kittenyang.com/anchorpoint/)

* **<MARK>3.2 坐标转换**

```
- (CGPoint)convertPoint:(CGPoint)p fromLayer:(nullable CALayer *)l;
- (CGPoint)convertPoint:(CGPoint)p toLayer:(nullable CALayer *)l;
- (CGRect)convertRect:(CGRect)r fromLayer:(nullable CALayer *)l;
- (CGRect)convertRect:(CGRect)r toLayer:(nullable CALayer *)l;
```

**zPosition**

`CALayer`的`zPosition`属性可以控制图层的显示顺序,但是不能改变事件传递的顺序。

* **<MARK>3.3 自动布局**

UIView有暴露出的接口`UIViewAutoresizing`和`NSLayoutConstraint`API。

### 4.变换

`CGAffineTransform`可以用来对图层旋转、摆放或者扭曲。

`CATransform3D`可以将扁平物品转化成三维空间对象。

* **<MARK>4.1 仿射变换**

仿射的意思是无论变化矩阵用什么值，图层中平行的两条线变换之后仍然保持平行。

创建一个`CGAffineTransform`，`Core Graphics`提供了一系类函数

```
CGAffineTransformMakeScale(<#CGFloat sx#>, <#CGFloat sy#>) 

CGAffineTransformMakeRotation(<#CGFloat angle#>)

CGAffineTransformTranslate(<#CGAffineTransform t#>, <#CGFloat tx#>, <#CGFloat ty#>)  
```
基本使用：

```
    UIImageView *clickImg = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 150, 150)];
    clickImg.image = [UIImage imageNamed:@"钟表"];
    [self.view addSubview:clickImg];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
    clickImg.layer.affineTransform = transform;
```
![](https://ws4.sinaimg.cn/large/006tNbRwly1fyeayrh8oyj30e90aogmq.jpg)

**<MARK>4.1.1 仿射变换_混合变化**

![](https://ws2.sinaimg.cn/large/006tNbRwly1fyebpx8ytgj30h706rjrz.jpg)

![](https://ws1.sinaimg.cn/large/006tNbRwly1fyebqiezxaj30jx06dgm2.jpg)

计算结果,由此可知
>tx：用来控制在x轴方向上的平移

>ty：用来控制在y轴方向上的平移

>a：用来控制在x轴方向上的缩放

>d：用来控制在y轴方向上的缩放

>abcd：共同控制旋转

示例：

```
UIImageView *clickImg = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 150, 150)];
clickImg.image = [UIImage imageNamed:@"钟表"];
[self.view addSubview:clickImg];
CGAffineTransform transform = CGAffineTransformIdentity;
transform = CGAffineTransformMakeScale(0.5, 0.5);
transform = CGAffineTransformMakeRotation(M_PI_2);
transform = CGAffineTransformTranslate(transform, 200, 0);
clickImg.layer.affineTransform = transform;
```
如下图：

![](https://ws2.sinaimg.cn/large/006tNbRwly1fyeb1ap1qnj30dn08sq40.jpg)

>`CGAffineTransformRotate`在已有的`transform`基础上，增加旋转效果
>`CGAffineTransformTranslate`实现以一个已经存在的形变为基准,在x轴方向上平移x单位,在y轴方向上平移y单位

* **<MARK>4.2 3D变换**

* **<MARK>4.3 固体对象**

### 5.专用图层

**<MARK>5.1 CAShapeLayer**

**<MARK>5.1.1 CAShapeLayer_图层**
使用`CAShapeLayer`最大优势就是可以单独指定每个角。

**<MARK>5.1 CATextLayer**
`Core Animation`提供了一个`CALayer`的子类`CATextLayer`。与`UILabel`相比，`CATextLayer`使用了`Core text`,渲染速度快。

```
	UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 220, 60)];
    [self.view addSubview:labelView];
    labelView.backgroundColor = [UIColor redColor];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(0, 0, 220, 60);
    textLayer.foregroundColor = [UIColor yellowColor].CGColor;
    textLayer.string = @"Hello World";
    textLayer.backgroundColor = [UIColor greenColor].CGColor;
    [labelView.layer addSublayer:textLayer];
```
![](https://ws2.sinaimg.cn/large/006tNbRwly1fyedkvqtobj30bw05jgln.jpg)

**<MARK>5.2 CATransformLayer**

主要用于构造复杂的3D事物。

**<MARK>5.3 CAGradientLayer** (Gradient:梯度)

`CAGradientLayer`是用来生成两种或者更多颜色平滑渐变的。用`Core Graphics`复制一个`CAGradientLayer`并将内容绘制到一个普通图层的寄宿图也是有可能的，但是`CAGradientLayer`的真正好处在于绘制使用了硬件加速。

<MARK>5.2.1 基础渐变</mark>

<MARK>5.2.2 多重渐变</mark>

`locations`

**<MARK>5.4 CAReplicatorLayer**

`CAReplicatorLayer`的目的是为了高效生成许多相似的图层。它会绘制一个还做个多个图层的自图层，并在每个复制体上应用不同的变化。

<MARK>5.4.1 重复图层</mark>

```
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:labelView];
    labelView.backgroundColor = [UIColor redColor];

    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = labelView.bounds;
    replicatorLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [labelView.layer addSublayer:replicatorLayer];
    
    replicatorLayer.instanceCount = 10;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 100, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0f, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -100, 0);

    replicatorLayer.instanceTransform = transform;
    replicatorLayer.instanceBlueOffset = -.1f;
    replicatorLayer.instanceGreenOffset = -0.1f;
    

    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 50, 50);
    layer.position = CGPointMake(replicatorLayer.bounds.size.width * 0.5, replicatorLayer.bounds.size.height * 0.5);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [replicatorLayer addSublayer:layer];
```

效果如图：
![](https://ws4.sinaimg.cn/large/006tNbRwly1fyeg2sj4z7j30ec0d0q39.jpg)

<MARK>5.4.1 反射</mark>

**<MARK>5.4 CAScrollLayer**

`CAScrollLayer`的属性和方法

```
- (void)scrollToPoint:(CGPoint)p;
- (void)scrollToRect:(CGRect)r;
@property(copy) NSString *scrollMode;
```

`scrollToPoint:`方法从图层树中查找并找到第一个可用的`CAScrollLayer`，然后滑动它使得指定点成为可视的。

`scrollToRect:`方法实现了同样的事情，只不过是作用在一个矩形上的。

设置`scrollMode`为两个方向均可滚动，来允许向各个方向滚动，也可以限制只能在一个方向上滚动。

**<MARK>5.5 CATiledLayer**

`CATiledLayer`为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片，然后将他们单独按需载入。

**<MARK>5.6 CAEmitterLayer**

`CAEmitterLayer `是一个高性能的粒子引擎，被用来创建实时粒子动画，如烟雾、火、雨等这些效果。

**<MARK>5.7 CAEAGLLayer**

**<MARK>5.8 AVPlayerLayer**

### 6.隐式动画

[苹果官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/ReactingtoLayerChanges/ReactingtoLayerChanges.html#//apple_ref/doc/uid/TP40004514-CH7-SW1)

隐式动画指我们没有指定任何动画类型，只是概改变了layer的属性，有框架自动完成动画效果，默认持续时间0.24秒；但是只有非rootLayer（自己创建的）才有隐式动画。

**<MARK>6.1 隐式动画_事务**

事务是通过`CATransaction`类来做管理，这个类的设计有些奇怪，不像你从它的命名预期那样去管理一个简单的事务，而是管理了一叠你不能访问的事务。`CATransaction`没有属性或者实例方法，并且也不能用`+alloc`和`-init`方法创建它。但是可以使用`+begin`和`+commit`分别来入栈或者出栈。

任何可以做动画的图层属性都会被添加到栈顶的事务，你可以通过`setAnimationDuration`方法设置当前事务的动画时间，或者通过`animationDuration`方法来获取值（默认0.25秒）。

`Core Animation`在每个`run loop`周期中自动开始一次新的事务（`run loop`是iOS负责收集用户输入、处理定时器或者网络事件并且重新绘制屏幕的东西），即使你不显示的用`[CATransaction begin]`开始一次事务，任何一次`run loop`循环中属性的改变都会被集中起来，然后做一次0.25秒的动画。

```
	UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:labelView];
    labelView.backgroundColor = [UIColor redColor];
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = labelView.bounds;
    colorLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [labelView.layer addSublayer:colorLayer];
    self.colorLayer = colorLayer;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 70, 40, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(didClickLayerColor:) forControlEvents:UIControlEventTouchUpInside];
```

```
- (void)didClickLayerColor:(UIButton *)button {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    
    CGFloat red = arc4random() / INT_MAX;
    CGFloat green = arc4random() / INT_MAX;
    CGFloat yellow = arc4random() / INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:yellow alpha:1.0f].CGColor;
    [CATransaction commit];
}
```
**<MARK>6.2 隐式动画_完成块**

```
- (void)didClickLayerColor:(UIButton *)button {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    [CATransaction setCompletionBlock:^{
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformScale(transform, 1.2, 1.2);
        self.colorLayer.affineTransform = transform;
    }];
    
    CGFloat red = arc4random() / INT_MAX;
    CGFloat green = arc4random() / INT_MAX;
    CGFloat yellow = arc4random() / INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:yellow alpha:1.0f].CGColor;
    [CATransaction commit];
}

```
**<MARK>6.3 隐式动画_图层行为**

```
	UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:labelView];
    labelView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.redView = labelView;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 70, 40, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(didClickLayerColor1:) forControlEvents:UIControlEventTouchUpInside];
```
```
- (void)didClickLayerColor1:(UIButton *)button {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
    CGFloat red = arc4random() / INT_MAX;
    CGFloat green = arc4random() / INT_MAX;
    CGFloat yellow = arc4random() / INT_MAX;
    
    self.redView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:yellow alpha:1.0f].CGColor;
    [CATransaction commit];
}
```
运行程序，当你按下按钮，图层颜色瞬间切换到新值，而不是之前平滑过渡的动画；这发生了什么？隐式动画好像被`UIView`关联层给禁用了。

试想一下，如果`UIView`的属性都有动画特性的话，那么无论在什么时候修改它，我们都应该能注意到的。所以，如果说`UIKit`建立在`Core Animation`(默认对所有东西都做动画)之上，那么饮食动画是如何被`UIKit`禁用掉呢？

我们知道`Core Animation`通常对`CALayer`的所有属性（可动画的属性）做动画，但是`UIView`把它关联的图层的这个特性关掉了。为了更好的说明这一点，我们需要知道隐式动画是如何实现的。

我们把改变属性时`CALayer`自动应用的动画称作<mark>行为</mark>,当`CALayer`的属性被修改的时候，它会调用`- (nullable id<CAAction>)actionForKey:(NSString *)event;`方法，传递属性的名称。剩下的操作在`CALayer`的头文件中有详细的说明，实际上是如下几步：
>
* 图层首先监测它是否有委托，并且是否实现`CALayerDelegate`协议指定的`- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;`方法，如果有，直接调用并返回结果。
* 如果没有委托，或者委托没有实现`- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;`方法，图层接着检查包含属性名称对应行为映射的`actions`字典。
* 如果actions字典没有包含对应的属性，那么图层接着在他的style字典接着搜索属性名。
* 最后，如果在style中也找不到对应的行为，那么图层将会直接调用定义了每一个属性的标准行为的`+ (nullable id<CAAction>)defaultActionForKey:(NSString *)event;`方法。

所以一轮完整的搜索结束之后，`actionForKey:`要不返回空（这种情况不会有动画发生），要么是`CAAction `协议对应的对象，最后CALayer那个这个结果去和先前和当前的值做动画。

这就解释了UIKit是如何禁用隐式动画的：
>每一个UIView对它关联的图层都扮演了一个委托，并且提供了`- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;`实现方法。当不在一个动画块的实现中，UIView对所有图层行为返回nil，但是在动画block范围之内，它就返回了一个非空值。

```
	UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:labelView];
    labelView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.redView = labelView;
    NSLog(@"外边：%@",[labelView actionForLayer:labelView.layer forKey:@"backgroundColor"]);
    [UIView beginAnimations:nil context:nil];
    NSLog(@"里面：%@",[labelView actionForLayer:labelView.layer forKey:@"backgroundColor"]);
```

打印结果：

```
外边：<null>
里面：<CABasicAnimation: 0x60400003b880>
```
于是我们可以预言，当属性在动画块之外发生改变，`UIView`直接通过返回`nil`来禁用隐式动画。但如果在动画块范围之内，根据动画具体类型返回相应的属性，在这个例子就是`CABasicAnimation`。

还没有看懂，那么我们自定义View,继承自UIView，仅仅重写`- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event`方法

```
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    
    id <CAAction> action = [super actionForLayer:layer forKey:event];
    NSLog(@"layer=%@,Key=%@,action=%@",layer,event,action);
    return action;
}
```

在ViewController中使用

```
    GXYinshiView *yinshiView = [[GXYinshiView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:yinshiView];
    yinshiView.backgroundColor = [UIColor redColor];
    self.redView = yinshiView;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 70, 40, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(didClickLayerColor2:) forControlEvents:UIControlEventTouchUpInside];
```

```
- (void)didClickLayerColor2:(UIButton *)button {
    [UIView animateWithDuration:2.0f animations:^{
        self.redView.alpha = 0.5f;
    }];
}
```

可以发现，此时，`GXYinshiView`中的`actionForLayer:forKey:`方法被多次调用，产生了这样的输出：

```
2018-12-24 11:29:45.695897+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=bounds,action=<null>
2018-12-24 11:29:54.441640+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=opaque,action=<null>
2018-12-24 11:29:59.323145+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=position,action=<null>
2018-12-24 11:30:04.202908+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=backgroundColor,action=<null>
2018-12-24 11:30:08.274482+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=opaque,action=<null>
2018-12-24 11:30:09.535508+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=onOrderIn,action=<null>
2018-12-24 11:30:17.773029+0800 CALayerDemo[12469:2179819] layer=<CALayer: 0x60400003e320>,Key=opacity,action=<CABasicAnimation: 0x60000022a4e0>
```

`<null>`是`[NSNull null]`的输出。说明对于其他的几种`key`，`UIView`对象告诉它的`layer`，停止对`CAAction`对象的搜索。而对`opacity`这个`key`，`UIView`对象则给出了一个`CABasicAnimation`对象。

**<MARK>6.4 隐式动画_呈现与模型**

<mark>呈现树</mark>通过图层树中所有图层的呈现图层形成。注意呈现图层仅仅当图层首次被提交（就是首次第一次在屏幕上显示）的时候创建，所以之前调用`- (nullable instancetype)presentationLayer`方法将会返回`nil`。

我们还注意到一个`- (instancetype)modelLayer;`方法。在呈现图层上调用`- (instancetype)modelLayer;`将会返回他正在呈现所以来的`CALayer`。通常在一个图层上调用`- (instancetype)modelLayer;`会返回`self`（实际上我们已经创建的原始图层就是一种数据模型）。

### 7.显式动画
![](https://ws4.sinaimg.cn/large/006tNbRwly1fyhsuoyhibj30wu06wdgt.jpg)

**<MARK>7.1 显式动画_属性动画**

**<MARK>7.1.1 显式动画_属性动画_基础动画**

`CABasicAnimation`继承于`CAPropertyAnimation`，并添加了如下属性：

属性  | 解释
------------- | -------------
fromValue  | 所改变属性的起始值
toValue | 所改变属性的结束值
byValue | 所改变属性相同起始值的改变量

它们被定义成`id`类型而不是一些具体的类型是因为属性动画可以用作很多不同种的属性类型，包括<mark>数字类型</mark>，<mark>矢量</mark>，<mark>变换矩阵</mark>，甚至是<mark>颜色</mark>或者<mark>图片</mark>。

```
 	UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:labelView];
    labelView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.redView = labelView;
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = labelView.bounds;
    colorLayer.backgroundColor = [UIColor yellowColor].CGColor;
    self.colorLayer = colorLayer;
    
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    colorLayer.actions = @{@"backgroundColor":transition};
    [labelView.layer addSublayer:colorLayer];

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 70, 40, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"点我3" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(didClickLayerColor3:) forControlEvents:UIControlEventTouchUpInside];
```

```
- (void)didClickLayerColor3:(UIButton *)button {
    CGFloat red = arc4random() / INT_MAX;
    CGFloat green = arc4random() / INT_MAX;
    CGFloat yellow = arc4random() / INT_MAX;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:yellow alpha:1.0f];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id _Nullable)(color.CGColor);
    animation.delegate = self;
    [self.colorLayer addAnimation:animation forKey:nil];
}
```
>运行程序，结果有点差强人意，点击按钮，的确可以使图层动画过渡到一个新的颜色，然动画结束之后又立刻变回原始值。

>这是因为动画并没有改变图层的模型，而只是呈现。一旦动画结束并从图层上移除之后，图层就立刻恢复到之前定义的外观状态。我们从没改变过`backgroundColor`属性，所以图层就返回到原始的颜色。

>当之前在使用隐式动画的时候，实际上它就是用例子中`CABasicAnimation`来实现的（回忆一下，我们在`-actionForLayer:forKey:`委托方法打印出来的结果就是`CABasicAnimation`）。但是在那个例子中，我们通过设置属性来打开动画。在这里我们做了相同的动画，但是并没有设置任何属性的值（这就是为什么会立刻变回初始状态的原因）。

>把动画设置成一个图层的行为（然后通过改变属性值来启动动画）是到目前为止同步属性值和动画状态最简单的方式了，假设由于某些原因我们不能这么做（通常因为UIView关联的图层不能这么做动画），那么有两种可以更新属性值的方式：<mark>在动画开始之前</mark>或者<mark>动画结束之后</mark>。

<mark>在动画开始之前</mark>
![](https://ws4.sinaimg.cn/large/006tNbRwly1fyhtq9hx75j30qb0aiwhx.jpg)

> 这的确是可行的，但还是有些问题，如果这里已经正在进行一段动画，我们需要从呈现图层那里去获得`fromValue`，而不是模型图层。另外，由于这里的图层并不是`UIView`关联的图层，我们需要用`CATransaction`来禁用隐式动画行为，否则默认的图层行为会干扰我们的显式动画（实际上，显式动画通常会覆盖隐式动画，但在文章中并没有提到，所以为了安全最好这么做）。

```
#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
}
```

再来做一个心跳的感觉吧

```
    UIView *heartView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 30, 30)];
    
    [self.view addSubview:heartView];
    
    heartView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"心跳"].CGImage);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:heartView.layer.bounds];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50.0f)];
    animation.repeatCount = HUGE;
    animation.duration = 0.5f;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    [heartView.layer addAnimation:animation forKey:@"heartJamp1"];
```
![](https://ws1.sinaimg.cn/large/006tNbRwly1fyhuykxcsrg30ee0q80u2.gif)

**<MARK>7.1.2 显式动画——属性动画——关键帧动画**

`CAKeyframeAnimation`是另一种UIKit没有暴露出来单功能强大的类。和 `CABasicAnimation`类似，`CAKeyframeAnimation`同样是 `CAPropertyAnimation`的一个子类，它依然作用于单一的一个属性，但是和 `CABasicAnimation`不一样的是，它不限制于设置一个起始和结束的值，而是可以根据一连串随意的值来做动画。

```
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:labelView];
//    labelView.layer.backgroundColor = [UIColor redColor].CGColor;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.duration = 2.0f;
    anim.values = @[
                    (__bridge id)[UIColor blueColor].CGColor,
                    (__bridge id)[UIColor redColor].CGColor,
                    (__bridge id)[UIColor greenColor].CGColor,
                    (__bridge id)[UIColor blueColor].CGColor ];
    
    [labelView.layer addAnimation:anim forKey:nil];
```

注意到序列中开始和结束的颜色都是蓝色，这是因为`CAKeyframeAnimation`并不能自动把当前值作为第一帧（就像`CABasicAnimation`那样把`fromValue`设为`nil`）。动画会在开始的时候突然跳转到第一帧的值，然后在动画结束的时候突然恢复到原始的值。所以为了动画的平滑特性，我们需要开始和结束的关键帧来匹配当前属性的值。

当然可以创建一个结束和开始值不同的动画，那样的话就需要在动画启动之前手动更新属性和最后一帧的值保持一致，就和之前讨论的一样。

我们用`duration`属性把动画时间从默认的0.25秒增加到2秒，以便于动画做的不那么快。运行它，你会发现动画通过颜色不断循环，但效果看起来有些奇怪。原因在于动画以一个恒定的步调在运行。当在每个动画之间过渡的时候并没有减速，这就产生了一个略微奇怪的效果，为了让动画看起来更自然，我们需要调整一下缓冲，第十章将会详细说明。

提供一个数组的值就可以按照颜色变化做动画，但一般来说用数组来描述动画运动并不直观。`CAKeyframeAnimation`有另一种方式去指定动画，就是使用`CGPath`。`path`属性可以用一种直观的方式，使用`Core Graphics`函数定义运动序列来绘制动画。

我们来用一个宇宙飞船沿着一个简单曲线的实例演示一下。为了创建路径，我们需要使用一个三次贝塞尔曲线，它是一种使用开始点，结束点和另外两个控制点来定义形状的曲线，可以通过使用一个基于C的`Core Graphics`绘图指令来创建，不过用`UIKit`提供的`UIBezierPath`类会更简单。

我们这次用`CAShapeLayer`来在屏幕上绘制曲线，尽管对动画来说并不是必须的，但这会让我们的动画更加形象。绘制完`CGPath`之后，我们用它来创建一个`CAKeyframeAnimation`，然后用它来应用到我们的宇宙飞船。

```
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    [bezierPath moveToPoint:CGPointMake(30, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor blueColor].CGColor;
    layer.strokeColor = [UIColor yellowColor].CGColor;
    layer.lineWidth = 3.0f;
    [self.view.layer addSublayer:layer];
    
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(30, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"心跳"].CGImage;
    [self.view.layer addSublayer:shipLayer];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    [shipLayer addAnimation:animation forKey:nil];
```

运行示例，你会发现飞船的动画有些不太真实，这是因为当它运动的时候永远指向右边，而不是指向曲线切线的方向。你可以调整它的`affineTransform`来对运动方向做动画，但很可能和其它的动画冲突。

幸运的是，苹果预见到了这点，并且给`CAKeyFrameAnimation`添加了一个`rotationMode`的属性。设置它为常量`kCAAnimationRotateAuto`，图层将会根据曲线的切线自动旋转。

```
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    [shipLayer addAnimation:animation forKey:nil];
```

**<MARK>7.2 显式动画_组动画**

`CABasicAnimation`和`CAKeyframeAnimation`仅仅作用于单独的属性，而`CAAnimationGroup`可以把这些动画组合在一起。`CAAnimationGroup`是另一个继承于`CAAnimation`的子类，它添加了一个`animations`数组的属性，用来组合别的动画。

**<MARK>7.3 显式动画——过渡**

有时候对于iOS应用程序来说，希望能通过属性动画来对比较难做动画的布局进行一些改变。比如交换一段文本和图片，或者用一段网格视图来替换，等等。属性动画只对图层的可动画属性起作用，所以如果要改变一个不能动画的属性（比如图片），或者从层级关系中添加或者移除图层，属性动画将不起作用。

于是就有了<mark>过渡</mark>的概念。<mark>过渡</mark>并不像属性动画那样平滑地在两个值之间做动画，而是影响到整个图层的变化。过渡动画首先展示之前的图层外观，然后通过一个交换过渡到新的外观。

为了创建一个过渡动画，我们将使用`CATransition`，同样是另一个`CAAnimation`的子类，和别的子类不同，`CATransition`有一个`type`和`subtype`来标识变换效果。`type`属性是一个`NSString`类型，可以被设置成如下类型：
>
* kCATransitionFade 
* kCATransitionMoveIn 
* kCATransitionPush 
* kCATransitionReveal

到目前为止你只能使用上述四种类型，但你可以通过一些别的方法来自定义过渡效果，后续会详细介绍。

默认的过渡类型是`kCATransitionFade`，当你在改变图层属性之后，就创建了一个平滑的淡入淡出效果。

`kCATransitionMoveIn`和`kCATransitionReveal`与`kCATransitionPush`类似，都实现了一个定向滑动的动画，但是有一些细微的不同，`kCATransitionMoveIn`从顶部滑动进入，但不像推送动画那样把老图层推走，然而`kCATransitionReveal`把原始的图层滑动出去来显示新的外观，而不是把新的图层滑动进入。

后面三种过渡类型都有一个默认的动画方向，它们都从左侧滑入，但是你可以通过`subtype`来控制它们的方向，提供了如下四种类型：
> * kCATransitionFromRight 
* kCATransitionFromLeft 
* kCATransitionFromTop 
* kCATransitionFromBottom 

```
@interface ViewController ()
@property (nonatomic,copy) NSArray *imgsArray;
@property (nonatomic,weak) UIImageView *imgView;
@end
```

```
    self.imgsArray = @[[UIImage imageNamed:@"小姐姐"],
                       [UIImage imageNamed:@"心跳"]];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小姐姐"]];
    [self.view addSubview:imgView];
    imgView.frame = CGRectMake(100, 100, 100, 100);
    self.imgView = imgView;
    
    UIButton *changeImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, 50, 50)];
    [self.view addSubview:changeImgBtn];
    [changeImgBtn setBackgroundColor:[UIColor redColor]];
    [changeImgBtn addTarget:self action:@selector(didClickChangeImgBtn) forControlEvents:UIControlEventTouchUpInside];
```

```
- (void)didClickChangeImgBtn {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    [self.imgView.layer addAnimation:transition forKey:nil];
    UIImage *img = self.imgView.image;
    NSUInteger index = [self.imgsArray indexOfObject:img];
    index = (index + 1) % self.imgsArray.count;
    self.imgView.image = self.imgsArray[index];

}
```
![](https://ws3.sinaimg.cn/large/006tNbRwly1fyipx4hqvug30ao0jstb3.gif)

**<MARK>7.3.1 显式动画——过渡_隐式过渡**

**<MARK>7.3.2 显式动画——过渡_对图层树的动画**

**<MARK>7.3.3 显式动画——过渡_自定义动画**

过渡动画的基础原则是对原始图层外观截图，然后添加一段动画，平滑过渡到图层改变之后那个截图的效果。

**<MARK>7.3.4 显式动画——过渡_在动画过程中取消动画**
一般来说，动画在结束之后被自动移除，除非设置了`removedOnCompletion`为`NO`,如果你设置动画在结束之后不被自动移除，那么当它不需要的时候你需要手动移除它；否则它会一直存在于内存中，知道图层被销毁。

### 8.图层时间

**<MARK>8.1 图层时间_CAMediaTiming**

`CAMediaTiming`协议定义了在一段时间内用来控制逝去时间的属性的集合，`CALayer`和`CAAnimation`都实现了这个协议，所以时间可以被任意基于一个图层或者一段动画的类控制。

**<MARK>8.1.1 图层时间_CAMediaTiming——持续和重复**

`duration`

`repeatCount`

**<MARK>8.1.2 图层时间_CAMediaTiming——相对时间**