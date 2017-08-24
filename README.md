# UIViewController-Presenter
实现了将一个UIViewController从底部慢慢向上滑动显示的效果。视图完全可以自定义，比如说城市视图选择器

## 使用方法

### 默认从下往上移动展示

````
FirstViewController *firstVC = [[FirstViewController alloc] init];
[firstVC yto_presentInViewController:self];  
````

### 从某一点开始展示，然后逐渐变大

````
self.firstVC = [[FirstViewController alloc] init];
[self.firstVC yto_presentInViewController:self fromPoint:CGPointMake(0,sender.frame.origin.y+CGRectGetHeight(sender.bounds))];
````

## 效果图

![xiaoguo2.gif](http://upload-images.jianshu.io/upload_images/6644906-4f11e52114bbb61a.gif?imageMogr2/auto-orient/strip)     
![xiaoguo.gif](http://upload-images.jianshu.io/upload_images/6644906-b0f7b563cb4de0d9.gif?imageMogr2/auto-orient/strip)


