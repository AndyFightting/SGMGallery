//
//  SGMPhotoViewController.m
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import "SGMPhotoViewController.h"
#define scrollWidth [UIScreen mainScreen].bounds.size.width
#define scrollHeight [UIScreen mainScreen].bounds.size.height
#define bottomViewHeight 45


@interface SGMPhotoViewController ()

@end

@implementation SGMPhotoViewController{

    int currentIndex;//从0开始
    int totalCount;//总数
    PhotoType photoType;
    
    UIScrollView* mainScroll;//scrollView中始终只有3个containerView在轮回处理
    NSMutableArray* containerViewArray;
    
    NSMutableArray* photoStringArray;//如果photoType = IsLocalType,  string = imgName. 否则 string = imgURL
    NSMutableArray* photoViewArray;
    NSMutableArray* photoArray;
    
    BOOL isFullScreen;//是不是全屏，即隐藏导航栏和底部栏
    UIView* bottomView;
}

-(instancetype)initWithPhotoArray:(NSArray*)array withPhotoType:(PhotoType)type startAtIndex:(int)startIndex{
    
    self = [super init];
    if (self) {
        photoStringArray = [[NSMutableArray alloc]initWithArray:array];
        photoViewArray = [[NSMutableArray alloc]initWithArray:array];
        photoArray = [[NSMutableArray alloc]initWithArray:array];
        
        photoType = type;
        currentIndex = startIndex;
        totalCount = (int)photoStringArray.count;
        
        if (currentIndex<0) {
            currentIndex = 0;
        }else if (currentIndex>=totalCount) {
            currentIndex = totalCount-1;
        }
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = [NSString stringWithFormat:@"%d%@%d",currentIndex+1,@"/",totalCount];
    
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
    mainScroll.delegate = self;
    mainScroll.pagingEnabled = YES;
    mainScroll.showsHorizontalScrollIndicator = NO;
    [mainScroll setContentSize:CGSizeMake(scrollWidth*3, scrollHeight)];
    [self.view addSubview:mainScroll];
    
    //-----生成scrollView的containerView
    UIView* view0 = [[UIView alloc]init];
    UIView* view1 = [[UIView alloc]init];
    UIView* view2 = [[UIView alloc]init];
    
    containerViewArray = [[NSMutableArray alloc]init];
    [containerViewArray addObject:view0];
    [containerViewArray addObject:view1];
    [containerViewArray addObject:view2];
    
    for (int i=0; i<containerViewArray.count; i++) {
        UIView* tmpView = [containerViewArray objectAtIndex:i];
        [tmpView setFrame:CGRectMake(scrollWidth*i, 0, scrollWidth, scrollHeight)];
        [mainScroll addSubview:tmpView];
    }
    [mainScroll setContentOffset:CGPointMake(scrollWidth, 0)];
    if (totalCount == 1) {
        mainScroll.scrollEnabled = NO;
    }
    
    //初始化3个图片
    [self resetContainerView:1 withPhotoView:currentIndex];
    if (currentIndex-1>=0) {
        [self resetContainerView:0 withPhotoView:currentIndex-1];
    }if (currentIndex+1<totalCount) {
        [self resetContainerView:2 withPhotoView:currentIndex+1];
    }
    
    //---bottomView
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollHeight-bottomViewHeight, scrollWidth, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self.view addSubview:bottomView];
    
    UILabel* tmpLabel = [[UILabel alloc]initWithFrame:bottomView.bounds];
    tmpLabel.text = @"   要在这放东西吗？";
    tmpLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:tmpLabel];
    
    
}

