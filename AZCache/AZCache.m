//
//  AZCache.m
//  AZCache
//
//  Created by Zou Alex on 8/29/13.
//  Copyright (c) 2013 alex zou. All rights reserved.
//

#import "AZCache.h"

@interface AZCache ()
@property (nonatomic, copy) NSString *cacheKey;
@property (nonatomic) NSObject *object;
@property (nonatomic, assign) AZCacheStoreType cacheType;
@end

@implementation AZCache

- (instancetype)initWithObject:(NSObject *)object cacheKey:(NSString *)key cacheType:(AZCacheStoreType)type {
  if (self = [super init]) {
    _object = object;
    _cacheKey = key;
    _cacheType = type;
  }
  return self;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self != nil) {
    self.object = [aDecoder decodeObjectForKey:@"object"];
    self.cacheKey = [aDecoder decodeObjectForKey:@"cacheKey"];
    self.cacheType = [aDecoder decodeIntegerForKey:@"cacheType"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  if (self.object) {
    [aCoder encodeObject:self.object forKey:@"object"];
  }
  if (self.cacheKey) {
    [aCoder encodeObject:self.cacheKey forKey:@"cacheKey"];
  }
  [aCoder encodeInteger:self.cacheType forKey:@"cacheType"];
}

@end
