//
//  OSETCustomToBidBannerAdapter.m
//  YhsADSProject
//
//  Created by Shens on 9/7/2025.
//

#import "OSETCustomToBidBannerAdapter.h"
#import <WindFoundation/WindFoundation.h>
#import <OSETSDK/OSETSDK.h>

@interface  OSETCustomToBidBannerAdapter()<OSETBannerAdDelegate>
@property (nonatomic, weak) id<AWMCustomBannerAdapterBridge> bridge;
@property (nonatomic,strong) OSETBannerAd *bannerAd;

@property (nonatomic, assign) BOOL isReady;
@end

@implementation OSETCustomToBidBannerAdapter
- (instancetype)initWithBridge:(id<AWMCustomBannerAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (void)loadAdWithPlacementId:(NSString *)placementId parameter:(AWMParameter *)parameter {
    NSString *sizeStr = [parameter.customInfo objectForKey:@"adSize"];
    CGSize adSize = CGSizeFromString(sizeStr);
    UIViewController *viewController = [self.bridge viewControllerForPresentingModalView];
    if (CGSizeEqualToSize(CGSizeZero, adSize)) {
        adSize = CGSizeMake(viewController.view.frame.size.width, 80);
    }else{
        if(adSize.width > viewController.view.frame.size.width){
            adSize.width = viewController.view.frame.size.width;
        }
        if(adSize.width < 100){
            adSize.width = 100;
        }
        if(adSize.height < 80){
            adSize.height = 80;
        }
    }
    self.bannerAd = [[OSETBannerAd alloc]initWithSlotId:parameter.placementId  rootViewController:viewController rect:CGRectMake(0, 0, adSize.width, adSize.height)];
    self.bannerAd.delegate = self;
    [self.bannerAd loadAdData];
}
- (BOOL)mediatedAdStatus {
    return self.isReady;
}
- (void)didReceiveBidResult:(AWMMediaBidResult *)result {
    if (result.win) {
        WindmillLogDebug(@"OSET-WindWill-竞价成功", @"%@", NSStringFromSelector(_cmd));
    }else{
        WindmillLogDebug(@"OSET-WindWill-竞价失败", @"%@", NSStringFromSelector(_cmd));
    }
}
- (void)destory {
    self.isReady = NO;
    self.bannerAd.delegate = nil;
    self.bannerAd = nil;
}

- (void)bannerDidReceiveSuccess:(id)bannerView slotId:(NSString *)slotId{
    WindmillLogDebug(@"OSET", @"%s", __func__);
    OSETBaseView * view = bannerView;
    if([bannerView isKindOfClass:[UIView class]]){
        view.frame = CGRectMake(0,0, view.frame.size.width,view.frame.size.height);
    }
    NSString *price = [NSString stringWithFormat:@"%ld",(long)view.eCPM];
    [self.bridge bannerAd:self didAdServerResponse:view ext:@{
        WindMillConstant.ECPM : price
    }];
    WindmillLogDebug(@"OSET", @"%s", __func__);
    self.isReady = YES;
    [self.bridge bannerAd:self didLoad:view];
}
/// banner加载失败
- (void)bannerLoadToFailed:(id)bannerView error:(NSError *)error{
    WindmillLogDebug(@"OSET", @"%s", __func__);
    self.isReady = NO;
    [self.bridge bannerAd:self didLoadFailWithError:error ext:nil];
}
-(void)bannerDidClick:(id)bannerView{
    WindmillLogDebug(@"OSET", @"%s", __func__);
    [self.bridge bannerAdDidClick:self bannerView:bannerView];

}
-(void)bannerDidClose:(id)bannerView{
    WindmillLogDebug(@"OSET", @"%s", __func__);
    [self.bridge bannerAdDidClosed:self bannerView:bannerView];

}


@end
