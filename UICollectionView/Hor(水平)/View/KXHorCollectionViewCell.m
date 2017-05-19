//
//  KXHorCollectionViewCell.m
//  UICollectionView_水平布局
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import "KXHorCollectionViewCell.h"


@interface KXHorCollectionViewCell ()
@property (nonatomic, strong) UILabel * label;
@end

@implementation KXHorCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //1.
        self.layer.borderWidth = 5;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 5;
        
        //2.
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.label = label;
    
    }
    return self;
}


//- (void)awakeFromNib {
//    // Initialization code
//    [super awakeFromNib];
//  
//}

- (void)setIndex:(NSString *)index
{
    _index = [index copy];
    
    self.label.text = index;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
   
}
@end
