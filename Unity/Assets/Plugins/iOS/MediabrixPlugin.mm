//
//  MediabrixPlugin.m
//  MediabrixPlugin
//
//  Created by Amos Elmaliah on 1/8/13.
//  Copyright (c) 2013 MediaBrix inc. All rights reserved.
//

#import "MediabrixPlugin.h"
#import "MBSettingDelegate.h"
#import "MediaBrix.h"
#import <objc/message.h>

static NSString * const MediabrixPluginAppIDKey = @"appID";
static NSString * const MediabrixPluginBaseURLKey = @"baseURL";

NSDictionary * mb_dictionaryByAddingEntriesFromDictionary(NSDictionary* self, NSDictionary *dictionary) {
    
    NSDictionary* result = self;
    
    if (dictionary) {
        NSMutableDictionary* mutableSelf = self.mutableCopy;
        [mutableSelf addEntriesFromDictionary:dictionary];
        result = [mutableSelf copy] ;
    }
    // this will coerce the mutable class from returning its mutable self:
    return result;
}

 BOOL MBObjectIsEqualToObject( id object, id anotherObject) {
 
    NSCAssert(object, @"Expected object not to be nil");
    NSCAssert(anotherObject, @"Expected anotherObject not to be nil");
    
    SEL comparisonSelector;
    if ([object isKindOfClass:[NSString class]] && [anotherObject isKindOfClass:[NSString class]]) {
        comparisonSelector = @selector(isEqualToString:);
    } else if ([object isKindOfClass:[NSNumber class]] && [anotherObject isKindOfClass:[NSNumber class]]) {
        comparisonSelector = @selector(isEqualToNumber:);
    } else if ([object isKindOfClass:[NSDate class]] && [anotherObject isKindOfClass:[NSDate class]]) {
        comparisonSelector = @selector(isEqualToDate:);
    } else if ([object isKindOfClass:[NSArray class]] && [anotherObject isKindOfClass:[NSArray class]]) {
        comparisonSelector = @selector(isEqualToArray:);
    } else if ([object isKindOfClass:[NSDictionary class]] && [anotherObject isKindOfClass:[NSDictionary class]]) {
        comparisonSelector = @selector(isEqualToDictionary:);
    } else if ([object isKindOfClass:[NSSet class]] && [anotherObject isKindOfClass:[NSSet class]]) {
        comparisonSelector = @selector(isEqualToSet:);
    } else {
        comparisonSelector = @selector(isEqual:);
    }
    
    // Comparison magic using function pointers. See this page for details: http://www.red-sweater.com/blog/320/abusing-objective-c-with-class
    // Original code courtesy of Greg Parker
    // This is necessary because isEqualToNumber will return negative integer values that aren't coercable directly to BOOL's without help [sbw]
    BOOL (*ComparisonSender)(id, SEL, id) = (BOOL (*)(id, SEL, id))objc_msgSend;
    return ComparisonSender(object, comparisonSelector, anotherObject);
  
    

}

BOOL mb_isEqualToDictionary(NSDictionary *self, NSDictionary *dictionary) {
    
    __block BOOL isEqual = YES;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id myValue = self[key];
        if (!myValue || !MBObjectIsEqualToObject(myValue, obj)) {
            isEqual = NO;
            *stop = YES;
        }
    }];
    return isEqual;
}

@class MediabrixPlugin;
typedef void(^unityCallback)(BOOL success, NSString* identifier, MediabrixPlugin* plugin);

UIViewController *UnityGetGLViewController();

@interface MediabrixPluginAd : NSObject
@property (nonatomic, copy) NSDictionary* target;
@property (copy) NSDictionary* adData;
@property (nonatomic, unsafe_unretained) UIViewController<MediaBrixAdViewController>* viewController;

