//
//  MLImageDisplayCell.m
//  YouXian
//
//  Created by CristianoRLong on 16/5/27.
//  Copyright © 2016年 haosongyan. All rights reserved.
//

#import "MLImageDisplayCell.h"
#import "MLImageDisplayViewController.h"
#import "UIImageView+WebCache.h"
#import "ProgressView.h"

@interface MLImageDisplayCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

/** 承载图片的 ScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** Loading 菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;

@property (nonatomic, strong) ProgressView *progressView;

/** Tap 手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/** DoubleTap 手势 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

/** 是否已经点击 */
@property (nonatomic, assign) BOOL isTaped;

@end

@implementation MLImageDisplayCell
#pragma mark - 懒加载
#pragma mark -
- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  = 1;
        _doubleTap.delegate = self;
    }
    return _doubleTap;
}
#pragma mark 懒加载 Tap
- (UITapGestureRecognizer *)tap {
    
    if (!_tap) {
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapAction:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        _tap.delegate = self;
        [_tap requireGestureRecognizerToFail:self.doubleTap];
    }
    
    return _tap;
}

#pragma mark 懒加载 LoadingIndicatorView
- (UIActivityIndicatorView *) loadingIndicatorView {
    
    if (!_loadingIndicatorView) {
        
        _loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.contentView addSubview: _loadingIndicatorView];
    }
    
    return _loadingIndicatorView;
}

- (ProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[ProgressView alloc] init];
        _progressView.bounds = CGRectMake(0, 0, 100, 100);
        _progressView.progress = 0;
        [self.contentView addSubview: _progressView];
    }
    
    return _progressView;
}

#pragma mark 懒加载 ScrollView
- (UIScrollView *) scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame: self.contentView.bounds];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.delegate = self;
        [_scrollView addGestureRecognizer: self.tap];
        [_scrollView addGestureRecognizer: self.doubleTap];
        [self.contentView addSubview: _scrollView];
    }
    
    return _scrollView;
}

#pragma mark 懒加载 ImageView
- (UIImageView *) imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.bounds = (CGRect){CGPointZero, self.imageDisplayModel.imageSize};
        _imageView.center = _scrollView.center;
        [self.scrollView addSubview: _imageView];
    }
    
    return _imageView;
}

#pragma mark - Override Methods
#pragma mark -
- (void)prepareForReuse {
    
    [self.imageView sd_cancelCurrentImageLoad];
}

#pragma mark - 初始化方法
#pragma mark -
#pragma mark 从 Xib 中唤醒
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - 配置 UI 
#pragma mark -
#pragma mark 根据 UIImage 配置 UI
- (void) configureUIWithImage:(UIImage *)image {
    
//    1. 配置 ImageView
    self.imageView.frame = (CGRect){self.imageView.frame.origin, _imageDisplayModel.imageSize};
    self.imageView.center = _scrollView.center;
    
//    2. 设置图片
    self.imageView.image = image;
}

#pragma mark 根据 NSString 配置 UI
- (void) configureUIWithImageUrl:(NSString *)imageUrl {
    
//    1. 配置 ImageView
    self.imageView.frame = (CGRect){self.imageView.frame.origin, _imageDisplayModel.imageSize};
    self.imageView.image = _imageDisplayModel.image;
    self.imageView.center = _scrollView.center;
    
//    2. 从网络获取图片
    [self startLoadingAnimation];
//    [self.imageView sd_setImageWithURL: [NSURL URLWithString: imageUrl]
//                      placeholderImage: _imageDisplayModel.placeHolderImage
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                 
//                                 if (!error) {
//                                     
//                                     _imageDisplayModel.image = image;
//                                     
//                                     if (cacheType == SDImageCacheTypeNone) {
//                                         
//                                         [self imageAnimation:YES];
//                                     } else {
//                                         
//                                         [self imageAnimation:NO];
//                                     }
//                                 }
//                                 
//                                 [self stopLoadingAnimation];
//                             }];
    
    [self.imageView sd_setImageWithURL: [NSURL URLWithString: imageUrl]
                      placeholderImage: _imageDisplayModel.placeHolderImage
                               options: SDWebImageHighPriority
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  
                                  self.progressView.progress = receivedSize*1.0f / expectedSize;
                                  
                              } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  
                                  if (!error) {
                                      
                                      _imageDisplayModel.image = image;
                                      
                                      if (cacheType == SDImageCacheTypeNone) {
                                          
                                          [self imageAnimation:YES];
                                      } else {
                                          
                                          [self imageAnimation:NO];
                                      }
                                  }
                                  
                                  [self stopLoadingAnimation];
                              }];
    
}

