//
//  KXShop.h
//  UICollectionView_瀑布流
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KXShop : NSObject
/** 宽度 */
@property (nonatomic, assign) CGFloat w;
/** 高度 */
@property (nonatomic, assign) CGFloat h;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 图片的url地址 */
@property (nonatomic, copy) NSString *img;
@end
