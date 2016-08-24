//
//  MLBaseModel.m
//  TestImageDisplay
//
//  Created by CristianoRLong on 16/8/22.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLBaseModel.h"

@implementation MLBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"imageTitle":@"title",
             @"imageUrl":@"url",
             @"imageWidth":@"width",
             @"imageHeight":@"height",
             };
}

@end
