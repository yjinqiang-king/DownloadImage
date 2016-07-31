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
/**
 *  储存模型的数组
 */
@property(nonatomic,copy)NSMutableArray *appInfos;
/**
 *  操作
 */
@property(nonatomic,strong)NSOperationQueue *queue;
/**
 *  图片缓存的字典<key ： 图片地址， value：图片>
 */
@property(nonatomic,strong)NSMutableDictionary *imageCache;
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
#pragma mark 懒加载
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
-(NSMutableDictionary *)imageCache{
    if (_imageCache == nil) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}
#pragma mark 数据源方法
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
    UIImage *cacheImage = self.imageCache[info.icon];
    //判断字典中是否有图片
    if (cacheImage != nil) {
        //使用模型属性
//        cell.iconImageView.image = info.image;
        // 使用字典
        cell.iconImageView.image = cacheImage;
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
//            info.image = image;
            //将图片缓存到字典中
            [self.imageCache setValue:image forKey:info.icon];
            //刷新相对应的位置（indexPath）的cell
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
    }];
    //返回cell的
    [self.queue addOperation:op];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.icon]];
    return cell;
}
/**
 * 收到内存警告:
 1. 将保存到内存中的图片清空
 - 如果图片保存到模型中的话,需要遍历模型数组,去给模型的image属性设置nil
 2. 将队列中的操作全部取消
 */
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    for (int i = 0 ; i < self.appInfos.count; i++) {
        InfoModel*info = [[InfoModel alloc]init];
        info.image = nil;
    }
    [self.imageCache removeAllObjects];
    //2.取消队列的所有操作
    [self.queue cancelAllOperations];
}
@end
