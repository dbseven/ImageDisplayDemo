//
//  MLHomeViewController.m
//  TestImageDisplay
//
//  Created by CristianoRLong on 16/8/22.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLImageDisplayViewController.h"
#import "MLWaterfallLayout.h"
#import "MLBaseCell.h"
#import "MLBaseModel.h"
#import <Mantle/Mantle.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>

@interface MLHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MLWaterfallLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger columnCount;

@property (nonatomic, weak) UIButton *leftButton;

@end

@implementation MLHomeViewController

- (void) clearAction:(UIButton *)sender {
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion: nil];
    [[SDImageCache sharedImageCache] clearMemory];
    
    !sender?:[self configureDataSource];
    !sender?:[self.collectionView reloadData];
}

- (void) editAction:(UIButton *)sender {
    
    // 1. 判断列数
    if (++self.columnCount > 4) {
        self.columnCount = 1;
    }
    
    // 2. 设置标题
    [self.leftButton setTitle: [NSString stringWithFormat: @"%ld列", (long)(self.columnCount)] forState: UIControlStateNormal];
    
    // 3. 更新 Layout
    [self updateLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 清楚缓存
    [self clearAction: nil];
    
    // 2. 配置导航栏
    [self configureNavigationBar];
    
    // 3. 配置数据源
    [self configureDataSource];
    
    // 4. 配置 CollectionView
    [self configureCollectionView];
}

- (void) configureDataSource {
    
    NSArray *arr = @[
                     @{
                         @"title":@"夜景",
                         @"url":@"http://img15.3lian.com/2015/f2/50/d/74.jpg",
                         @"width":@(1000.0),
                         @"height":@(667.0),
                         },
                     
                     @{
                         @"title":@"魔兽",
                         @"url":@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/01/0F/ChMkJ1bKwyOII3keAAjhM-VkjdQAALGyQOjMpEACOFL408.jpg",
                         @"width":@(960.0),
                         @"height":@(600.0),
                         },
                     
                     @{
                         @"title":@"Beauty",
                         @"url":@"http://image.tianjimedia.com/uploadImages/2014/113/17/0P2Y28DH7K0F.jpg",
                         @"width":@(700.0),
                         @"height":@(990.0),
                         },
                     
                     @{
                         @"title":@"Beauty",
                         @"url":@"http://img05.tooopen.com/images/20140711/sy_65800894329.jpg",
                         @"width":@(1024.0),
                         @"height":@(682.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://h.hiphotos.baidu.com/zhidao/pic/item/b3b7d0a20cf431ad6ceeb36a4d36acaf2edd98a1.jpg",
                         @"width":@(1920.0),
                         @"height":@(1080.0),
                         },
                     
                     @{
                         @"title":@"甜美清纯美女",
                         @"url":@"http://www.bz55.com/uploads/allimg/150204/139-150204110646.jpg",
                         @"width":@(1920.0),
                         @"height":@(1200.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://img15.3lian.com/2015/f2/52/d/43.jpg",
                         @"width":@(2500.0),
                         @"height":@(1661.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://pic.58pic.com/58pic/16/58/85/24V58PICFiZ_1024.jpg",
                         @"width":@(1024.0),
                         @"height":@(492.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://bbs.static.coloros.com/data/attachment/forum/201510/27/133706wm71bnnhwvo01osb.jpg",
                         @"width":@(2560.0),
                         @"height":@(1600.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://a.hiphotos.baidu.com/zhidao/pic/item/359b033b5bb5c9eaa55e9032d439b6003bf3b3b6.jpg",
                         @"width":@(1920.0),
                         @"height":@(1200.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://a.hiphotos.baidu.com/zhidao/pic/item/203fb80e7bec54e7a64dc238ba389b504fc26a77.jpg",
                         @"width":@(1920.0),
                         @"height":@(1080.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://pic.962.net/up/2013-11/2013111111110955092352.jpg",
                         @"width":@(1920.0),
                         @"height":@(1061.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://f.hiphotos.baidu.com/zhidao/pic/item/cc11728b4710b912f52c4a1ac1fdfc0393452260.jpg",
                         @"width":@(2880.0),
                         @"height":@(1800.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://pic.paopaoche.net/up/201405/105742_8103452384471.jpg",
                         @"width":@(1920.0),
                         @"height":@(1080.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://hiphotos.baidu.com/%BE%B2%BE%B2%BE%B2%D4%C2/pic/item/ccc4383cb9389b500e2de6d38535e5dde6116e0c.jpg",
                         @"width":@(1600.0),
                         @"height":@(900.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://a.hiphotos.baidu.com/zhidao/pic/item/d01373f082025aafdcb63936fdedab64024f1a42.jpg",
                         @"width":@(640.0),
                         @"height":@(1136.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://img.tuku.cn/file_big/201501/a52cc73d04884b29a5355efa6091209c.jpg",
                         @"width":@(3840.0),
                         @"height":@(2160.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://imgsrc.baidu.com/forum/w=580/sign=52300060942bd40742c7d3f54b889e9c/654a973eb13533fad99f0d66abd3fd1f40345bdb.jpg",
                         @"width":@(1465.0),
                         @"height":@(2200.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://img3.3lian.com/2013/v15/15/d/47.jpg",
                         @"width":@(1938.0),
                         @"height":@(1090.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://imgstore.cdn.sogou.com/app/a/100540002/455457.jpg",
                         @"width":@(1366.0),
                         @"height":@(768.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://image.tianjimedia.com/uploadImages/2014/290/20/084Z89MC1B48.jpg",
                         @"width":@(1920.0),
                         @"height":@(1080.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://imgsrc.baidu.com/forum/w=580/sign=8365e4b2003b5bb5bed720f606d3d523/4e05f71b0ef41bd5063f0ded52da81cb39db3d52.jpg",
                         @"width":@(724.0),
                         @"height":@(1024.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://imgsrc.baidu.com/forum/w=580/sign=71e2e4a275f082022d9291377bfafb8a/39f7941373f08202860691be4dfbfbeda9641bd3.jpg",
                         @"width":@(422.0),
                         @"height":@(750.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://attach.bbs.miui.com/forum/201512/16/170533dyy277kk5uz4y3pk.jpg",
                         @"width":@(2840.0),
                         @"height":@(2160.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://pic.paopaoche.net/up/2015-5/201505290842102993162.jpg",
                         @"width":@(1920.0),
                         @"height":@(1080.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://bbs.static.coloros.com/data/attachment/forum/201509/06/061416hsn5m5m5ypq5z6sf.jpg",
                         @"width":@(1024.0),
                         @"height":@(1024.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://images.ali213.net/picfile/pic/2010-01-04/16114394493.jpg",
                         @"width":@(1920.0),
                         @"height":@(1080.0),
                         },
                     
                     @{
                         @"title":@"高清图片",
                         @"url":@"http://img4q.duitang.com/uploads/item/201410/02/20141002191720_XiRma.jpeg",
                         @"width":@(1080.0),
                         @"height":@(1920.0),
                         },
                     ];
    
    
    
    self.dataSource = [NSMutableArray arrayWithArray: [MTLJSONAdapter modelsOfClass:[MLBaseModel class] fromJSONArray: arr error: nil]];
}

- (void) configureNavigationBar {
    
    // 右侧
    UIButton *clearButton = [UIButton buttonWithType: UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, 100, 44);
    clearButton.titleEdgeInsets = UIEdgeInsetsMake(clearButton.titleEdgeInsets.top, 60, clearButton.titleEdgeInsets.bottom, clearButton.titleEdgeInsets.right);
    clearButton.titleLabel.font = [UIFont systemFontOfSize: 16];
    [clearButton setTitle: @"Clear" forState: UIControlStateNormal];
    [clearButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [clearButton addTarget: self action: @selector(clearAction:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: clearButton];
    
    // 左侧
//    UIButton *editButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    editButton.frame = CGRectMake(0, 0, 100, 44);
//    editButton.titleEdgeInsets = UIEdgeInsetsMake(editButton.titleEdgeInsets.top, editButton.titleEdgeInsets.left, editButton.titleEdgeInsets.bottom, 70);
//    editButton.titleLabel.font = [UIFont systemFontOfSize: 16];
//    [editButton setTitle: [NSString stringWithFormat: @"%ld列", (long)(self.columnCount = 2)] forState: UIControlStateNormal];
//    [editButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
//    [editButton addTarget: self action: @selector(editAction:) forControlEvents: UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: editButton];
//    self.leftButton = editButton;
    
}
- (void) configureCollectionView {
    
    MLWaterfallLayout *layout = [self obtainLayout];
    
    // 3. 创建 CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout: layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName: @"MLBaseCell" bundle: nil] forCellWithReuseIdentifier:@"MLBaseCell"];
//    collectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:248/255.0 blue:251/255.0 alpha:1];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: collectionView];
    self.collectionView = collectionView;
}

- (MLWaterfallLayout *) obtainLayout {
    
    MLWaterfallLayout *layout = [[MLWaterfallLayout alloc] init];
    layout.delegate = self;
    layout.columsCount = !self.columnCount?self.columnCount=2:self.columnCount;
//    layout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);
//    layout.columnMargin = 50;
//    layout.rowMargin = 60;
    
    return layout;
}

- (void) updateLayout {
    
    MLWaterfallLayout *layout = [self obtainLayout];
    [self.collectionView setCollectionViewLayout: layout
                                        animated: YES];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"MLBaseCell" forIndexPath: indexPath];
    
    cell.model = self.dataSource[indexPath.item];
    
    return cell;
}

- (CGFloat)waterfallLayout:(MLWaterfallLayout *)waterfallLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    
    MLBaseModel *model = self.dataSource[indexPath.item];
    
    CGFloat scale = model.imageHeight / model.imageWidth;
    
    return scale *width;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 0. 获取数组
    NSMutableArray *images = [NSMutableArray array];
    for (MLBaseModel *model in self.dataSource) {
        [images addObject: model.image ? model.image : model.imageUrl];
    }
    
    // 1. 获取 Cell
    MLBaseCell *cell = (MLBaseCell *)[collectionView cellForItemAtIndexPath: indexPath];
    
    MLImageDisplayViewController *imageDisplayViewController = [MLImageDisplayViewController viewController];
    
    imageDisplayViewController.placeHolderImage = [MLBaseCell placeHolderImage];
    imageDisplayViewController.placeHolderImageSize = CGSizeMake(100, 100);
    
    imageDisplayViewController.animateNavigationController = self.navigationController;
    imageDisplayViewController.animateViewController = self;
    imageDisplayViewController.animateOriginView = cell.ml_imageView;
    imageDisplayViewController.selectedIndex = indexPath.item;
    imageDisplayViewController.animateImage = cell.ml_imageView.image;
    imageDisplayViewController.images = images;
    imageDisplayViewController.singleTapDismiss = YES;
    
    imageDisplayViewController.dismissComplection = ^(){};
    [imageDisplayViewController show: ^(){}];
}

@end
