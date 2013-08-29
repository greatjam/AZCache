AZCache
=======

Provide object cache, use as key/value style, maintain memory cache for high frequency use data.

Just make sure the your cache object support NSCoding ,and use AZCache in simple way:

```objective-c
  [AZCacheManager cacheItem:@[@"1",@"2",@"3"] itemKey:@"array1" frequencyLevel:kAZCacheUseFrequencyLevelHigh];
  
  NSArray *array1 = [AZCacheManager fetchCachedItemForKey:@"array1"];
  
  [AZCacheManager removeCacheForKey:@"array3"];
  
  [AZCacheManager clearCache];
```
