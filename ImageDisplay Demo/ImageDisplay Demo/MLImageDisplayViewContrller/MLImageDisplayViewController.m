//
//  MLImageDisplayViewController.m
//  YouXian
//
//  Created by CristianoRLong on 16/5/27.
//  Copyright © 2016年 haosongyan. All rights reserved.
//

#import "MLImageDisplayViewController.h"
#import "MLImageDisplayCell.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"


@interface MLImageDisplayViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

/** CollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** CollectionView Layout */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 当前选中的数据模型 */
@property (nonatomic, strong) MLImageDisplayModel *currentSelctedModel;

/** HeaderView */
@property (nonatomic, strong) UIView *headerView;

/** BottomView */
@property (nonatomic, strong) UIView *footerView;

/** HeaderLabel */
@property (nonatomic, strong) UILabel *headerLabel;

/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;

/** 判断是否正在显示动画 */
@property (nonatomic, assign) BOOL isHeaderViewAnimating;

/** 判断 HeaderView 是否显示 */
@property (nonatomic, assign) BOOL headerViewIsShow;

@end

@implementation MLImageDisplayViewController
#pragma mark - 构造方法
#pragma mark -
- (void)dealloc {
}
#pragma mark Init 方法
- (instancetype)init {
    if (self = [super init]) {
        
//        1. 隐藏底部
        self.hidesBottomBarWhenPushed = YES;
        
//        2. 配置变量
        [self configureVariate];
        
//        3. 背景颜色
//        self.view.backgroundColor = [UIColor colorWithRed: 245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha: 1.0f];
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark 工厂方法
+ (instancetype) viewController {
    
    MLImageDisplayViewController *viewController = [[MLImageDisplayViewController alloc] init];
    return viewController;
}

#pragma mark - 懒加载
#pragma mark -
#pragma mark Lazy BackButton
- (UIButton *) backButton {
    
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 20, 44, 44);
        [_backButton setImage: [UIImage imageNamed: @"nav_icon_back"] forState: UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
        [_backButton addTarget: self action: @selector(dismiss) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

#pragma mark Lazy HeaderLabel
- (UILabel *) headerLabel {
    
    if (!_headerLabel) {
        
        _headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font = [UIFont systemFontOfSize:20];
        _headerLabel.textColor = [UIColor whiteColor];
    }
    
    return _headerLabel;
}

#pragma mark Lazy HeaderView
- (UIView *) headerView {
    
    if (!_headerView) {
        
        if ([self.delegate respondsToSelector: @selector(headerViewForImageDisplayViewController)]) {
            _headerView = [self.delegate headerViewForImageDisplayViewController];
            [self.view addSubview: _headerView];
        } else {
            
            _headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
            _headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.32f];
            [self.view addSubview: _headerView];
            [_headerView addSubview: self.backButton];
            [_headerView addSubview: self.headerLabel];
        }
        
        self.headerViewIsShow = YES;
    }
    
    return _headerView;
}

#pragma mark Lazy FooterView
- (UIView *) footerView {
    
    if (!_footerView) {
        
        if ([self.delegate respondsToSelector: @selector(footerViewForImageDisplayViewController)]) {
            _footerView = [self.delegate footerViewForImageDisplayViewController];
            _footerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _footerView.frame.size.height, [UIScreen mainScreen].bounds.size.width, _footerView.frame.size.height);
            [self.view addSubview: _footerView];
        }
    }
    
    return _footerView;
}

#pragma mark Lazy Layout
- (UICollectionViewFlowLayout *) layout {
    
    if (!_layout) {
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsZero;
        CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat itemHeight = [UIScreen mainScreen].bounds.size.height;
        _layout.itemSize = CGSizeMake(itemWidth,  itemHeight);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _layout;
}

#pragma mark Lazy CollectionView
- (UICollectionView *) collectionView {
    
    if (!_collectionView) {
        
        UIView *view = [UIView new];
        [self.view addSubview: view];
        
        _collectionView = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout: self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName: @"MLImageDisplayCell" bundle: nil] forCellWithReuseIdentifier: @"MLImageDisplayCell"];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.contentInset = UIEdgeInsetsZero;
        [self.view addSubview: self.collectionView];
    }
    
    return _collectionView;
}

#pragma mark - ViewController 生命周期函数
#pragma mark -
#pragma mark loadView
- (void) loadView {
    [super loadView];
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.navigationController setNavigationBarHidden: YES];
}