-(void)resetContainerView:(int)viewIndex withPhotoView:(int)photoIndex{
    
    if (viewIndex<0||viewIndex>2||photoIndex<0||photoIndex>=totalCount) {
        return;
    }

    UIView* containerView = [containerViewArray objectAtIndex:viewIndex];
    for (UIView* sbView in containerView.subviews) {
        [sbView removeFromSuperview];
    }

    SGMPhotoView* photoView;
    SGMPhoto* photo;
    if ([[photoViewArray objectAtIndex:photoIndex] isKindOfClass:[SGMPhotoView class]]) {
        photoView = [photoViewArray objectAtIndex:photoIndex];
        photo = [photoArray objectAtIndex:photoIndex];
    }else{
        photoView = [[SGMPhotoView alloc]initWithFrame:containerView.bounds];
        photoView.singleTapDelegate = self;//图片单击代理
        photo = [[SGMPhoto alloc]initWithPhotoString:[photoStringArray objectAtIndex:photoIndex] withPhotoType:photoType atIndex:photoIndex andDelegate:self];
        
        [photoViewArray replaceObjectAtIndex:photoIndex withObject:photoView];
        [photoArray replaceObjectAtIndex:photoIndex withObject:photo];
    }
    [photo loadPhoto];//启动加载图片，每个photoView只会第一次加载 -- 加载开始和结束 有代理方法
    [containerView addSubview:photoView];
    
}
#pragma mark - 加载图片代理
-(void)sgmPhotoWillBeginLoadAtIndex:(int)index{
    
   SGMPhotoView* photoView = [photoViewArray objectAtIndex:index];
   [photoView.indicatorView startAnimating];
    
}
-(void)sgmPhotoDidEndLoadAtIndex:(int)index{
    
    SGMPhotoView* photoView = [photoViewArray objectAtIndex:index];
    SGMPhoto* photo = [photoArray objectAtIndex:index];
    [photoView.indicatorView stopAnimating];
    photoView.imageView.image =photo.photoImg;
    
}
#pragma mark - 图片单击代理
-(void)photoSingleTaped{
    if (isFullScreen) {
        [self exitFullscreen];
    }else{
        [self enterFullscreen];
    }
    isFullScreen = !isFullScreen;
}
-(void)enterFullscreen{
   [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    [UIView animateWithDuration:0.2 animations:^{
        bottomView.frame = CGRectMake(0, scrollHeight, scrollWidth, bottomViewHeight);
    }];
    
}
-(void)exitFullscreen{
   [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        bottomView.frame = CGRectMake(0, scrollHeight-bottomViewHeight, scrollWidth, bottomViewHeight);
    }];
}
#pragma mark - scroll delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == mainScroll) {
        
        float offsetX = scrollView.contentOffset.x;
        long toIndex = offsetX / scrollWidth;
        
        if (toIndex > 1) {//手指往左边滑动结束
            [self slipLeftFinished];
        }
        if (toIndex < 1) {//手指往右边滑动结束
            [self slipRightFinished];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == mainScroll) {
        if (currentIndex == 0) {
            if (scrollView.contentOffset.x<scrollWidth) {
                mainScroll.scrollEnabled = NO;
                [mainScroll setContentOffset:CGPointMake(scrollWidth, 0)];
            }else{
                mainScroll.scrollEnabled = YES;
            }
        }else if(currentIndex == totalCount-1){
            if (scrollView.contentOffset.x>scrollWidth) {
                mainScroll.scrollEnabled = NO;
                [mainScroll setContentOffset:CGPointMake(scrollWidth, 0)];
            }else{
                mainScroll.scrollEnabled = YES;
            }
        }
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    mainScroll.scrollEnabled = YES;
}

-(void)slipLeftFinished{
    currentIndex =currentIndex+ 1;
    
    for (UIView* tmpView in containerViewArray) {//三个containverView全部左移
            CGRect frame = tmpView.frame;
            frame.origin.x -= scrollWidth;
            [tmpView setFrame:frame];
    }
    [mainScroll setContentOffset:CGPointMake(scrollWidth, 0)];//居中
    
    UIView* view0 = [containerViewArray objectAtIndex:0];
    [view0 setFrame:CGRectMake(scrollWidth*2, 0, scrollWidth, scrollHeight)];
    
    [containerViewArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
    [containerViewArray exchangeObjectAtIndex:2 withObjectAtIndex:1];
    
    self.title = [NSString stringWithFormat:@"%d%@%d",currentIndex+1,@"/",totalCount];
    [self resetContainerView:2 withPhotoView:currentIndex+1];//放置右边图片
    
    //---重置左边的图片尺寸
    SGMPhotoView* leftPhotoView = [photoViewArray objectAtIndex:currentIndex-1];
    [leftPhotoView restZoom];
    
    
}

-(void)slipRightFinished{
    currentIndex =currentIndex- 1;
    
    for (UIView* tmpView in containerViewArray) {//三个containverView全部右移
        CGRect frame = tmpView.frame;
        frame.origin.x += scrollWidth;
        [tmpView setFrame:frame];
    }
    [mainScroll setContentOffset:CGPointMake(scrollWidth, 0)];//居中
    
    UIView* view2 = [containerViewArray objectAtIndex:2];
    [view2 setFrame:CGRectMake(scrollWidth*0, 0, scrollWidth, scrollHeight)];
    
    [containerViewArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
    [containerViewArray exchangeObjectAtIndex:1 withObjectAtIndex:2];
    
    self.title = [NSString stringWithFormat:@"%d%@%d",currentIndex+1,@"/",totalCount];
    [self resetContainerView:0 withPhotoView:currentIndex-1];//放置左边图片
    
    //---重置右边的图片尺寸
    SGMPhotoView* rightPhotoView = [photoViewArray objectAtIndex:currentIndex+1];
    [rightPhotoView restZoom];
}
-(void)dealloc{
    
    [photoStringArray removeAllObjects];
    [containerViewArray removeAllObjects];
    [photoViewArray removeAllObjects];
    [photoArray removeAllObjects];
    
    photoStringArray = nil;
    containerViewArray = nil;
    photoViewArray = nil;
    photoArray = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
