//
//  SGMScrollView.h
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SingleTapDelegate;

@interface SGMPhotoView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,readonly)UIImageView* imageView;
@property(nonatomic,readonly)UIActivityIndicatorView* indicatorView;
@property(nonatomic,assign)id<SingleTapDelegate> singleTapDelegate;

-(id)initWithFrame:(CGRect)frame;
-(void)restZoom;

@end

@protocol SingleTapDelegate <NSObject>
@optional
-(void)photoSingleTaped;
@end
