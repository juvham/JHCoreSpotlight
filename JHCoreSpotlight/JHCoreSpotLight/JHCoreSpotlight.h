//
//  JHCoreSpotlight.h
//  Juvham
//
//  Created by Juvham on 15/10/19.
//  Copyright © 2015年 Juvham. All rights reserved.
//

#import <UIKit/UIKit.h>

#if TARGET_OS_WATCH
#else
#import <CoreSpotlight/CoreSpotlight.h>
#endif

//NS_EXTENSION_UNAVAILABLE_IOS("don't use it in extension")
@protocol JHCSSearchable <NSObject>

@required
/**
 *  @brief  需要实现这三个方法
 *
 *  @return <#return value description#>
 *
 *  @since <#3.0.5#>
 */
+ (NSString *)titleProperty;

+ (NSString *)identifierPropterty;

+ (NSArray *)identifierProptertyArray;

- (NSString *)contentDescription;

@optional

+ (NSString *)searchableContentType ;




- (NSString *)searchableIdentifier;

- (NSString  *)searchableTitle;

@end


@interface NSObject (YBCSSearchable)

@end

@interface JHCoreSpotlight : NSObject

+ (void)indexObject:(id <JHCSSearchable>)obj;

+ (void)indexObjects:(NSArray *)array;

+ (void)deIndexWithObjects:(NSArray *)array;

+ (void)deIndexWithObject:(id <JHCSSearchable>)obj;

@end
