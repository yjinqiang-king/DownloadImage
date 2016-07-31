//
//  ViewController.m
//  SDWebImage
//
//  Created by 杨瑞 on 16/7/30.
//  Copyright © 2016年 yjq. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "InfoModel.h"
#import "UIImageView+WebCache.h"
#import "DownloadImageCell.h"

@interface ViewController ()
@property(nonatomic,copy)NSMutableArray *appInfos;
@property(nonatomic,strong)NSOperationQueue *queue;
@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadData];
}
//加载网络数据
-(void)loadData{
    NSString *urlString = @"https://raw.githubusercontent.com/yinqiaoyin/SimpleDemo/master/apps.json";
    //初始化一个网络请求的管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"请求成功  %@  %@",responseObject ,[responseObject class]);
        //字典转模型
        NSArray *array = responseObject;
        for (NSDictionary *dict in array) {
            InfoModel *info = [[InfoModel alloc]init];
            [info setValuesForKeysWithDictionary:dict];
            [self.appInfos addObject:info];
        }
        NSLog(@"%@",self.appInfos);
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"请求失败： %@",error);
    }];
}
-(NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}
-(NSMutableArray *)appInfos{
    if (_appInfos  == nil) {
        _appInfos = [NSMutableArray array];
    }
    return _appInfos;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.appInfos.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.infos = self.appInfos[indexPath.row];
    InfoModel *info = [[InfoModel alloc]init];
    info = self.appInfos[indexPath.row];
    
    cell.nameLabel.text = info.name;
    cell.downloadLabel.text = info.download;
    cell.iconImageView.image = nil;
    //判断模型里是否有图片  如果有就不用下载
    if (info.image != nil) {
        cell.iconImageView.image = info.image;
        return cell;
    }
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//        [NSThread sleepForTimeInterval:arc4random_uniform(5)];
        if (indexPath.row >= 9 ) {
            [NSThread sleepForTimeInterval:3];
        }
        NSLog(@"%@",[NSThread currentThread]);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.icon]];
        UIImage *image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            cell.imageView.image = image;
            info.image = image;
            //刷新相对应的位置（indexPath）的cell
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
    }];
    //返回cell的
    [self.queue addOperation:op];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.icon]];
    return cell;
}

@end
