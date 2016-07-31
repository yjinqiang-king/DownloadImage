//
//  DownloadImageCell.h
//  SDWebImage
//
//  Created by 杨瑞 on 16/7/31.
//  Copyright © 2016年 yjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"

@interface DownloadImageCell : UITableViewCell
@property (nonatomic,strong) InfoModel *infos;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
