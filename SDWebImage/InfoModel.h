//
//  InfoModel.h
//  SDWebImage
//
//  Created by 杨瑞 on 16/7/31.
//  Copyright © 2016年 yjq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoModel : NSObject
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *download;
@property (nonatomic,strong) UIImage *image;
@end