@property (nonatomic) BOOL shouldShowWhenReady;
@property (nonatomic) BOOL shouldReloadWhenDone;
@property (nonatomic) BOOL isReady;
@property (nonatomic) BOOL isShowing;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL failed;
@property (nonatomic) int loadCount;
@property (nonatomic) int showCount;
@property (nonatomic, copy) unityCallback didLoadCallback;
@property (nonatomic, copy) unityCallback willShowCallback;
@property (nonatomic, copy) unityCallback didCloseCallback;
@property (nonatomic, copy) unityCallback rewardCallback;

-(void)prepareForReuse;

@end

@protocol MediabrixPluginDelegate <NSObject>
@optional
-(void)adHandler:(MediabrixPlugin*)adHandler willChageStatusForIdentifier:(NSString*)identifier;
-(void)adHandler:(MediabrixPlugin*)adHandler didChageStatusForIdentifier:(NSString*)identifier;

-(void)adHandlerDidBecomeAvailable:(MediabrixPlugin*)adHandler;
-(void)adHandlerDidBecomeUnavailable:(MediabrixPlugin*)adHandler;

-(void)adHandler:(MediabrixPlugin*)adHandler willLoadTargetIdentifier:(NSString*)adIdentifier;
-(void)adHandler:(MediabrixPlugin*)adHandler didFinishLoadingAdWithIdenitifer:(NSString*)adIdentifier;
-(void)adHandler:(MediabrixPlugin*)adHandler failedLoadingAdWithIdentifier:(NSString*)adIdentifier;
-(void)adHandler:(MediabrixPlugin*)adHandler willShowAdWithIdentifier:(NSString*)adIdentifier;
-(void)adHandler:(MediabrixPlugin*)adHandler didShowAdWithIdentifier:(NSString*)adIdentifier;

@end

@implementation MediabrixPluginAd

-(id)init {
    self = [super init];
    if (self) {
        self.loadCount = 0;
        self.showCount = 0;
        [self prepareForReuse];
    }
    return self;
}

-(void)prepareForReuse {
    
    self.target = nil;
    self.adData = nil;
    self.viewController = nil;
    
    self.shouldShowWhenReady = NO;
    self.shouldReloadWhenDone = NO;
    self.isReady = NO;
    self.isShowing = NO;
    self.isLoading = NO;
    self.failed = NO;
    
    self.didLoadCallback = nil;
    self.willShowCallback = nil;
    self.didCloseCallback = nil;
    self.rewardCallback = nil;

}
/*
-(void)dealloc {

    [self prepareForReuse];
    [super dealloc];
}
*/
@end

@interface MediabrixPlugin ()

@property (nonatomic, strong) NSDictionary* defaultAdData;
@property (nonatomic, unsafe_unretained) id<MediabrixPluginDelegate>delegate;
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic) int rewards;
@property (nonatomic) BOOL session;

@end

@implementation MediabrixPlugin

#define MediabrixTestTarget(dictionary) \
NSAssert1(dictionary && [dictionary isKindOfClass:[NSDictionary class]] || dictionary[kMediabrixTargetAdTypeKey], @"mediabrix - invalid target:%@", target);

-(id)init {
    self = [super init];
    if (self) {
        
#ifdef MEDIABRIX_1_5
        [MediaBrix setUserDefaultDelegateClass:[MBSettingDelegate class]];
        [MediaBrix sharedInstance];
        self.defaultAdData = [[MediaBrix userDefaultsDelegate] defaultAdData];
#elif defined(MEDIABRIX_1_5_5)
        [MediaBrix setUserDefaultsClass:[MBSettingDelegate class]];
        [MediaBrix sharedInstance];
        self.defaultAdData = [[MediaBrix userDefaults] defaultAdData];
#endif
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adWillLoad:) name:kMediaBrixAdWillLoadNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adDidLoad:) name:kMediaBrixAdDidLoadNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adFailed:) name:kMediaBrixAdFailedNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adReady:) name:kMediaBrixAdReadyNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adShow:) name:kMediaBrixAdShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adClose:) name:kMediaBrixAdDidCloseNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adRewardConfirmation:) name:kMediaBrixAdRewardNotification object:nil];

        _ads = [[NSArray alloc] init];
    }
    return self;
}