#pragma mark 图片动画
- (void) imageAnimation:(BOOL)animation {
    
    [UIView animateWithDuration: animation ? 0.2f : 0.0f animations:^{
        
        self.imageView.frame = (CGRect){self.imageView.frame.origin, _imageDisplayModel.imageSize};
        self.imageView.center = _scrollView.center;
    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark 开始 Loading 动画
- (void) startLoadingAnimation {
    
    [self.contentView bringSubviewToFront: self.loadingIndicatorView];
    self.loadingIndicatorView.hidden = NO;
    self.loadingIndicatorView.center = self.imageView.center;
    [self.loadingIndicatorView startAnimating];
    
    [self.contentView bringSubviewToFront: self.progressView];
    self.progressView.hidden = NO;
    self.progressView.center = self.imageView.center;
}

#pragma mark 结束 Loading 动画
- (void) stopLoadingAnimation {
    
    self.loadingIndicatorView.hidden = YES;
    [self.loadingIndicatorView stopAnimating];
    
    self.progressView.hidden = YES;
}

#pragma mark - Set / Get 方法重写
#pragma mark -
#pragma mark Set ImageDisplayModel
- (void)setImageDisplayModel:(MLImageDisplayModel *)imageDisplayModel {
    
    self.scrollView.zoomScale = 1.0f;
    self.imageView.center = _scrollView.center;
    if (_imageDisplayModel == imageDisplayModel) return;
    _imageDisplayModel = imageDisplayModel;
    [self.imageView sd_cancelCurrentImageLoad];
    [self stopLoadingAnimation];
    
//    1. 配置 ScrollView
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
//    2. 配置 图片
    if (imageDisplayModel.imageUrlString.length) {
        
        [self configureUIWithImageUrl: imageDisplayModel.imageUrlString];
    } else if (imageDisplayModel.image) {
        
        [self configureUIWithImage: imageDisplayModel.image];
    }
    
//    3. 配置 ScrollView 的 ContentSize
    self.scrollView.contentSize = CGSizeMake(0, imageDisplayModel.imageSize.height);
}

#pragma mark 返回缩放的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    
//    scrollView.contentSize = view.frame.size;
//    
//    if (1.0 == scale) {
//        /** 判断内容高度是否已经大于了屏幕的高度 */
//        if (scrollView.contentSize.height > kHeight_ScreenHeight) {
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                view.bounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//            }];
//            
//        }else {
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                view.center = _scrollView.center;
//            }];
//            
//        }
//    } else {
//        
//        if (scrollView.contentSize.height > kHeight_ScreenHeight && scrollView.contentSize.width > kWidth_ScreenWidth) { // 宽高都大于屏幕
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//            }];
//            
//        } else if(scrollView.contentSize.height > kHeight_ScreenHeight) { // 高度大于屏幕高度
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//            }];
//            
//        } else if (scrollView.contentSize.width > kWidth_ScreenWidth) { // 宽度大于屏幕宽度
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//                view.center = CGPointMake(view.centerX, _scrollView.centerY);
//            }];
//            
//        } else {
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                view.bounds = view.bounds;
//                view.center = _scrollView.center;
//            }];
//        }
//    }
//}

#pragma mark UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 事件
#pragma mark -
#pragma mark DoubleTap 手势事件
- (void) doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    
    CGPoint touchPoint = [doubleTap locationInView: self.imageView];
    if (self.scrollView.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollView.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scrollView.contentOffset.y;
        [self.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

#pragma mark Tap 手势事件
- (void) tapAction:(UITapGestureRecognizer *)tap {
    
//    1. 判断是否已经点击了 (避免重复点击)
    if (self.isTaped) return;
    self.isTaped = YES;
    
//    2. 恢复缩放状态
    self.scrollView.zoomScale = 1.0f;
    
//    3. 回调 Block
    if (self.didSelected) {
        self.didSelected(self, self.imageDisplayModel);
    }
    
//    4. 0.4s 过后, 重置 isTaped 状态
    __weak __typeof(&*self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.isTaped = NO;
    });
}

@end
