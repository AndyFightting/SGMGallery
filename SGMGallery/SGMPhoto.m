//
//  SGMPhoto.m
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import "SGMPhoto.h"

@implementation SGMPhoto{
    
    NSString* photoString;//如果type = IsLocalType,photoString = imgName. 否则 photoString = imgURL
    NSURLConnection *photoConnection;
    NSMutableData* photoData;
    int currentIndex;

}
@synthesize photoType,photoImg,photoDelegate,imgLoaded;

-(instancetype)initWithPhotoString:(NSString*)string withPhotoType:(PhotoType)type atIndex:(int)index andDelegate:(id<SGMPhotoDelegate>)delegate{
    self = [super init];
    if (self) {
        photoString = string;
        photoType = type;
        photoDelegate = delegate;
        currentIndex = index;
    }
    return self;
}

-(void)loadPhoto{
    if (imgLoaded) {
        return;
    }
      imgLoaded = NO;
    
    if ([photoDelegate respondsToSelector:@selector(sgmPhotoWillBeginLoadAtIndex:)]) {
        [photoDelegate sgmPhotoWillBeginLoadAtIndex:currentIndex];
    }
    
    if (photoType == IsNetworkType) {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoString]];
        photoConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        photoData = [[NSMutableData alloc]init];
    }else{
        [NSThread detachNewThreadSelector:@selector(loadLoalImage) toTarget:self withObject:nil];
    }
}

#pragma mark - connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [photoData setLength:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];//状态栏左上角的小菊花
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [photoData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    photoImg = [[UIImage alloc] initWithData:photoData];
    imgLoaded = YES;
    
    if ([photoDelegate respondsToSelector:@selector(sgmPhotoDidEndLoadAtIndex:)]) {
        [photoDelegate sgmPhotoDidEndLoadAtIndex:currentIndex];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    photoConnection = nil;
    photoData = nil;
    photoString = nil;
}

-(void)loadLoalImage{
    
    NSString* path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:photoString]) {
        path = photoString;
    }else{
        path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],photoString];
    }
    photoImg = [UIImage imageWithContentsOfFile:path];
    imgLoaded = YES;
  
    if ([photoDelegate respondsToSelector:@selector(sgmPhotoDidEndLoadAtIndex:)]) {
        [photoDelegate sgmPhotoDidEndLoadAtIndex:currentIndex];
    }
}
-(void)dealloc{

    photoDelegate = nil;
    [photoConnection cancel];
    photoConnection = nil;
    photoData = nil;
    photoImg = nil;
    photoString = nil;

}

@end