-(UIViewController*)viewController {
	return UnityGetGLViewController();
}

-(NSString*)identifierForTarget:(NSDictionary*)target {
    return target[kMediabrixTargetAdTypeKey];
}

-(NSString*)identifierForAd:(MediabrixPluginAd*)ad {
    return ad.target[kMediabrixTargetAdTypeKey];
}


-(MediabrixPluginAd*)createAdForTarget:(NSDictionary*)target {
    MediabrixTestTarget(target)
    MediabrixPluginAd* result = nil;
    if (target) {
        result = [[MediabrixPluginAd alloc] init];
        result.target = target;
        NSMutableArray* mutableAds = [self.ads mutableCopy];
        [mutableAds addObject:result];
        
        @synchronized(self) {
           // [_ads release];
            _ads = mutableAds.copy;
        }
        
       // [mutableAds release];
    }
    
    return result;
}

-(MediabrixPluginAd*)adForTarget:(NSDictionary*)target {
    __block MediabrixPluginAd* result = nil;
    if (target) {
        for (MediabrixPluginAd* ad in self.ads) {
            if (mb_isEqualToDictionary(ad.target, target)) {
                result = ad;
                break;
            }
        }
    }
    
    return result;
}

-(MediabrixPluginAd*)adForNotification:(NSNotification*)notification
{
    MediabrixPluginAd* ad = nil;
    id object = [notification object];
    if (object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            ad = [self adForTarget:object];
        } else if([object isKindOfClass:[UIViewController class]] && [object conformsToProtocol:@protocol(MediaBrixAdViewController)]) {
            ad = [self adForTarget:[(NSObject<MediaBrixAdViewController>*)object target]];
        } else if([object isKindOfClass:NSClassFromString(@"MBAdState")]) {
            ad = [self adForTarget:[object target]];
        }
    }
    return ad;
}

-(void)reset
{
    for (MediabrixPluginAd* ad in self.ads)
    {
        NSString* adIdentifier = [self identifierForAd:ad];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self willChageStatusForIdentifier:adIdentifier];
        }
        
        [ad prepareForReuse];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self didChageStatusForIdentifier:adIdentifier];
        }
    }
}

-(NSDictionary*)baselineAdDataByAppendingDiciontaryWithEntries:(NSDictionary*)adData
{
    NSAssert(self.defaultAdData, @"You must defina a default Ad Data Object");
    
    return mb_dictionaryByAddingEntriesFromDictionary(self.defaultAdData, adData);
}


-(void) loadAd:(MediabrixPluginAd*)ad
{
    if(!ad.isReady && !ad.isLoading && ad.target) {

        NSString* adIdentifier = [self identifierForAd:ad];

        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self willChageStatusForIdentifier:adIdentifier];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willLoadTargetIdentifier:)]) {
            [self.delegate adHandler:self willLoadTargetIdentifier:adIdentifier];
        }
        
        [[MediaBrix sharedInstance] loadAdWithTarget:ad.target];
        
        ad.isLoading = YES;
        ad.failed = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self didChageStatusForIdentifier:adIdentifier];
        }
    }
}


-(void) loadAdWithIdentifier:(NSString*)adIdentifier adDidLoadCallback:(unityCallback)block
{
    [self loadAdWithWithIdentifier:adIdentifier target:nil adData:nil adDidLoadCallback:block];
}


-(NSDictionary*)targetWithIdentifier:(NSString*)adIdentifier {
    
    __block NSDictionary* targetStub = @{kMediabrixTargetAdTypeKey:adIdentifier};
    
    for (NSString* key in @[MediabrixPluginAppIDKey, MediabrixPluginBaseURLKey]) {
        id value = self.defaultAdData[key];
        if (value) {
            targetStub = mb_dictionaryByAddingEntriesFromDictionary(targetStub ,@{key: value});
        }
    }

    return targetStub;
}

