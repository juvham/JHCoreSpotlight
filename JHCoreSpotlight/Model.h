//
//  Model.h
//  JHCoreSpotlight
//
//  Created by 迅牛 on 15/12/15.
//  Copyright © 2015年 juvham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
#import "JHCoreSpotlight.h"

@interface Model : MTLModel <MTLJSONSerializing,JHCSSearchable>

@property (nonatomic, copy) NSString    *code;
@property (nonatomic, copy) NSString    *collectionName;
@property (nonatomic, copy) NSString    *currentPrice;
@property (nonatomic, copy) NSString    *marketCirculation;
@property (nonatomic, copy) NSString    *isRate;
@property (nonatomic, copy) NSString    *marketPrice;
@property (nonatomic, copy) NSString    *priceRange;
@property (nonatomic, copy) NSString    *turnoverRate;
@property (nonatomic, copy) NSString    *type;
@property (nonatomic, copy) NSString    *yieldRate;

@end
