//
//  DownloadImageCell.m
//  SDWebImage
//
//  Created by 杨瑞 on 16/7/31.
//  Copyright © 2016年 yjq. All rights reserved.
//

#import "DownloadImageCell.h"
@interface DownloadImageCell()


@end
@implementation DownloadImageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setupUI{
    
}
-(void)setInfos:(InfoModel *)infos{
    _infos = infos;
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:infos.icon]]];
    self.nameLabel.text = infos.name;
    self.downloadLabel.text = infos.download;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
