//
//  MBSettingDelegate.n
//  MediabrixUnityPlugin
//
//  Created by Amos Elmaliah on 11/19/12.
//  Copyright (c) 2013 MediaBrix inc. All rights reserved.
//

#import "MBSettingDelegate.h"

@implementation MBSettingDelegate

#if !defined(MEDIABRIX_1_5) && !defined(MEDIABRIX_1_5_5)
-(NSDictionary*)mediaBrixEnvironment
{
    NSString* configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
	configuration  = configuration ? : @"Debug";
    NSAssert(configuration, @"missing field name Configuration in info.plist");
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* envsPListPath = [bundle pathForResource:@"MediaBrix.bundle/MediaBrix.plist" ofType:nil];
    NSAssert(envsPListPath, @"missing file with name MediaBrix.plist in bundle");
    
    NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    NSAssert(environments, @"missing file with name MediaBrix.plist");
    
    NSDictionary* environment = [environments objectForKey:configuration];
    NSAssert1(environment, @"missing dictionary for key: %@ in file MediaBrix.plist", configuration);
    return environment;
}
#endif

-(NSString *)appID
{
#if !defined(MEDIABRIX_1_5) && !defined(MEDIABRIX_1_5_5)
    NSDictionary* environment = [self mediaBrixEnvironment];
    NSString* appID = [environment valueForKey:@"appID"];
    NSAssert1(appID, @"missing dictionary for key: appID in file MediaBrix.plist ->%@",environment);
    return appID;
#else
    return @"BYSYOJsMxP";
#endif
}

-(NSURL *)baseURL
{
#if !defined(MEDIABRIX_1_5) && !defined(MEDIABRIX_1_5_5)
    NSDictionary* environment = [self mediaBrixEnvironment];
    NSString* baseURLString = [environment valueForKey:@"baseURL"];
    NSAssert1(baseURLString, @"missing dictionary for key: baseURL in file MediaBrix.plist ->%@",environment);
    
    NSURL* baseURL = [NSURL URLWithString:baseURLString];
    NSAssert1(baseURL, @"bad strtging with URL %@", baseURLString);
    return baseURL;
#else
    return [NSURL URLWithString:@"http://mobile.mediabrix.com/v2/manifest"];
#endif
}

-(NSString *)property
{
#if !defined(MEDIABRIX_1_5) && !defined(MEDIABRIX_1_5_5)
    NSDictionary* environment = [self mediaBrixEnvironment];
    NSString* property = [environment valueForKey:@"property"];
    NSAssert1(property, @"missing dictionary for key: path in file MediaBrix.plist ->%@",environment);
    return property;
#else
    return @"Mobile_15_IOS";
#endif
}

-(NSBundle *)bundle
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"MediaBrix"
                                                     ofType:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithPath:path];
    NSAssert(bundle, @"no bundle found");
    
    return bundle;
    
}

-(NSString*)localizedStringForKey:(NSString*)key
{
    NSBundle* bundle = [self bundle];
    return [bundle localizedStringForKey:key value:nil table:nil];
}

#if !defined( MEDIABRIX_1_5) && !defined( MEDIABRIX_1_5_5)
-(NSDictionary*)localizedResources
{
    
    NSDictionary* read = @{@"useMBbutton": @"MBSV:useMBbutton",
    @"enticeText": @"MBSV:enticeText",
    @"title": @"MBSV:title",
    @"confirmText": @"MBSV:confirmText",
    @"iconURL": @"MBSV:iconURL",
    @"showConfirmation": @"MBSV:showConfirmation"};
    
    NSMutableDictionary* dict = [[NSMutableDictionary new] autorelease];
    
    [read enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString* localizedString = [self localizedStringForKey:obj];
        NSAssert1(localizedString, @"missing localized string for key: %@", obj);
        [dict setObject:localizedString forKey:key];
    }];
    
    return dict;
}
#else
-(NSDictionary*)defaultAdData
{
    
    NSArray* adDataKeys = @[@"LogOutButton",
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

    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [adDataKeys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
        NSString* localizedString = [self localizedStringForKey:key];
        NSAssert1(localizedString, @"missing localized string for key: %@", key);
        [dict setObject:localizedString forKey:key];
    }];
    
    return dict;
}
#endif

-(NSString *)uid
{
    return @"example uid";
}

-(NSString *)facebookAppID
{
    NSString* facebookAppID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookAppID"];
    return facebookAppID;
}

@end
