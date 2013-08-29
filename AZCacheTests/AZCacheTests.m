//
//  AZCacheTests.m
//  AZCacheTests
//
//  Created by Zou Alex on 8/29/13.
//  Copyright (c) 2013 alex zou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AZCacheManager.h"

@interface AZCacheTests : XCTestCase

@end

@implementation AZCacheTests

- (void)setUp
{
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testAdding
{
  [AZCacheManager cacheItem:@[@"1",@"2",@"3"] itemKey:@"array1" frequencyLevel:kAZCacheUseFrequencyLevelHigh];
  [AZCacheManager cacheItem:@[@"2",@"3",@"4"] itemKey:@"array2" frequencyLevel:kAZCacheUseFrequencyLevelLow];
  
  NSArray *array1 = [AZCacheManager fetchCachedItemForKey:@"array1"];
  NSArray *array2 = (NSArray *)[AZCacheManager fetchCachedItemForKey:@"array2"];
  XCTAssert([[array1 objectAtIndex:1] isEqualToString:@"2"], @"incorrct num:%@",[array1 objectAtIndex:1]);
  XCTAssert([[array2 objectAtIndex:2] isEqualToString:@"4"], @"incorrect num:%@",[array1 objectAtIndex:2]);
  XCTAssertNotNil(array1, @"data exist");
  
}

- (void)testRemoving
{
  /* remove one */
  [AZCacheManager cacheItem:@[@"leon",@"not",@"here"] itemKey:@"array3" frequencyLevel:kAZCacheUseFrequencyLevelHigh];
  [AZCacheManager cacheItem:@[@"world",@"my",@"hello"] itemKey:@"array4" frequencyLevel:kAZCacheUseFrequencyLevelLow];
  
  [AZCacheManager removeCacheForKey:@"array3"];
  [AZCacheManager removeCacheForKey:@"array4"];
  
  NSArray *array1 = (NSArray *)[AZCacheManager fetchCachedItemForKey:@"array3"];
  NSArray *array2 = (NSArray *)[AZCacheManager fetchCachedItemForKey:@"array4"];
  
  XCTAssertNil(array1, @"array1 not empty");
  XCTAssertNil(array2, @"array2 not empty");
  
  /* remove all */
  [AZCacheManager cacheItem:@[@"g",@"r",@"e"] itemKey:@"localplayer" frequencyLevel:kAZCacheUseFrequencyLevelLow];
  [AZCacheManager cacheItem:@[@"v",@"v",@"e"] itemKey:@"foreignplayer" frequencyLevel:kAZCacheUseFrequencyLevelLow];
  [AZCacheManager clearCache];
  NSArray *array3 = (NSArray *)[AZCacheManager fetchCachedItemForKey:@"array3"];
  NSArray *array4 = (NSArray *)[AZCacheManager fetchCachedItemForKey:@"array4"];
  XCTAssertNil(array3, @"a array not empty");
  XCTAssertNil(array4, @"a array not empty");
}

- (void)testEditing
{
  [AZCacheManager cacheItem:@[@"1",@"2",@"3"] itemKey:@"array1" frequencyLevel:kAZCacheUseFrequencyLevelHigh];
  [AZCacheManager cacheItem:@[@"2",@"3",@"4"] itemKey:@"array1" frequencyLevel:kAZCacheUseFrequencyLevelLow];
  NSArray *array1 = (NSArray *)[AZCacheManager fetchCachedItemForKey:@"array1"];
  
  XCTAssert([[array1 objectAtIndex:1] isEqualToString:@"3"], @"incorrect num:%@",[array1 objectAtIndex:1]);
  
}

- (void)testEnding
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kAZSyncCacheDataNotification object:nil];
}

@end
