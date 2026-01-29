//
//  OSETCustomToBidInterstitialAdapter.m
//  YhsADSProject
//
//  Created by Shens on 9/7/2025.
//

#import "OSETCustomToBidInterstitialAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <OSETSDK/OSETSDK.h>

@interface OSETCustomToBidInterstitialAdapter ()<OSETInterstitialAdDelegate>
@property (nonatomic, weak) id<AWMCustomInterstitialAdapterBridge> bridge;
@property (nonatomic, strong) OSETInterstitialAd *interstitialAd;
@property (nonatomic, strong) AWMParameter *parameter;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation OSETCustomToBidInterstitialAdapter
- (instancetype)initWithBridge:(id<AWMCustomInterstitialAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    if(self.interstitialAd && self.interstitialAd.isAdValid){
        return self.interstitialAd.isAdValid;
    }
    return NO;
}

- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        WindmillLogDebug(@"OSET-WindWill-竞价成功", @"%@", NSStringFromSelector(_cmd));
    }else{
        WindmillLogDebug(@"OSET-WindWill-竞价失败", @"%@", NSStringFromSelector(_cmd));
    }
}
- (void)destory {
    [self removeInterstitialAd];
}
- (void)removeInterstitialAd {
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    self.parameter = parameter;
    self.interstitialAd = [[OSETInterstitialAd alloc] initWithSlotId:parameter.placementId];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadInterstitialAdData];
    WindmillLogDebug(@"OSET-WindWill--loadInterstitialAdData",@"%@",NSStringFromSelector(_cmd));
}
/// 展示广告的方法
/// @param viewController 控制器对象
/// @param parameter 展示广告的参数，由ToBid接入媒体配置
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter{
    WindmillLogDebug(@"OSET-WindWill", @"%@", NSStringFromSelector(_cmd));
    if(self.interstitialAd.isAdValid && viewController){
        [self.interstitialAd showInterstitialFromRootViewController:viewController];
        return YES;
    }
    return NO;
}
- (void)interstitialDidReceiveSuccess:(nonnull id)interstitialAd slotId:(nonnull NSString *)slotId {
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [NSString stringWithFormat:@"%ld",(long)self.interstitialAd.eCPM];
    [self.bridge interstitialAd:self didAdServerResponseWithExt:@{
        WindMillConstant.ECPM : price
    }];
    [self.bridge interstitialAdDidLoad:self];
}

- (void)interstitialLoadToFailed:(nonnull id)interstitialAd error:(nonnull NSError *)error {
    [self.bridge interstitialAd:self didLoadFailWithError:error ext:@{}];
}

- (void)interstitialDidClick:(nonnull id)interstitialAd {
    [self.bridge interstitialAdDidClick:self];
}

- (void)interstitialDidClose:(nonnull id)interstitialAd {
    [self.bridge interstitialAdDidClose:self];
}
- (void)interstitialExposured:(id)interstitialAd{
    [self.bridge interstitialAdDidVisible:self];
}
@end
