//
//  SGMPhotoViewController.h
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGMPhotoView.h"
#import "SGMPhoto.h"

@interface SGMPhotoViewController : UIViewController<UIScrollViewDelegate,SingleTapDelegate,SGMPhotoDelegate>

// startIndex 是从0开始算的 ！！
-(instancetype)initWithPhotoArray:(NSArray*)array withPhotoType:(PhotoType)type startAtIndex:(int)startIndex;

@end
