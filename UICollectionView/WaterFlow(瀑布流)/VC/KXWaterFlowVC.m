//
//  KXWaterFlowVC.m
//  UICollectionView_瀑布流
//
//  Created by apple on 17/5/18.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import "KXWaterFlowVC.h"

#import "KXShop.h"
#import "KXWaterCollectionCell.h"
#import "KXWaterflowLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

static NSString * const CellId = @"shop";

@interface KXWaterFlowVC ()<UICollectionViewDataSource, UICollectionViewDelegate, KXWaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *shops;


@end

@implementation KXWaterFlowVC

- (NSMutableArray *)shops
{
    if (!_shops) {
        self.shops = [[NSMutableArray alloc] init];
    }
    return _shops;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流水布局展示";
    
    // 初始化数据
    [self.shops addObjectsFromArray:[KXShop  mj_objectArrayWithFilename:@"1.plist"]];
    
    // 创建布局
    KXWaterFlowLayout *layout = [[KXWaterFlowLayout alloc] init];
    layout.delegate = self;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    //    [collectionView registerNib:[UINib nibWithNibName:@"YFShopCell" bundle:nil] forCellWithReuseIdentifier:CellId];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    //2.3 注册cell
    [self.collectionView registerClass:[KXWaterCollectionCell class] forCellWithReuseIdentifier:CellId];
    
    // 添加刷新控件
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewShops];
    }];
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *newShops = [KXShop mj_objectArrayWithFilename:@"2.plist"];
        [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
        [self.collectionView reloadData];
        
        // stop refresh
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *newShops = [KXShop mj_objectArrayWithFilename:@"3.plist"];
        [self.shops addObjectsFromArray:newShops];
        [self.collectionView reloadData];
        
        // stop refresh
        [self.collectionView.mj_footer endRefreshing];
    });
}

#pragma mark - <YFWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(KXWaterFlowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    KXShop *shop = self.shops[indexPath.item];
    return shop.h * itemWidth / shop.w;
}

//- (UIEdgeInsets)insetsInWaterflowLayout:(YFWaterflowLayout *)waterflowLayout
//{
//    return UIEdgeInsetsMake(30, 30, 30, 30);
//}

//- (int)maxColumnsInWaterflowLayout:(YFWaterflowLayout *)waterflowLayout
//{
//    return 2;
//}

//- (CGFloat)rowMarginInWaterflowLayout:(YFWaterflowLayout *)waterflowLayout
//{
//    return 30;
//}
//
//- (CGFloat)columnMarginInWaterflowLayout:(YFWaterflowLayout *)waterflowLayout
//{
//    return 50;
//}

#pragma mark - <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KXWaterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KXShop * shop = self.shops[indexPath.row];
    NSLog(@"网址  %@   价格 %@",shop.img, shop.price);
    //    UIImageView * img = [[UIImageView alloc] init];
    //    img.frame = CGRectMake(0, 20, 320, 480);
    //    [img sd_setImageWithURL:[NSURL URLWithString:shop.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //    }];
    //    [self.view addSubview:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
