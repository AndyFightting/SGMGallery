//
//  ViewController.m
//  SGMGallery
//
//  Created by 苏贵明 on 15/9/23.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController{

    UITableView* mTable;
    NSMutableArray* locakImgArray;
    NSMutableArray* networkImgArray;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"SGMGallery";
    
    mTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTable.dataSource =self;
    mTable.delegate = self;
    mTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:mTable];
    
    locakImgArray = [[NSMutableArray alloc]init];
    for (int i=0; i<=21; i++) {
        [locakImgArray addObject:[NSString stringWithFormat:@"test%d.jpeg",i]];
    }
    
    networkImgArray = [[NSMutableArray alloc]init];
    [networkImgArray addObject:@"http://desk.fd.zol-img.com.cn/g2/M00/0E/0C/ChMlWVW56AWIQ3coAAas_RAFGngAAH1XQOj354ABq0V525.jpg"];
    [networkImgArray addObject:@"http://t.kuaile.mobi/bizhi/20150823/0/20150823000410370.jpg"];
    [networkImgArray addObject:@"http://t.kuaile.mobi/bizhi/20150823/0/20150823000316872.jpg"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"cell";
    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text =@"查看本地图片";
    }else{
       cell.textLabel.text = @"查看网络图片";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        SGMPhotoViewController* viewVC = [[SGMPhotoViewController alloc]initWithPhotoArray:locakImgArray withPhotoType:IsLocalType startAtIndex:1];
        [self.navigationController pushViewController:viewVC animated:YES];
    }else{
        SGMPhotoViewController* viewVC = [[SGMPhotoViewController alloc]initWithPhotoArray:networkImgArray withPhotoType:IsNetworkType startAtIndex:0];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
