/*****************************************************************
 NSObject+M3Extensions.m
 M3Foundation
 
 Created by Martin Pilkington on 30/03/2011.
 
 Please read the LICENCE.txt for licensing information
*****************************************************************/

#import "NSObject+M3Extensions.h"
#import <objc/runtime.h>


@implementation NSObject (M3Extensions)

#pragma mark -
#pragma mark Perform blocks


- (void)m3_performBlock:(void (^)(void))aBlock afterDelay:(NSTimeInterval)aInterval {
	[self performSelector:@selector(_m3_performBlock:) withObject:[aBlock copy] afterDelay:aInterval];
}


- (void)m3_performBlock:(void (^)(void))aBlock afterDelay:(NSTimeInterval)aInterval inModes:(NSArray *)aArray {
	[self performSelector:@selector(_m3_performBlock:) withObject:[aBlock copy] afterDelay:aInterval inModes:aArray];
}


- (void)_m3_performBlock:(void (^)(void))aBlock {
	aBlock();
}





#pragma mark -
#pragma mark Manipulating objects


- (BOOL)m3_replaceImplementationOfMethodWithSelector:(SEL)aSelector withBlock:(id)aBlock {
	NSString *className = NSStringFromClass(self.class);
	NSArray *nameComponents = [className componentsSeparatedByString:@"_"];
	//Check if we're already a singleton
	if (![nameComponents.lastObject hasPrefix:@"m3singleton"]) {
		//If not then get the subclass name to use
		NSString *newClassNamePrefix = [NSString stringWithFormat:@"%@_m3singleton", className];
		NSString *newClassName = newClassNamePrefix;
		NSInteger classNumber = 0;
		//While the class name is registered try the next number
		while (objc_getClass([newClassName cStringUsingEncoding:NSUTF8StringEncoding])) {
			classNumber++;
			newClassName = [NSString stringWithFormat:@"%@%ld", newClassName, classNumber];
		}
		
		//Register the class with the runtime and then change our class
		const char *name = [newClassName cStringUsingEncoding:NSUTF8StringEncoding];
		Class newSubclass = objc_allocateClassPair(self.class, name, 0);
		objc_registerClassPair(newSubclass);
		object_setClass(self, newSubclass);
	}
	IMP newIMP = imp_implementationWithBlock(aBlock);
	Method methodToReplace = class_getInstanceMethod(self.class, aSelector);
	return class_addMethod(self.class, aSelector, newIMP, method_getTypeEncoding(methodToReplace));
}

@end
