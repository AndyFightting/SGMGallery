//
//  SGMPhoto.h
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SGMPhotoDelegate;

typedef NS_ENUM(NSInteger, PhotoType) {
    IsLocalType,
    IsNetworkType
};

@interface SGMPhoto : NSObject<NSURLConnectionDataDelegate>

@property PhotoType photoType;
@property (nonatomic,retain)UIImage* photoImg;
@property (nonatomic,assign)id<SGMPhotoDelegate> photoDelegate;
@property BOOL imgLoaded;

-(instancetype)initWithPhotoString:(NSString*)string withPhotoType:(PhotoType)type atIndex:(int)index andDelegate:(id<SGMPhotoDelegate>)delegate ;
-(void)loadPhoto;
@end

@protocol SGMPhotoDelegate <NSObject>
@required
-(void)sgmPhotoWillBeginLoadAtIndex:(int)index;
-(void)sgmPhotoDidEndLoadAtIndex:(int)index;
@end
