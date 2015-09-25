# SGMGallery
本地图片或网络图片查看器。
鉴于[FGallery](https://github.com/gdavis/FGallery-iPhone)虽然可以用，但实在太难用了，一大堆没必要的代码，还不是ARC!所以从新写了一遍！更加精简更加好自定义的SGMGallery ^_^!
图片不是一次性加载，而是在滚动后才一张一张加载的。且scrollView始终只有3个View来回滚动处理，这样就不会因图片越来越多而变卡啦！欢迎使用~

```
//使用 本地图片传type = IsLocalType 网络图片 type = IsNetworkType, startIndex是0开始算的！如第二张startIndex =1;
 SGMPhotoViewController* viewVC = [[SGMPhotoViewController alloc]initWithPhotoArray:locakImgArray withPhotoType:IsLocalType startAtIndex:2];
 [self.navigationController pushViewController:viewVC animated:YES];
 ```
 ![图片](https://github.com/AndyFightting/SGMGallery/blob/master/sample.gif)
