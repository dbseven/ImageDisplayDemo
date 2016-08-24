//
//  MLWaterfallLayout.h
//  03_CollectionView_Waterfall
//
//  Created by 李梦龙 on 15/7/31.
//  Copyright (c) 2015年 LoveBeijingChirapsia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLWaterfallLayout;

@protocol MLWaterfallLayoutDelegate <NSObject>

- (CGFloat) waterfallLayout:(MLWaterfallLayout *)waterfallLayout  heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface MLWaterfallLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets sectionInset;

/** 列间距 */
@property (nonatomic, assign) CGFloat columnMargin;

/** 行间距  */
@property (nonatomic, assign) CGFloat rowMargin;

/** 列数 */
@property (nonatomic, assign) NSInteger columsCount;

/** 代理 */
@property (nonatomic, weak) id<MLWaterfallLayoutDelegate> delegate;

@end
