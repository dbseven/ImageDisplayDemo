//
//  MLBaseCell.h
//  TestImageDisplay
//
//  Created by CristianoRLong on 16/8/22.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLBaseModel;

@interface MLBaseCell : UICollectionViewCell

/** 数据模型 */
@property (nonatomic, strong) MLBaseModel *model;

+ (UIImage *) placeHolderImage;

@property (nonatomic, strong) UIImageView *ml_imageView;

@end
