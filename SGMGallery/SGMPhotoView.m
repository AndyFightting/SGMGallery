//
//  SGMScrollView.m
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import "SGMPhotoView.h"

@implementation SGMPhotoView{
    BOOL isZoomed;
    BOOL isDoubleTap;
}

@synthesize imageView,indicatorView,singleTapDelegate;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [super setFrame:frame];
    
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.delegate = self;
    self.contentMode = UIViewContentModeCenter;
    self.maximumZoomScale = 3.0;
    self.minimumZoomScale = 1.0;
    self.decelerationRate = 0.85;
    self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.center = self.center;
    [self addSubview:indicatorView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    return self;
}

-(void)restZoom{
    isZoomed = NO;

    [self setZoomScale:self.minimumZoomScale animated:NO];
    [self zoomToRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) animated:NO];
    self.contentSize = CGSizeMake(self.frame.size.width * self.zoomScale, self.frame.size.height * self.zoomScale );
}



#pragma mark - 双击------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    //双击处理 --- 放大
    if (touch.tapCount == 2) {
        isDoubleTap = YES;
        
        if(isZoomed )
        {
            isZoomed = NO;
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
        else {
            isZoomed = YES;
            // define a rect to zoom to.
            CGPoint touchCenter = [touch locationInView:self];
            CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale, self.frame.size.height / self.maximumZoomScale );
            CGRect zoomRect = CGRectMake( touchCenter.x - zoomRectSize.width * .5, touchCenter.y - zoomRectSize.height * .5, zoomRectSize.width, zoomRectSize.height );
            
            // correct too far left
            if( zoomRect.origin.x < 0 )
                zoomRect = CGRectMake(0, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
            
            // correct too far up
            if( zoomRect.origin.y < 0 )
                zoomRect = CGRectMake(zoomRect.origin.x, 0, zoomRect.size.width, zoomRect.size.height );
            
            // correct too far right
            if( zoomRect.origin.x + zoomRect.size.width > self.frame.size.width )
                zoomRect = CGRectMake(self.frame.size.width - zoomRect.size.width, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
            
            // correct too far down
            if( zoomRect.origin.y + zoomRect.size.height > self.frame.size.height )
                zoomRect = CGRectMake( zoomRect.origin.x, self.frame.size.height - zoomRect.size.height, zoomRect.size.width, zoomRect.size.height );
            
            // zoom to it.
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches] count] == 1 ) {
        UITouch *touch = [[event allTouches] anyObject];
        if( touch.tapCount == 1 ) {
            [self performSelector:@selector(singleTaped) withObject:nil afterDelay:0.3];
        }else{
            [self performSelector:@selector(resetDoubleTap) withObject:nil afterDelay:0.6];
        }
    }
}

-(void)resetDoubleTap{
    isDoubleTap = NO;
}

-(void)singleTaped{
    if (isDoubleTap) {
        return;
    }
    if ([singleTapDelegate respondsToSelector:@selector(photoSingleTaped)]) {
        [singleTapDelegate photoSingleTaped];
    }
}

#pragma mark - scroll delegate--------
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{     
    if( self.zoomScale == self.minimumZoomScale ){
         isZoomed = NO;
    }else{
        isZoomed = YES;
    }
}

-(void)dealloc{
    imageView = nil;
    singleTapDelegate = nil;
    
    [indicatorView stopAnimating];
    indicatorView = nil;

}
@end