-(void)loadAdWithWithIdentifier:(NSString *)adIdentifier target:(NSDictionary *)target adData:(NSDictionary *)adData adDidLoadCallback:(unityCallback)didLoadCallback {
    
    MediabrixPluginAd* ad = nil;
    if (target && adIdentifier) {
        MediabrixTestTarget(target)

        ad = [self adForTarget:target];
        if (!ad) {
            ad = [self createAdForTarget:target];
        }
    } else if(adIdentifier) {
        target = [self targetWithIdentifier:adIdentifier];
        ad = [self adForTarget:target];

        if (!ad) {
            ad = [self createAdForTarget:target];
        }
        
    } else if(target) {

        MediabrixTestTarget(target)
        
        ad = [self adForTarget:target];
        if (!ad) {
            ad = [self createAdForTarget:target];
        }
    }
    
    if (ad) {
        NSArray* keys = @[@"LogOutButton",
                          @"useMBbutton",
                          @"rescueTitle",
                          @"rescueText",
                          @"enticeText",
                          @"title",
                          @"confirmText",
                          @"iconURL",
                          @"showConfirmation",
                          @"rewardText",
                          @"rewardIcon",
                          @"optinbuttonText",
                          @"loadingText",
                          @"achievementText",
                          @"allowGeo",
                          @"allowCalendar",
                          @"allowCamera"
                          ];

        
        adData = adData && [adData isKindOfClass:[NSDictionary class]] ? adData : [self.defaultAdData dictionaryWithValuesForKeys:keys];
        if (ad.adData && adData) {
            ad.adData = mb_dictionaryByAddingEntriesFromDictionary(ad.adData, adData);
        } else if(adData){
            ad.adData = adData;
        }
        ad.didLoadCallback = didLoadCallback;
        [self loadAd:ad];
    }
}

- (void)showAdWithIdentifier:(NSString *)adIdentifier willShowCallback:(unityCallback)willShowCallback rewardsCallback:(unityCallback)rewardsCallack didCloseCallback:(unityCallback)didCloseCallback {
    
    NSDictionary* target = [self targetWithIdentifier:adIdentifier];
    MediabrixPluginAd* ad = [self adForTarget:target];
    if (ad) {
        if (!ad.isReady) {
            ad.shouldShowWhenReady = YES;
            [self loadAd:ad];
        } else {
            ad.didCloseCallback = didCloseCallback;
            ad.rewardCallback = rewardsCallack;
            ad.willShowCallback = willShowCallback;
            [self showAd:ad];
        }
    }
}

- (void)showAd:(MediabrixPluginAd*)ad {
    
    UIViewController<MediaBrixAdViewController>* viewController = ad.viewController;
    if (viewController && ad.isReady) {
        
        NSString* adIdentifier = [self identifierForAd:ad];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self willChageStatusForIdentifier:adIdentifier];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willShowAdWithIdentifier:)]) {
            [self.delegate adHandler:self willShowAdWithIdentifier:adIdentifier];
        }
        if (ad.willShowCallback) {
            ad.willShowCallback(YES, adIdentifier,self);
        }
        
        ad.isShowing = YES;
        ad.isReady = NO;
        ad.isLoading = NO;

        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self didChageStatusForIdentifier:adIdentifier];
        }
        
        [viewController setAdData:[self baselineAdDataByAppendingDiciontaryWithEntries:ad.adData]];
        [viewController showInViewController:[self viewController]];
    }
}

- (void)adDidLoad:(NSNotification *)notification {

    NSLog(@"adDidLoad %@", notification.object);
}

-(void)didFailLoadingAdNotification:(NSNotification *)notification {
    
    MediabrixPluginAd* ad = [self adForNotification:notification];

    if (ad) {
        
        NSString* adIdentifier = [self identifierForAd:ad];
        
        unityCallback didLoadCallback = [ad.didLoadCallback copy] ;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self willChageStatusForIdentifier:adIdentifier];
        }
        [ad prepareForReuse];
        ad.failed = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self didChageStatusForIdentifier:adIdentifier];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:failedLoadingAdWithIdentifier:)]) {
            [self.delegate adHandler:self failedLoadingAdWithIdentifier:adIdentifier];
        }
        
        if (didLoadCallback) {
            didLoadCallback(NO, adIdentifier, self);
        }

    }
}

