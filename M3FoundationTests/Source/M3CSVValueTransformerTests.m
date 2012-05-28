/*****************************************************************
 M3CSVValueTransformerTests.m
 M3Foundation
 
 Created by Martin Pilkington on 09/01/2010.
 
 Please read the LICENCE.txt for licensing information
*****************************************************************/

#import "M3CSVValueTransformerTests.h"
#import <M3Foundation/M3Foundation.h>

@implementation M3CSVValueTransformerTests

- (void)testForwardTransform {
	M3CSVValueTransformer *transform = [[M3CSVValueTransformer alloc] init];
	NSArray *array = [NSArray arrayWithObjects:@"42", @"possums", @"went", @"on", @"holiday", nil];
	STAssertEqualObjects(array, [transform transformedValue:@"42,possums,went,on,holiday"], @"");
}

- (void)testReverseTransform {
	M3CSVValueTransformer *transform = [[M3CSVValueTransformer alloc] init];
	NSArray *array = [NSArray arrayWithObjects:@"42", @"possums", @"went", @"on", @"holiday", nil];
	STAssertEqualObjects(@"42,possums,went,on,holiday", [transform reverseTransformedValue:array], @"");
}

@end