#pragma mark viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

#pragma mark viewWillDisappear
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [self.navigationController setNavigationBarHidden: NO];
}

#pragma mark viewDidDisappear
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
}

#pragma mark - 初始化方法
#pragma mark -
#pragma mark 配置 变量
- (void) configureVariate {
    
//    1. ScrollType
    self.scrollType = MLImageDisplayViewControllerScrollTypeNormal;
    
//    2. 双指缩放
    self.doubleFingerZoom = YES;
    
//    3. 进入动画
    self.animatePush = YES;
}

#pragma mark - Set / Get 方法重写
#pragma mark -
#pragma mark Set Images
- (void) setImages:(NSMutableArray *)images {
    
//    1. 保存数组
    _images = images;
}

#pragma mark Set AnimateImage
- (void)setAnimateImage:(UIImage *)animateImage {
    
    if (!animateImage) return;
    
    _animateImage = animateImage;
    
    self.currentSelctedModel = [MLImageDisplayModel imageDisplayModel: animateImage];
}

#pragma mark - UICollectionView DataSource
#pragma mark -
#pragma mark Cell 个数
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

#pragma mark Cell 复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
           MLImageDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"MLImageDisplayCell" forIndexPath:indexPath];
    
    __weak __typeof(&*self)weakSelf = self;
    cell.didSelected = ^(MLImageDisplayCell *cell, MLImageDisplayModel *model){
        
        if (weakSelf.singleTapDismiss) {
            [weakSelf dismiss];
        } else {
            if (weakSelf.headerViewIsShow) {
                [weakSelf hideHeaderView];
            } else {
                [weakSelf showHeaderView];
            }
        }
    };
    cell.imageInset = self.imageInset;
    cell.imageDisplayModel = [self.dataSource objectAtIndex: indexPath.item];
    
    return cell;
}

#pragma mark - UIScrollView Delegate
#pragma mark -
#pragma mark 
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self configureHeaderTitle];
    }
}

#pragma mark
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self configureHeaderTitle];
}

#pragma mark - 私有方法
#pragma mark -
#pragma mark 显示 HeaderView
- (void) showHeaderView {
    
    if (self.isHeaderViewAnimating)return;
    self.isHeaderViewAnimating = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration: 0.4f animations:^{
        
        weakSelf.headerView.frame = (CGRect) {CGPointZero, weakSelf.headerView.frame.size};
        weakSelf.footerView.frame = (CGRect) {{0, [UIScreen mainScreen].bounds.size.height - weakSelf.footerView.frame.size.height}, weakSelf.footerView.frame.size};
    } completion:^(BOOL finished) {
        weakSelf.isHeaderViewAnimating = NO;
        weakSelf.headerViewIsShow = YES;
    }];
}

#pragma mark 隐藏 HeaderView
- (void) hideHeaderView {
    
    if (self.isHeaderViewAnimating)return;
    self.isHeaderViewAnimating = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration: 0.4f animations:^{
        
        weakSelf.headerView.frame = (CGRect) {{0, -weakSelf.headerView.frame.size.height}, weakSelf.headerView.frame.size};
        weakSelf.footerView.frame = (CGRect) {{0, [UIScreen mainScreen].bounds.size.height}, weakSelf.footerView.frame.size};
    } completion:^(BOOL finished) {
        weakSelf.isHeaderViewAnimating = NO;
        weakSelf.headerViewIsShow = NO;
    }];
}

#pragma mark 刷新页面
- (void) reloadData {
    
//    1. 判断数组是否为空
    if (!self.images.count) return;
    
//    2. 配置数据源
    self.dataSource = [[NSMutableArray alloc] init];
    for (id object in self.images) {
        
        MLImageDisplayModel *imageDisplayModel = [MLImageDisplayModel imageDisplayModel: object];
        if (self.placeHolderImage) {
            imageDisplayModel.placeHolderImage = self.placeHolderImage;
        } else if (self.placeHolderImageName) {
            imageDisplayModel.placeHolderImageName = self.placeHolderImageName;
        }
        imageDisplayModel.placeHolderImageSize = self.placeHolderImageSize;
        [self.dataSource addObject: imageDisplayModel];
    }
    
//    3. 刷新 CollectionView
    [self.collectionView reloadData];
}

