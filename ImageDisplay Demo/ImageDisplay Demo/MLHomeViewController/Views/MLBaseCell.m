//
//  MLBaseCell.m
//  TestImageDisplay
//
//  Created by CristianoRLong on 16/8/22.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseCell.h"
#import "MLBaseModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MLBaseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ml_ImageView;

@end

@implementation MLBaseCell

- (void)setModel:(MLBaseModel *)model {
    if (_model == model) return;
    _model = model;
    
    [self.ml_ImageView sd_setImageWithURL: [NSURL URLWithString: model.imageUrl]
                         placeholderImage: [[self class] placeHolderImage]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if (!error) {
                                        model.image = image;
                                    }
                                }];
}

- (UIImageView *)ml_imageView {
    return self.ml_ImageView;
}

+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

+ (UIImage *)placeHolderImage {
    
    return [self buttonImageFromColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
}

@end
