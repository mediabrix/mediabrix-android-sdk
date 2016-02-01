//
//  MBSettingDelegate.h
//  MediabrixUnityPlugin
//
//  Created by Amos Elmaliah on 11/19/12.
//  Copyright (c) 2013 MediaBrix inc. All rights reserved.
//

#import "MediaBrix.h"

@interface MBSettingDelegate : NSObject <
#ifdef MEDIABRIX_1_5_5
MediaBrixUserDefaults
#elif defined(MEDIABRIX_1_5)
MediaBrixUserDefaultsDelegate
#else
MediaBrixDeveloperConfigurationDelegate
#endif
>
@end
