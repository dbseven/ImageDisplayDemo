//
//  MLBaseModel.h
//  TestImageDisplay
//
//  Created by CristianoRLong on 16/8/22.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <UIKit/UIKit.h>
#import <Mantle/MTLJSONAdapter.h>

@interface MLBaseModel : MTLModel <MTLJSONSerializing>

/** 图片标题 */
@property (nonatomic, copy) NSString *imageTitle;

/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl;

/** 图片: 从连接地址下载的图片 */
@property (nonatomic, strong) UIImage *image;

/** 图片宽度 */
@property (nonatomic, assign) CGFloat imageWidth;

/** 图片高度 */
@property (nonatomic, assign) CGFloat imageHeight;

@end