#pragma mark 配置标题
- (void) configureHeaderTitle {
    
    UIView *view = self.headerView; // 这句话没有用, 但是别删除
    view = self.footerView;
    
//    0. 计算页数
    NSInteger index = (int)(self.collectionView.contentOffset.x / self.collectionView.frame.size.width + 1);
    index = index<1 ? 1 : index;
    index = index>=self.images.count ? self.images.count : index;
    
//    1. 设置标题
    self.headerLabel.text = [NSString stringWithFormat: @"%ld/%ld", index, self.images.count];
    
//    2. 回调代理
    if ([self.delegate respondsToSelector: @selector(imageDisplayViewController:didScrollToIndex:collectionView:)]) {
        [self.delegate imageDisplayViewController: self didScrollToIndex: index collectionView: self.collectionView];
    }
}

#pragma mark - 公有方法
#pragma mark -
#pragma mark 显示
- (void) show:(void (^)(void))complection {
    
    //    1. 判断是否存在 导航控制器 和 源UIView
    if (self.animateNavigationController && self.animateOriginView) {
        
        [self animationShowWithOriginFrame: [self obtainOriginFrame] complection:complection];
    }
}

#pragma mark 获取源 Frame
- (CGRect) obtainOriginFrame {
    
    CGPoint origin = CGPointZero;
    
    if (self.animateViewController) {
        
        origin = [self.animateViewController.view convertPoint: CGPointMake(self.animateOriginView.frame.origin.x, self.animateOriginView.frame.origin.y) fromView: self.animateOriginView.superview];
    } else {
        
        origin = [[UIApplication sharedApplication].keyWindow convertPoint: CGPointMake(self.animateOriginView.frame.origin.x, self.animateOriginView.frame.origin.y) fromView: self.animateOriginView.superview];
    }
    
    return (CGRect){origin, self.animateOriginView.frame.size};
}

#pragma mark 根据 Frame, 动画显示 MLImageDisplayViewController
- (void) animationShowWithOriginFrame:(CGRect)originFrame complection:(void (^)(void))complection {
    
//    1. 创建ImageView
    UIImageView *animateImageView = [[UIImageView alloc] init];
    animateImageView.image = self.currentSelctedModel.image;
    animateImageView.frame = originFrame;
    [self.animateViewController ? self.animateViewController.view : [UIApplication sharedApplication].keyWindow addSubview: animateImageView];
    
//    2. 动画
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration: 0.32f animations:^{
        
        animateImageView.bounds = CGRectMake(0, 0, weakSelf.currentSelctedModel.imageSize.width, weakSelf.currentSelctedModel.imageSize.height);
        animateImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        
    } completion:^(BOOL finished) {
        
        [self.animateNavigationController pushViewController: weakSelf animated: NO];
        
        [self reloadData];
        
        [self.collectionView setContentOffset: CGPointMake(weakSelf.selectedIndex * weakSelf.collectionView.frame.size.width, 0)];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [animateImageView removeFromSuperview];
        });
        
        if (complection) {
            complection();
        }
        
        [self configureHeaderTitle];
    }];
}