-(void)didLoadAdViewController:(UIViewController<MediaBrixAdViewController>*)viewController {

    MediabrixPluginAd* ad = [self adForTarget:[viewController target]];

    if (ad) {

        NSString* adIdentifier = [self identifierForAd:ad];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self willChageStatusForIdentifier:adIdentifier];
        }
        ad.failed = NO;
        ad.isLoading = NO;
        ad.isReady = YES;
        ad.isShowing = NO;
        ad.viewController = viewController;
        ad.loadCount++;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self didChageStatusForIdentifier:adIdentifier];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didFinishLoadingAdWithIdenitifer:)]) {
            [self.delegate adHandler:self didFinishLoadingAdWithIdenitifer:adIdentifier];
        }
        if (ad.didLoadCallback) {
            ad.didLoadCallback(YES, adIdentifier, self);
        }
        
        if (ad.shouldShowWhenReady) {
            [self showAd:ad];
        }
    }
}

-(void)didReceiveRewardConfirmationNotification:(NSNotification*)notification {
    
    self.rewards++;
    MediabrixPluginAd* ad = [self adForNotification:notification];
    NSString* adIdentifier = [self identifierForAd:ad];
    if (ad && adIdentifier && ad.rewardCallback) {
        ad.rewardCallback(YES, adIdentifier, self);
    }
}

-(void)didShowAdNotification:(NSNotification*)notification {
    
    MediabrixPluginAd* ad = [self adForNotification:notification];
    if (ad) {
        
        NSString* adIdentifier = [self identifierForAd:ad];

        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:willChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self willChageStatusForIdentifier:adIdentifier];
        }
        ad.isShowing = NO;
        ad.isReady = NO;
        ad.isLoading = NO;
        ad.showCount++;
        ad.viewController = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didChageStatusForIdentifier:)]) {
            [self.delegate adHandler:self didChageStatusForIdentifier:adIdentifier];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(adHandler:didShowAdWithIdentifier:)]) {
            [self.delegate adHandler:self didShowAdWithIdentifier:adIdentifier];                                        // adHandler (?)... not right
        }
        if (ad.didCloseCallback) {
            ad.didCloseCallback(YES, adIdentifier, self);
        }
        if (ad.shouldReloadWhenDone) {
            __block MediabrixPlugin* weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf) {
                    __strong MediabrixPlugin* strongSelf = weakSelf;
                    ad.shouldShowWhenReady = NO;
                    [strongSelf loadAd:ad];
                }
            });
        }
    }
}

#pragma MediaBrix notifications

- (void)adWillLoad:(NSNotification *)notification {
}

- (void)adFailed:(NSNotification *)notification {
    NSLog(@"adDidFail, %@", notification);
    [self didFailLoadingAdNotification:notification];
}

- (void)adReady:(NSNotification *)notification {
    UIViewController<MediaBrixAdViewController> *viewController = [notification object];
    [self didLoadAdViewController:viewController];
}

- (void)adShow:(NSNotification *)notification {
}

- (void)adClose:(NSNotification *)notification {
    [self didShowAdNotification:notification];
}

- (void)adRewardConfirmation:(NSNotification *)notification {

    [self didReceiveRewardConfirmationNotification:notification];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.defaultAdData = nil;
    self.delegate = nil;
    self.ads = nil;
   // [super dealloc];
}

#pragma mark Public Plugin Calls

-(void)startSession:(unityCallback)block {

	
	if (!self.session) {
		self.session = YES;
	}
    if (block) {
        block(YES, nil, self);
    }
}

