//
//  KXScanCell.m
//  UICollectionView
//
//  Created by apple on 17/5/18.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import "KXScanCell.h"
#import "KXShop.h"
#import "UIImageView+WebCache.h"

@interface KXScanCell ()
@property (strong, nonatomic)  UIImageView *iconView;
@property (strong, nonatomic)  UILabel *priceLabel;
@end

@implementation KXScanCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //1.
        UIImageView * iconImg = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImg];
        self.iconView = iconImg;
        
        
        //2.
        UILabel * priceLab = [[UILabel alloc] init];
        priceLab.backgroundColor = [UIColor redColor];
        priceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:priceLab];
        self.priceLabel = priceLab;
        
        
    }
    return self;
}
- (void)setShop:(KXShop *)shop
{
    _shop = shop;
    self.priceLabel.text = shop.price;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(20, 20, self.bounds.size.width - 40, self.bounds.size.height - 40 - 30);
    
    self.priceLabel.frame = CGRectMake(20, self.bounds.size.height - 40, self.bounds.size.width - 40, 30);

    
    
}

@end
