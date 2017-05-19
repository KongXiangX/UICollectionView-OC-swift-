//
//  KXHorCollectioniVC.m
//  UICollectionView
//
//  Created by apple on 17/5/18.
//  Copyright © 2017年 KXX. All rights reserved.
//

#import "KXHorCollectioniVC.h"
#import "KXHorCollectionViewCell.h"
#import "KXHorCollectionLayout.h"
#import "KXCirvleCollectionLayout.h"

#define KXScreenW [UIScreen mainScreen].bounds.size.width


@interface KXHorCollectioniVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation KXHorCollectioniVC

/*
总结：
1.自定义cell时，
若使用nib，使用 registerNib: 注册，dequeue时会调用 cell 的 -(void)awakeFromNib
不使用nib，使用 registerClass: 注册, dequeue时会调用 cell 的 - (id)initWithStyle:withReuseableCellIdentifier:
2.需不需要注册？
使用dequeueReuseableCellWithIdentifier:可不注册，但是必须对获取回来的cell进行判断是否为空，若空则手动创建新的cell；
使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 创建布局对象 == 控制cell的排布\控制cell的尺寸
    KXHorCollectionLayout *layout = [[KXHorCollectionLayout alloc] init];
    //    HWCircleLayout *layout = [[HWCircleLayout alloc] init];
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, KXScreenW, 200) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    //2.3 注册cell
    [self.collectionView registerClass:[KXHorCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

#pragma mark - <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    KXHorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = self.data[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"点击了第  %zi  cell",indexPath.row);
    
    //    // 删除模型
    //    [self.data removeObjectAtIndex:indexPath.item];
    //
    //    // 删除界面
    //    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

//BOOL isCircle = YES;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[KXHorCollectionLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[KXCirvleCollectionLayout alloc] init] animated:YES];
    } else {
        [self.collectionView setCollectionViewLayout:[[KXHorCollectionLayout alloc] init] animated:YES];
    }
}

- (NSMutableArray *)data
{
    if (!_data) {
        self.data = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < 20; i++) {
            [self.data addObject:[NSString stringWithFormat:@"%zd", i]];
        }
    }
    return _data;
}
@end
