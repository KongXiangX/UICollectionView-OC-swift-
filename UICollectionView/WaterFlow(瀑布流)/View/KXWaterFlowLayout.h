//
//  KXWaterFlowLayout.h
//  UICollectionView_瀑布流
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KXWaterFlowLayout;

@protocol KXWaterFlowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(KXWaterFlowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 *  返回四边的间距, 默认是UIEdgeInsetsMake(10, 10, 10, 10)
 */
- (UIEdgeInsets)insetsInWaterflowLayout:(KXWaterFlowLayout *)waterflowLayout;
/**
 *  返回最大的列数, 默认是3
 */
- (int)maxColumnsInWaterflowLayout:(KXWaterFlowLayout *)waterflowLayout;
/**
 *  返回每行的间距, 默认是10
 */
- (CGFloat)rowMarginInWaterflowLayout:(KXWaterFlowLayout *)waterflowLayout;
/**
 *  返回每列的间距, 默认是10
 */
- (CGFloat)columnMarginInWaterflowLayout:(KXWaterFlowLayout *)waterflowLayout;

@end

@interface KXWaterFlowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<KXWaterFlowLayoutDelegate>delegate;
@end
