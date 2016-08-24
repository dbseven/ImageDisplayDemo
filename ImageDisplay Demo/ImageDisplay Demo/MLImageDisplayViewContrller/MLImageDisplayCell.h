//
//  MLImageDisplayCell.h
//  YouXian
//
//  Created by CristianoRLong on 16/5/27.
//  Copyright © 2016年 haosongyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLImageDisplayModel, MLImageDisplayCell;

typedef void(^MLImageDisplayCellDidSelected)(MLImageDisplayCell *, MLImageDisplayModel *);

@interface MLImageDisplayCell : UICollectionViewCell

/** 图片 ImageView */
@property (nonatomic, strong) UIImageView *imageView;

/** 数据源 */
@property (nonatomic, strong) MLImageDisplayModel *imageDisplayModel;

/** 图片偏移量 */
@property (nonatomic, assign) UIEdgeInsets imageInset;

/** 点击回调 Block */
@property (nonatomic, copy) MLImageDisplayCellDidSelected didSelected;

@end
