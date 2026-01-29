//
//  OSETCustomToBidRewardAdapter.m
//  YhsADSProject
//
//  Created by Shens on 9/7/2025.
//

#import "OSETCustomToBidRewardAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <OSETSDK/OSETSDK.h>
@interface OSETCustomToBidRewardAdapter ()<OSETRewardVideoAdDelegate>
@property (nonatomic, weak) id<AWMCustomRewardedVideoAdapterBridge> bridge;
@property (nonatomic, strong) OSETRewardVideoAd *rewardAd;
@property (nonatomic, strong) AWMParameter *parameter;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation OSETCustomToBidRewardAdapter
- (instancetype)initWithBridge:(id<AWMCustomRewardedVideoAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (BOOL)mediatedAdStatus {
    if(self.rewardAd && self.rewardAd.isAdValid){
        return self.rewardAd.isAdValid;
    }
    return NO;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    self.parameter = parameter;
    WindMillAdRequest *request = [self.bridge adRequest];
    self.rewardAd = [[OSETRewardVideoAd alloc] initWithSlotId:parameter.placementId  withUserId:request.userId];
    self.rewardAd.delegate = self;
    [self.rewardAd loadRewardAdData];
   
}

/// 展示广告的方法
/// @param viewController 控制器对象
/// @param parameter 展示广告的参数，由ToBid接入媒体配置
- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(AWMParameter *)parameter{
    WindmillLogDebug(@"OSET-WindWill", @"%@", NSStringFromSelector(_cmd));
    if(self.rewardAd.isAdValid  && viewController){
        [self.rewardAd showRewardFromRootViewController:viewController];
        return YES;
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
    [self removeRewardAd];
}
- (void)removeRewardAd {
    self.rewardAd.delegate = nil;
    self.rewardAd = nil;
}

- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    NSString *price = [NSString stringWithFormat:@"%ld",(long)self.rewardAd.eCPM + 10000];
    [self.bridge rewardedVideoAd:self didAdServerResponseWithExt:@{
        WindMillConstant.ECPM : price
    }];
    [self.bridge rewardedVideoAdDidLoad:self];
}


- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAd:self didLoadFailWithError:error ext:nil];
}

- (void)rewardVideoDidClick:(nonnull id)rewardVideoAd {
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAdDidClick:self];
}
/// 激励视频关闭
- (void)rewardVideoDidClose:(id)rewardVideoAd checkString:(NSString *)checkString{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAdDidClose:self];
}
//激励视频播放结束
- (void)rewardVideoPlayEnd:(id)rewardVideoAd  checkString:(NSString *)checkString{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAd:self didPlayFinishWithError:nil];

}
//激励视频播放出错
- (void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAd:self didPlayFinishWithError:error];
}
//激励视频开始播放
- (void)rewardVideoPlayStart:(id)rewardVideoAd checkString:(nonnull NSString *)checkString{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    [self.bridge rewardedVideoAdDidVisible:self];

}
//激励视频奖励 //checkString 将在OSETRewardVideoAd对象 loadAdData 后失效
- (void)rewardVideoOnReward:(id)rewardVideoAd checkString:(NSString *)checkString{
    WindmillLogDebug(@"OSET", @"%@", NSStringFromSelector(_cmd));
    WindMillRewardInfo *info = [[WindMillRewardInfo alloc] initWithIsCompeltedView:YES];
    [self.bridge rewardedVideoAd:self didRewardSuccessWithInfo:info];
}


@end
