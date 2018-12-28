
* 图形上下文

```
	CGContextRef context = UIGraphicsGetCurrentContext();
```

* 移动画笔

```
	CGPathMoveToPoint(<#CGMutablePathRef  _Nullable path#>, <#const CGAffineTransform * _Nullable m#>, <#CGFloat x#>, <#CGFloat y#>)
```
   
* 在画笔位置与point之间添加将要绘制线段 （在draw时才是真正绘制出来）

```
	CGPathAddLineToPoint(<#CGMutablePathRef  _Nullable path#>, <#const CGAffineTransform * _Nullable m#>, <#CGFloat x#>, <#CGFloat y#>)
```

* 画椭圆1

```
    CGPathAddEllipseInRect(<#CGMutablePathRef  _Nullable path#>, <#const CGAffineTransform * _Nullable m#>, <#CGRect rect#>)
```
* 画椭圆2

```
    CGContextFillEllipseInRect(<#CGContextRef  _Nullable c#>, <#CGRect rect#>)
```

* 设置线条末端形状

```
    CGContextSetLineCap(<#CGContextRef  _Nullable c#>, <#CGLineCap cap#>)
```
三种形状

```
typedef CF_ENUM(int32_t, CGLineCap) {
    kCGLineCapButt,
    kCGLineCapRound,
    kCGLineCapSquare
};
```
* 画虚线

```
    CGContextSetLineDash(<#CGContextRef  _Nullable c#>, <#CGFloat phase#>, <#const CGFloat * _Nullable lengths#>, <#size_t count#>)
```

*  画矩形

```
    CGContextAddRect(<#CGContextRef  _Nullable c#>, <#CGRect rect#>)
    CGContextStrokeRect(<#CGContextRef  _Nullable c#>, <#CGRect rect#>)
    CGContextStrokeRectWithWidth(<#CGContextRef  _Nullable c#>, <#CGRect rect#>, <#CGFloat width#>)
```

* 画一些线段
```
    CGContextStrokeLineSegments(<#CGContextRef  _Nullable c#>, <#const CGPoint * _Nullable points#>, <#size_t count#>)
```

*  画弧： 以(x1, y1)为圆心radius半径，startAngle和endAngle为弧度

```
CGContextAddArc(context, x1, y1, radius, startAngle, endAngle, clockwise);
```