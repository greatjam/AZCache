//
//  AZCache.h
//  AZCache
//
//  Created by Zou Alex on 8/29/13.
//  Copyright (c) 2013 alex zou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AZCacheStoreType){
  kAZCacheStoreInDisk = 0,
  kAZCacheStoreInDiskAndRAM,
};

@interface AZCache : NSObject<NSCoding>

@property (nonatomic, readonly, copy) NSString *cacheKey;
@property (nonatomic, readonly) NSObject * object;
@property (nonatomic, readonly, assign) AZCacheStoreType cacheType;

- (instancetype)initWithObject:(NSObject *)object cacheKey:(NSString *)key cacheType:(AZCacheStoreType)type;

@end
