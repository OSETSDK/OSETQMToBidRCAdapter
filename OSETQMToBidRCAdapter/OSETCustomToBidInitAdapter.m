//
//  OSETCustomToBidInitAdapter.m
//  YhsADSProject
//
//  Created by Shens on 9/7/2025.
//

#import "OSETCustomToBidInitAdapter.h"
#import <OSETSDK/OSETSDK.h>

@interface OSETCustomToBidInitAdapter ()
@property (nonatomic, weak) id<AWMCustomConfigAdapterBridge> bridge;
@end



@implementation OSETCustomToBidInitAdapter
- (instancetype)initWithBridge:(id<AWMCustomConfigAdapterBridge>)bridge {
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}
- (AWMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return  [AWMCustomAdapterVersion V2_0];
}
- (NSString *)adapterVersion {
    return @"2.0.0";
}
- (NSString *)networkSdkVersion {
    return [OSETManager version];
}
- (void)initializeAdapterWithConfiguration:(AWMSdkInitConfig *)initConfig {
    NSString *appId = [initConfig.extra objectForKey:@"appId"];
    if(appId && appId.length == 16){
//        WindmillLogDebug(@"OSETT-SDK初始化", @"%@ ", NSStringFromSelector(_cmd));
        [OSETManager configure:appId];
        [self.bridge initializeAdapterSuccess:self];
    }else{
//        WindmillLogDebug(@"初始化appId有误，请检查配置", @"%@ ", NSStringFromSelector(_cmd));
        NSError *error = [NSError errorWithDomain:@"初始化错误" code:70001 userInfo:@{NSLocalizedDescriptionKey:@"初始化appId有误，请检查配置", NSLocalizedFailureReasonErrorKey:@"初始化appId有误，请检查配置"}];
        [self.bridge initializeAdapterFailed:self error:error];
    }
    
}
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    WindMillPersonalizedAdvertisingState personalizedAdvertisingState = [WindMillAds getPersonalizedAdvertisingState];
}
@end
