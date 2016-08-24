//
//  MLWaterfallLayout.m
//  03_CollectionView_Waterfall
//
//  Created by 李梦龙 on 15/7/31.
//  Copyright (c) 2015年 LoveBeijingChirapsia. All rights reserved.
//

#import "MLWaterfallLayout.h"

static const CGFloat MLColumMargin = 10;
static const CGFloat MLRowMargin = MLColumMargin;

@interface MLWaterfallLayout ()

/** 用来存储每一列最大的 Y */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation MLWaterfallLayout

- (NSMutableArray *)attrsArray {
    
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    
    return _attrsArray;
}

- (NSMutableDictionary *)maxYDict {
    
    if (!_maxYDict) {
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    
    return _maxYDict;
}

- (instancetype) init {
    
    if (self = [super init]) {
        
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columsCount = 3;
    }
    
    return self;
}

/**
 *  每次布局之前就会调用这个方法
 */
- (void)prepareLayout {
    [super prepareLayout];
    
//    NSLog(@"prepareLayout");
    
    // 1. 清空最大的 Y
    for (int i = 0;  i < self.columsCount;  i++) {
        NSString *colum = [NSString stringWithFormat: @"%d", i];
        self.maxYDict[colum] = @(self.sectionInset.top);
    }
    
    // 2. 计算所有 Cell 的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection: 0];
    for (NSInteger i = 0; i < count;  i++) {
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject: attrs];
    }
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (CGSize)collectionViewContentSize
{
    // 假设最短的那一列是第0列
    __block NSString *maxColum = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *colum, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColum] floatValue]) {
            maxColum = colum;
        }
    }];
    
    return CGSizeMake(0, [self.maxYDict[maxColum] floatValue] + self.sectionInset.bottom);
}

/**
 *  返回 indexPath 这个位置 Item 的布局属性
 *
 *  @param indexPath indexPath
 *
 *  @return  布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.item == 0) {
//        
//        // 创建属性
//        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
//        attrs.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
//        
//        return attrs;
//    }
    
    // 假设最短的那一列是第0列
    __block NSString *minColum = @"0";
    // 找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *colum, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDict[minColum] floatValue]) {
            minColum = colum;
        }
    }];
    
    // 计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columsCount - 1) * self.columnMargin) / self.columsCount;
    CGFloat height = [self.delegate waterfallLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 计算位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColum integerValue];
    CGFloat y = [self.maxYDict[minColum] floatValue] + self.rowMargin;
    
    // 更新当前列的最大的 Y
    self.maxYDict[minColum] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

/**
 *  返回 Rect 范围内的布局属性
 *
 *  @param rect  Rect
 *
 *  @return 布局属性
 */
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
//        NSLog(@"layoutAttributesForElementsInRect");
    
    return self.attrsArray;
}

@end