-(void) setValue:(id)value forKey:(id)key {

    NSDictionary* dict = mb_dictionaryByAddingEntriesFromDictionary(self.defaultAdData ? : @{}, @{key:value});
    
    @synchronized(self) {
       // [_defaultAdData release];
        //_defaultAdData = [dict retain];
    }
}

@end

static const char* serviceReadyCallbackName     = "OnStarted";
static const char* didLoadCallbackName          = "OnAdReady";
static const char* didFailLoadCallbackName      = "OnAdUnavailable";
static const char* willShowAdCallbackName       = "onAdWillShow";
static const char* adDidCloseCallbackName       = "OnAdClosed";
static const char* rewardDidChangeCallbackName  = "OnAdRewardConfirmation";

static NSString* __callback = nil;
extern void UnitySendMessage(const char* obj, const char* method, const char* msg);

static void unity_callback(const char* method, const char* msg) {
    if (__callback) {
        UnitySendMessage([__callback UTF8String],method, msg);
    }
}

static MediabrixPlugin* getPlugin() {
    static MediabrixPlugin* plugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plugin = [[MediabrixPlugin alloc] init];
    });
    return plugin;
}

static NSString* mb_objcstring(const char* string) {
    
	return [NSString stringWithUTF8String:string ? : ""];
}

static NSDictionary* mb_ComponentSeparatedKeyValueFromStringWithSeparator(const char* string, const char* separator) {
    
    NSMutableDictionary* result = nil;
    if (string && separator) {
        NSArray* array = [mb_objcstring(string) componentsSeparatedByString:mb_objcstring(separator)];
        if (array && array.count % 2 == 1) {
            int max = floorf((array.count / 2) * 2);
            for (int i = 0; i < max; i +=2) {
                if (!result) {
                    result = [[NSMutableDictionary alloc] init] ;
                }
                result[array[i]] = array[i+1];
            }
        }
    }
    return [result copy];
}


// When native code plugin is implemented in .mm / .cpp file, then functions
// should be surrounded with extern "C" block to conform C function naming rules
#ifdef __cplusplus
extern "C" {

    void mb_initialize_unity (const char* base_url, const char* app_id, const char* callbackHandlerName) {
        
        [getPlugin() setValue:mb_objcstring(app_id) forKey:MediabrixPluginAppIDKey];
		[getPlugin() setValue:mb_objcstring(base_url) forKey:MediabrixPluginBaseURLKey];
        
        NSString*objcString = mb_objcstring(callbackHandlerName);
		if (![__callback isEqualToString:objcString]) {
            //[__callback release];
			__callback = [objcString copy];
        }
        unity_callback(serviceReadyCallbackName, "test");
    }
    
    void mb_load_ad_with_identifier(const char* identifer, const char* key_value_pairs_null_terminated) {
        NSDictionary* adData = mb_ComponentSeparatedKeyValueFromStringWithSeparator(key_value_pairs_null_terminated, "|");
        [getPlugin() loadAdWithWithIdentifier:mb_objcstring(identifer) target:nil adData:adData adDidLoadCallback:^(BOOL success, NSString *identifier, MediabrixPlugin *plugin) {
            unity_callback(success ? didLoadCallbackName : didFailLoadCallbackName, [identifier UTF8String]);
        }];
    }
    
    void mb_show_ad_with_identifier(const char* identifer, void * context) {
        [getPlugin() showAdWithIdentifier:mb_objcstring(identifer) willShowCallback:^(BOOL success, NSString *identifier, MediabrixPlugin *plugin) {
            unity_callback(willShowAdCallbackName, [identifier UTF8String]);
        } rewardsCallback:^(BOOL success, NSString *identifier, MediabrixPlugin *plugin) {
			unity_callback(rewardDidChangeCallbackName, [identifier UTF8String]);
        } didCloseCallback:^(BOOL success, NSString *identifier, MediabrixPlugin *plugin) {
            unity_callback(adDidCloseCallbackName, [identifier UTF8String]);
        }];
    }
}

#endif

