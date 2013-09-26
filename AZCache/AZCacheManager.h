//
//  AZCacheManager.h
//  AZCache
//
//  Created by Zou Alex on 8/29/13.
//  Copyright (c) 2013 alex zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZCache.h"

extern NSString * const kAZSyncCacheDataNotification;
typedef NS_ENUM(NSInteger, AZCacheUseFrequencyLevel){
  kAZCacheUseFrequencyLevelLow = 0,
  kAZCacheUseFrequencyLevelNormal,
  kAZCacheUseFrequencyLevelHigh,
};

@interface AZCacheManager : NSObject

+ (void)cacheItem:(NSObject *)object itemKey:(NSString *)key;
+ (void)cacheItem:(NSObject *)object itemKey:(NSString *)key frequencyLevel:(AZCacheUseFrequencyLevel)level;
+ (id)fetchCachedItemForKey:(NSString *)key;

+ (void)removeCacheForKey:(NSString *)key;
+ (void)clearCache;

@end
