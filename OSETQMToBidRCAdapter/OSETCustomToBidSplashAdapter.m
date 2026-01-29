//
//  OSETCustomToBidSplashAdapter.m
//  YhsADSProject
//
//  Created by Shens on 9/7/2025.
//

#import "OSETCustomToBidSplashAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <OSETSDK/OSETSDK.h>

@interface OSETCustomToBidSplashAdapter ()<OSETSplashAdDelegate>
@property (nonatomic, weak) id<AWMCustomSplashAdapterBridge> bridge;
@property (nonatomic, strong) OSETSplashAd *splashAd;
@property (nonatomic, strong) AWMParameter *parameter;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation OSETCustomToBidSplashAdapter
- (instancetype)initWithBridge:(id<AWMCustomSplashAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    self.parameter = parameter;
    self.splashAd = [[OSETSplashAd alloc] initWithSlotId:parameter.placementId window:nil bottomView:nil];
    self.splashAd.delegate = self;
    [self.splashAd loadSplashAd];

}
- (void)showSplashAdInWindow:(UIWindow *)window parameter:(AWMParameter *)parameter {
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    UIView *bottomView = [parameter.extra objectForKey: WindMillConstant.BottomView];
    if(!window){
        window = [UIApplication sharedApplication].keyWindow;
    }
    [self.splashAd showSplashAdWithWindow:window bottomView:bottomView];
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
//        [self.splashAd setPrice:@(result.winnerPrice)];
//        [self.splashAd win:@(result.winnerPrice)];
        WindmillLogDebug(@"OSET竞价成功", @"%@", NSStringFromSelector(_cmd));
    }else{
        WindmillLogDebug(@"OSET竞价失败", @"%@", NSStringFromSelector(_cmd));
    }
}
- (void)destory {
    [self removeSplashAdView];
}
- (void)removeSplashAdView {
    [self.splashAd description];
    self.splashAd = nil;
}
#pragma mark - OSETSplashAdDelegate

- (void)splashDidReceiveSuccess:(id)splashAd slotId:(NSString *)slotId{
    NSString *price = [NSString stringWithFormat:@"%ld",(long)self.splashAd.eCPM];
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAd:self didAdServerResponseWithExt:@{
        WindMillConstant.ECPM : price
    }];
    self.isReady = YES;
    [self.bridge splashAdDidLoad:self];
}

- (void)splashLoadToFailed:(id)splashAd error:(NSError *)error{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    self.isReady = NO;
    [self.bridge splashAd:self didLoadFailWithError:error ext:nil];
//    self.splashAd.delegate = nil;
//    self.splashAd = nil;
}

- (void)splashDidClick:(id)splashAd{
//    NSLog(@"OSETSDK click");
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge splashAdDidClick:self];
}

- (void)splashDidClose:(id)splashAd{
//    NSLog(@"OSETSDK close");
    WindmillLogDebug(@"OSET", @"%@ ", NSStringFromSelector(_cmd));
    self.splashAd.delegate = nil;
    self.splashAd = nil;
    [self.bridge splashAdDidClose:self];

}
- (void)splashAdExposured:(id)splashAd{
    [self.bridge splashAdWillVisible:self];
}
- (void)splashWillClose:(id)splashAd{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
}

- (void)dealloc {
    WindmillLogDebug(@"OSET", @"%s", __func__);
}

@end
