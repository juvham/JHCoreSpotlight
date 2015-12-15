//
//  Model.m
//  JHCoreSpotlight
//
//  Created by 迅牛 on 15/12/15.
//  Copyright © 2015年 juvham. All rights reserved.
//

#import "Model.h"

@implementation Model
//code = 905002;
//"collection_name" = "IC\U5206\U5f62\U51e0\U4f55";
//"current_price" = 1674;
//"is_rate" = 0;
//"market_circulation" = 13825;
//"market_price" = "23143050.00";
//"price_range" = "5.05";
//"turnover_rate" = "0.00716";
//type = "\U7535\U8bdd\U5361";
//"yield_rate" = "3.41";

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"code":@"code",
             @"collectionName":@"collection_name",
             @"currentPrice":@"current_price",
             @"isRate":@"is_rate",
             @"marketCirculation":@"market_circulation",
             @"marketPrice":@"market_price",
             @"priceRange":@"price_range",
             @"turnoverRate":@"turnover_rate",
             @"type":@"type",
             @"yieldRate":@"yield_rate"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        return [NSString stringWithFormat:@"%@", value ? : @""];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        return [NSString stringWithFormat:@"%@", value ? : @""];
    }];
}

#pragma JHCoreSpotLight
+ (NSString *)titleProperty {
    
    return  @"collectionName";
}
+ (NSString *)identifierPropterty {
    return @"code";
}
- (NSString *)contentDescription {
    
    return [NSString stringWithFormat:@"藏品代码:%@  最新价:%@ 收益率:%@",self.code,self.currentPrice,self.yieldRate ];
}

@end