#pragma mark 退出
- (void) dismiss {
    
    if (self.selectedIndex == (self.collectionView.contentOffset.x / self.collectionView.frame.size.width)) {
        
//        1. 获取 ImageView
        UIImageView *imageView = [(MLImageDisplayCell *)[self.collectionView cellForItemAtIndexPath: [NSIndexPath indexPathForRow: self.selectedIndex inSection: 0]] imageView];
        
//        2. 创建动画 ImageView
        UIImageView *animationImageView = [[UIImageView alloc] init];
        animationImageView.bounds = imageView.bounds;
        animationImageView.center = self.view.center;
        animationImageView.image = imageView.image;
        animationImageView.clipsToBounds = YES;
        [self.animateViewController ? self.animateViewController.view : [UIApplication sharedApplication].keyWindow addSubview: animationImageView];
        
//        3. 动画隐藏
        [self.navigationController popViewControllerAnimated: NO];
        CGRect originFrame = [self obtainOriginFrame];
        animationImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        __weak __typeof(&*self)weakSelf = self;
        [UIView animateWithDuration: 0.32f animations:^{
            
            animationImageView.alpha = 0.0f;
            animationImageView.frame = originFrame;
        } completion:^(BOOL finished) {
            
            [animationImageView removeFromSuperview];
            
            if (weakSelf.dismissComplection) {
                weakSelf.dismissComplection();
            }
        }];
        
    } else {
        
//        1. 添加到 KeyWindow 上
        [[UIApplication sharedApplication].keyWindow addSubview: self.view];
        
//        2. Pop
        [self.navigationController popViewControllerAnimated: NO];
        
//        3. 动画隐藏
        __weak __typeof(&*self)weakSelf = self;
        [UIView animateWithDuration: 0.32f animations:^{
            
            weakSelf.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
            [self.view removeFromSuperview];
            
            if (weakSelf.dismissComplection) {
                weakSelf.dismissComplection();
            }
        }];
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

@end










#pragma mark - 数据模型
#pragma mark -

@implementation MLImageDisplayModel

#pragma mark InitWithImage 方法
- (instancetype) initWithImage:(UIImage *)image {
    
    if (self = [super init]) {
        
        self.image = image;
    }
    
    return self;
}

#pragma mark InitWithUrl 方法
- (instancetype) initWithUrl:(NSString *)imageUrl {
    
    if (self = [super init]) {
        
        self.imageUrlString = imageUrl;
        
        if ([[SDWebImageManager sharedManager] cachedImageExistsForURL: [NSURL URLWithString: imageUrl]]) {
            self.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey: imageUrl];
        }
    }
    
    return self;
}

#pragma mark 构造方法
+ (instancetype) imageDisplayModel:(id)object {
    
    MLImageDisplayModel *imageDisplayModel = nil;
    
    if ([object isKindOfClass: [NSString class]]) {
        
        imageDisplayModel = [[MLImageDisplayModel alloc] initWithUrl: object];
    } else if([object isKindOfClass: [UIImage class]]) {
        
        imageDisplayModel = [[MLImageDisplayModel alloc] initWithImage: object];
    }
    
    return imageDisplayModel;
}

#pragma mark - Set / Get 方法重写
#pragma mark -
#pragma mark Set PlaceHolderImageName
- (void)setPlaceHolderImageName:(NSString *)placeHolderImageName {
    _placeHolderImageName = placeHolderImageName;
    
    self.placeHolderImage = [UIImage imageNamed: placeHolderImageName];
}

#pragma mark Set PlaceHolderImage
- (void) setPlaceHolderImage:(UIImage *) placeHolderImage {
    _placeHolderImage = placeHolderImage;
    
    if (!self.image && self.imageUrlString.length) {
        self.image = placeHolderImage;
    }
}

#pragma mark Set Image
- (void) setImage:(UIImage *)image {
    
    _image = image;
    
    self.imageSize = [self imageHeightWithImage: image];
}

#pragma mark - 私有方法
#pragma mark -
#pragma mark 返回图片比例
- (CGFloat) ratioWithValue:(CGFloat)value {
    
    CGFloat result = 0.0f;
    
    result = [UIScreen mainScreen].bounds.size.width / value;
    
    return result;
}

#pragma mark 返回图片大小
- (CGSize) imageHeightWithImage:(UIImage *) image {
    
    CGSize result = CGSizeZero; // 结果
    CGFloat imageScale = 1.0f;
    
    if (image.size.height*imageScale > [UIScreen mainScreen].bounds.size.height || image.size.width*imageScale > [UIScreen mainScreen].bounds.size.width) {
        
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat ratio = [self ratioWithValue: imageWidth];
        
        result = CGSizeMake(imageWidth * ratio , imageHeight * ratio);

    } else {
        
        result = CGSizeMake(image.size.width * imageScale, image.size.height * imageScale);
    }
    
    return result;
}

@end