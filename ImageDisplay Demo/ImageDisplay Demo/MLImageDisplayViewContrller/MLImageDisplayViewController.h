//
//  MLImageDisplayViewController.h
//  YouXian
//
//  Created by CristianoRLong on 16/5/27.
//  Copyright © 2016年 haosongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** MLImageDisplayViewController 的滚动类型 */
typedef NS_ENUM(NSInteger, MLImageDisplayViewControllerScrollType) {
    
    /** 普通类型 */
    MLImageDisplayViewControllerScrollTypeNormal = 0,
    
    /** 无限循环滚动类型 */
    MLImageDisplayViewControllerScrollTypeInfiniteScroll = 1
};


/** MLImageDisplayViewController 的显示类型 */
typedef NS_ENUM(NSInteger, MLImageDisplayViewControllerShowType) {
    
    /** 导航控制器 Push 类型 */
    MLImageDisplayViewControllerShowTypePush = 0,
    
    /** 视图控制器 Present 类型 */
    MLImageDisplayViewControllerShowTypePresent = 1
};

@protocol MLImageDisplayViewControllerDelegate;

/** Dismiss 后的回调 Block */
typedef void(^DismissComplection)(void);

@interface MLImageDisplayViewController : UIViewController
#pragma mark - 基本属性 和 方法
#pragma mark -

/** 构造方法 */
+ (instancetype) viewController;

/** 滚动类型. 默认: MLImageDisplayViewControllerScrollTypeNormal */
@property (nonatomic, assign) MLImageDisplayViewControllerScrollType scrollType;

/** 图片数组: 该数组可以存放 UIImage 和 NSString, 也可以是两者混合 */
@property (nonatomic, strong) NSMutableArray *images;

/** 默认 CollectionView Item 大小为全屏, imageInset = Zero. */
@property (nonatomic, assign) UIEdgeInsets imageInset;

/** 当前选中的图片在数组中的位置 */
@property  (nonatomic, assign) NSInteger selectedIndex;

/** 单击返回, 默认: NO, 默认单击效果是 显示/隐藏 HeaderView, 设置为 YES 后, 将会失去显示/隐藏 HeaderView 的效果 */
@property (nonatomic, assign) BOOL singleTapDismiss;

/** 代理 */
@property (nonatomic, weak) id<MLImageDisplayViewControllerDelegate> delegate;

/** 配置完属性后, 调用 Show 方法展示 MLImageDisplayViewController */
- (void) show:(void(^)(void))complection;

/** 退出 MLImageDisplayViewController */
- (void) dismiss;

/** Dismiss 后的回调 Block */
@property (nonatomic, copy) DismissComplection dismissComplection;

/** MLImageDisplayViewController 的显示类型. 默认: MLImageDisplayViewControllerShowTypePush */
@property (nonatomic, assign) MLImageDisplayViewControllerShowType showType;

#pragma mark - 缩放相关
#pragma mark -
/** 是否支持图片双只滑动缩放. 默认: YES */
@property (nonatomic, assign, getter=isDoubleFingerZoomEnable) BOOL doubleFingerZoom;


#pragma mark - 动画相关
#pragma mark -
/** 是否以动画的形式进入 MLImageDisplayViewController */
@property (nonatomic, assign, getter=isAnimatePush) BOOL animatePush;

/** 当前选中图片 */
@property (nonatomic, weak) UIImage *animateImage;

/** 承载用户点击图片的 View, 用于动画的实现 */
@property (nonatomic, weak) UIView *animateOriginView;

/** 用于计算相对位置的试图控制器, 如果该属性为空, 则以 KeyWindow 为计算标准 */
@property (nonatomic, weak) UIViewController *animateViewController;

/** 用于进行 Push 的 NavigationController */
@property (nonatomic, weak) UINavigationController *animateNavigationController;


#pragma mark - PlaceHolder Image 相关
#pragma mark -
/** PlaceHolderImage 名称 */
@property (nonatomic, copy) NSString *placeHolderImageName;

/** PlaceHolderImage */
@property (nonatomic, strong) UIImage *placeHolderImage;

/** PlaceHolderImage Size */
@property (nonatomic, assign) CGSize placeHolderImageSize;

@end



#pragma mark - MLImageDisplayViewController Delegate
@protocol MLImageDisplayViewControllerDelegate <NSObject>

@optional

/** 顶部视图 */
- (UIView *) headerViewForImageDisplayViewController;

/** 底部视图 */
- (UIView *) footerViewForImageDisplayViewController;

/** 滚动到了x张图片 */
- (void) imageDisplayViewController:(MLImageDisplayViewController *)imageDisplayViewController didScrollToIndex:(NSInteger)index collectionView:(UICollectionView *)collectionView;

@end











#pragma mark - 数据模型
#pragma mark -
@interface MLImageDisplayModel : NSObject

/** 构造方法 */
+ (instancetype) imageDisplayModel:(id)object;

/** 图片 */
@property (nonatomic, strong) UIImage *image;

/** 图片大小 */
@property (nonatomic, assign) CGSize imageSize;

/** 图片 Url */
@property (nonatomic, copy) NSString *imageUrlString;

/** PlaceHolderImage 名称 */
@property (nonatomic, copy) NSString *placeHolderImageName;

/** PlaceHolderImage Size */
@property (nonatomic, assign) CGSize placeHolderImageSize;

/** PlaceHolderImage */
@property (nonatomic, strong) UIImage *placeHolderImage;


@end
