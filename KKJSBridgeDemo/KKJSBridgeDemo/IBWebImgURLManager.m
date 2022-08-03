//
//  WebImgURLManager.m
//  KKJSBridgeDemo
//
//  Created by devLiang on 2022/8/3.
//  Copyright © 2022 karosli. All rights reserved.
//

#import "IBWebImgURLManager.h"
#import <KKJSBridge/KKJSBridgeAjaxURLProtocol.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface IBWebImgURLManager()
@property (nonatomic, strong) NSMutableDictionary *imgUrlDic;
@end

@implementation IBWebImgURLManager
static IBWebImgURLManager *urlManager;
+ (instancetype)sharerInstance {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        urlManager = [[IBWebImgURLManager alloc] init];
        urlManager.imgUrlDic = [NSMutableDictionary dictionary];
        urlManager.imgArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:urlManager selector:@selector(loadImgUrl:) name:IBJSBridgeAjaxGetImgUrl object:nil];
    });
    
    return urlManager;
}

- (void)loadImgUrl:(NSNotification *)noti {
    NSString *uuidKey = self.uuidKey;
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *urlStr = (NSString *)obj;
        NSString *key = [NSString stringWithFormat:@"%@-%@", urlStr, uuidKey];
        [self.imgUrlDic setValue:urlStr forKey:key];
        NSLog(@"Liang downloadUrl uuid %@", uuidKey);
        [self downloadImgWithUrl:urlStr imgKey:key];
    }
}


static int imgCount = 0;
- (void)downloadImgWithUrl:(NSString *)imgUrl imgKey:(NSString *)imgKey {
    NSLog(@"Liang downloadUrl url %@ key %@", imgUrl, imgKey);
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            imgCount++;
            NSLog(@"Liang downloadUrl imgCount %d", imgCount);
        }
        if (image && [imgKey containsString:weakSelf.uuidKey]) {
            [weakSelf.imgArray addObject:image];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didDownLoadImage:)]) {
                [self.delegate didDownLoadImage:image];
            }
        }
    }];
}
@end
