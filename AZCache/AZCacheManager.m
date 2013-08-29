//
//  AZCacheManager.m
//  AZCache
//
//  Created by Zou Alex on 8/29/13.
//  Copyright (c) 2013 alex zou. All rights reserved.
//

#import "AZCacheManager.h"
#import "AZCache.h"

NSString* const kAZSyncCacheDataNotification = @"kSyncAZCacheDataNotification";

@interface AZCacheManager (/*Private Methods*/)
+(NSString*) cachesDirectory;
+ (NSString *)cachePathForKey:(NSString *)key;
@end

@implementation AZCacheManager

static NSString *const kCachesDirectoryName = @"AZCacheManager";
static NSString *const kCacheFileFormatString = @"archive";
static NSMutableDictionary *memoryCaches;
static NSMutableArray *recentAccessedKeys;
static int kCacheMemoryLimit = 10;

#pragma mark - Setup
+(void) initialize {
  NSString *cachesDirectory = [self cachesDirectory];
  if(![[NSFileManager defaultManager] fileExistsAtPath:cachesDirectory])
  {
    [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
  }
  memoryCaches = [[NSMutableDictionary alloc] init];
  recentAccessedKeys = [[NSMutableArray alloc] init];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAllMemoryCacheToDisk)
                                               name:UIApplicationDidReceiveMemoryWarningNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAllMemoryCacheToDisk)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAllMemoryCacheToDisk)
                                               name:UIApplicationWillTerminateNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAllMemoryCacheToDisk) name:kAZSyncCacheDataNotification object:nil];
}

+ (void)dealloc {
  memoryCaches = nil;
  recentAccessedKeys = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods
+ (void)cacheItem:(NSObject *)object itemKey:(NSString *)key frequencyLevel:(AZCacheUseFrequencyLevel)level {
  AZCacheStoreType cacheStoreType = [self storeTypeWithFrequencyLevel:level];
  AZCache *cache = [[AZCache alloc] initWithObject:object cacheKey:key cacheType:cacheStoreType];
  if (cache.cacheType == kAZCacheStoreInDiskAndRAM) {
    [self storeCacheInMemory:cache];
  }
  else {
    [self removeCacheInMemory:cache.cacheKey];
    [self storeCacheInDisk:cache];
  }
}

+ (id)fetchCachedItemForKey:(NSString *)key {
  return [[self cacheForKey:key] object];
}

+ (void)removeCacheForKey:(NSString *)key {
  [self removeCacheInMemory:key];
  [self removeCacheInDisk:key];
}

+ (void)clearCache {
  NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cachesDirectory] error:nil];
  for (NSString *path in cachedItems) {
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
  }
  [memoryCaches removeAllObjects];
  [recentAccessedKeys removeAllObjects];
}

#pragma mark - private methods
+ (void)storeCacheInMemory:(AZCache *)cache {
  NSString *cacheKey = cache.cacheKey;
  [memoryCaches setObject:cache forKey:cacheKey];
  if ([recentAccessedKeys containsObject:cacheKey]) {
    [recentAccessedKeys removeObject:cacheKey];
  }
  [recentAccessedKeys insertObject:cacheKey atIndex:0];
  
  if ([recentAccessedKeys count] > kCacheMemoryLimit) {
    NSString *leastRecentUsedDataKey = [recentAccessedKeys lastObject];
    AZCache *leastRecentUsedCache = [memoryCaches objectForKey:leastRecentUsedDataKey];
    [self storeCacheInDisk:leastRecentUsedCache];
    
    [recentAccessedKeys removeLastObject];
    [memoryCaches removeObjectForKey:leastRecentUsedDataKey];
  }
}

+ (void)storeCacheInDisk:(AZCache *)cache {
  if(cache) {
    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:cache];
    [cacheData writeToFile:[self cachePathForKey:cache.cacheKey] atomically:YES];
  }
}

+ (void)saveAllMemoryCacheToDisk {
  for (AZCache *cache in [memoryCaches allValues]) {
    [self storeCacheInDisk:cache];
  }
}

+ (AZCache *)cacheForKey:(NSString *)key {
  AZCache *memoryCache = [memoryCaches objectForKey:key];
  if (memoryCache) {
    return memoryCache;
  }
  NSData *cacheData = [NSData dataWithContentsOfFile:[self cachePathForKey:key]];
  AZCache *diskCache = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
  if (diskCache) {
    [self storeCacheInMemory:diskCache];
    return diskCache;
  }
  return nil;
}

+ (AZCacheStoreType)storeTypeWithFrequencyLevel:(AZCacheUseFrequencyLevel)level {
  return level == kAZCacheUseFrequencyLevelLow ? kAZCacheStoreInDisk:kAZCacheStoreInDiskAndRAM;
}

+ (void)removeCacheInMemory:(NSString *)key {
  [recentAccessedKeys removeObject:key];
  [memoryCaches removeObjectForKey:key];
}

+ (void)removeCacheInDisk:(NSString *)key {
  NSString *path = [self cachePathForKey:key];
  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (NSString *)cachesDirectory {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCachesDirectoryName];
  return cachesDirectory;
}

+ (NSString *)cachePathForKey:(NSString *)key
{
  NSString *cachesDirectory = [self cachesDirectory];
  return [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",key,kCacheFileFormatString]];
}

@end
