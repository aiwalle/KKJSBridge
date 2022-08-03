//
//  WebImgURLManager.h
//  KKJSBridgeDemo
//
//  Created by devLiang on 2022/8/3.
//  Copyright © 2022 karosli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IBWebImgURLManagerDelegate <NSObject>

@optional

- (void)didDownLoadImage:(UIImage *)image;
@end

@interface IBWebImgURLManager : NSObject
+ (instancetype)sharerInstance;
@property (nonatomic, weak) id<IBWebImgURLManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, copy) NSString *uuidKey;
@end

NS_ASSUME_NONNULL_END
