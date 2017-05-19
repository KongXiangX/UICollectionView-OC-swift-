//
//  KXScanCollectionVC.m
//  UICollectionView
//
//  Created by apple on 17/5/18.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import "KXScanCollectionVC.h"
#import "KXShop.h"
#import "KXWaterCollectionCell.h"
#import "KXWaterflowLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "UIImageView+WebCache.h"


#import "KXHorCollectionViewCell.h"
#import "KXHorCollectionLayout.h"
#define KXScreenW [UIScreen mainScreen].bounds.size.width
#define KXScreenH [UIScreen mainScreen].bounds.size.height

#import "KXScanCell.h"

static NSString * const CellId = @"shop";

@interface KXScanCollectionVC ()<UICollectionViewDataSource, UICollectionViewDelegate, KXWaterFlowLayoutDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView * waterCollection;  //瀑布流
@property (nonatomic, strong) UICollectionView * horCollection;     //水平
@property (nonatomic, strong) NSMutableArray * shops;

@property (nonatomic, strong) UIButton * statusBtn;
@property (nonatomic, assign) BOOL  isLoaded;
@end

@implementation KXScanCollectionVC

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
    
    
    //2. 瀑布流
    [self setupWaterCollection];
    
    //3.水平浏览
    [self setupHorCollection];
}
#pragma mark - 2. 瀑布流
- (void)setupWaterCollection
{
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
    self.waterCollection = collectionView;
    
    //2.3 注册cell
    [self.waterCollection registerClass:[KXWaterCollectionCell class] forCellWithReuseIdentifier:CellId];
    
    // 添加刷新控件
    
    self.waterCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewShops];
    }];
    
    
    self.waterCollection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    
}
#pragma mark -- 2.1 下拉加载
- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *newShops = [KXShop mj_objectArrayWithFilename:@"2.plist"];
        [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
        [self.waterCollection reloadData];
        
        // stop refresh
        [self.waterCollection.mj_header endRefreshing];
    });
}
#pragma mark -- 2.2 上拉加载 更多
- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *newShops = [KXShop mj_objectArrayWithFilename:@"3.plist"];
        [self.shops addObjectsFromArray:newShops];
        [self.waterCollection reloadData];
        
        // stop refresh
        [self.waterCollection.mj_footer endRefreshing];
    });
}
#pragma mark - 3. 水平浏览
- (void)setupHorCollection
{
    // 创建布局对象 == 控制cell的排布\控制cell的尺寸
//    KXHorScanLayout * layout = [[KXHorScanLayout alloc] init];
//    //    HWCircleLayout *layout = [[HWCircleLayout alloc] init];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(KXScreenW, KXScreenH);
    //流 的播放方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;//行间距(最小值)
    
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KXScreenW, KXScreenH) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.hidden = YES;
    collectionView.scrollEnabled = YES;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.horCollection = collectionView;
    
    //2.3 注册cell
    [self.horCollection registerClass:[KXScanCell class] forCellWithReuseIdentifier:@"cell"];
    
    //3.
    //4.按钮
    UIButton * statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.hidden = YES;
    statusBtn.frame = CGRectMake(10, 20, 30, 30);
    [statusBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:statusBtn];
    self.statusBtn  = statusBtn;
}
- (void)statusBtnClick
{
    self.statusBtn.hidden = YES;
    self.horCollection.hidden = YES;
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
    
    if (collectionView == self.waterCollection) {
        KXWaterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
        cell.shop = self.shops[indexPath.item];
        return cell;
    }else{
        KXScanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.shop = self.shops[indexPath.item];
        return cell;
    }
    
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
    
    
    self.horCollection.hidden = NO;
    self.statusBtn.hidden = NO;
    [UIView animateWithDuration:2.0 animations:^{
       [self.horCollection setContentOffset:CGPointMake(KXScreenW*indexPath.row, 0) animated:YES];
    }];

    

}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
        self.isLoaded = YES;
    }
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    static NSInteger currentIndex = 0;
//    
//    NSInteger index=scrollView.contentOffset.y;
//    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
//    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
//    //        NSLog(@"%@",visibleIndexPath);
//    if (currentIndex == visibleIndexPath.section || visibleIndexPath == nil) {
//        return;
//    }
//    currentIndex = visibleIndexPath.section;
//    
//    [self.itemTool itemScrollToPositionWithIndex:currentIndex isJump:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
