//
//  JHCoreSpotlight.m
//  Juvham
//
//  Created by Juvham on 15/10/19.
//  Copyright © 2015年 Juvham. All rights reserved.
//

#import "JHCoreSpotlight.h"
#import "objc/runtime.h"

@interface NSString  (serialize)@end
@implementation NSString (serialize)
+ (NSString *)serializeString:(NSString *)baseString params:(NSDictionary *)params {
    
    NSString *bString = [baseString copy];
    
    NSURL* parsedURL = [NSURL URLWithString:bString];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            continue;
        }
        
        NSString *escaped_value = [params objectForKey:key];
        escaped_value  = [escaped_value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
    

        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", bString, queryPrefix, query];
}

@end

@interface NSObject ()

@property (nonatomic ,copy, readonly)  NSString *searchableContentType;

@end

@implementation NSObject (YBCSSearchable)

static NSString *classContentType;
- (NSString *)searchableContentType {
    
    if (!classContentType) {
        
        classContentType = [[[self class] searchableContentType] copy];
    }
    
    return classContentType;
}

+ (NSString *)searchableContentType {

    return [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundleIdentifier],NSStringFromClass([self class])];
}

+ (NSString *)titleProperty {
    
    return nil;
}

- (NSString *)searchableTitle {
    
    if ([[self class] titleProperty]) {
        
        unsigned int count = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        
        if (count) {
            for (int i = 0 ; i < count ;i ++) {
                
                NSString *strName = [NSString  stringWithCString:property_getName(propertyList[i]) encoding:NSUTF8StringEncoding];
                
                if ([strName isEqualToString:[[self class] titleProperty]]) {
                    
                    return [self valueForKey:strName];
                }
            }
            
            
        }

    }
    
    return nil;
}

+ (NSString *)identifierPropterty {
    
    return nil;
}

+ (NSArray *)identifierProptertyArray {
    
    return nil;
}

- (NSString *)searchableIdentifier {
        
    NSArray* pkArray = [[self class] identifierProptertyArray];
    if(pkArray.count == 0) {
        
        if ([[self class] identifierPropterty]) {
            
            unsigned int count = 0;
            objc_property_t *propertyList = class_copyPropertyList([self class], &count);
            
            if (count) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
                for (int i = 0 ; i < count ;i ++) {
                    
                    NSString *strName = [NSString  stringWithCString:property_getName(propertyList[i]) encoding:NSUTF8StringEncoding];
                    
                    if ([strName isEqualToString:[[self class] identifierPropterty]]) {
                        
                        id value = [self valueForKey:strName];
                        
                        [dic setObject:[NSString stringWithFormat:@"%@",value ? :@""] forKey:strName];
                        
                        break;

                    }
                }
                
                return [NSString serializeString:[self searchableContentType] params:dic ];
            }
        }

    } else {
        
        unsigned int count = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        
        if (count) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in  pkArray) {
                
                for (int i = 0 ; i < count ;i ++) {
                    
                    NSString *strName = [NSString  stringWithCString:property_getName(propertyList[i]) encoding:NSUTF8StringEncoding];
                    
                    if ([strName isEqualToString:key]) {
                        
                        [dic setObject:[self valueForKey:strName] ?[NSString stringWithFormat:@"%@",[self valueForKey:strName]]:@"" forKey:strName];
                        break;
                    }
                }
            }
            return [NSString serializeString:[self searchableContentType] params:dic ];
        } else {
            
        }
        
    }
    
    return nil;
}

@end

@implementation JHCoreSpotlight

+ (void)indexObject:(id <JHCSSearchable>)obj {
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:[self genrates:@[obj]]completionHandler:^(NSError * _Nullable error) {
        
    }];
}

+ (void)indexObjects:(NSArray *)array {
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:[self genrates:array]completionHandler:^(NSError * _Nullable error) {
    }];
    
}

+ (void)deIndexWithObjects:(NSArray *)array {

    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:[self degenrates:array] completionHandler:^(NSError * _Nullable error) {
        
    }];
}

+ (void)deIndexWithObject:(id<JHCSSearchable>)obj {

    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[obj.searchableIdentifier] completionHandler:^(NSError * _Nullable error) {
        
    }];
}
#pragma makr - private

+ (NSArray *)degenrates:(NSArray *)array {
    
    NSMutableArray *identifierArray = [NSMutableArray arrayWithCapacity:array.count];
    
    [array enumerateObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(id <JHCSSearchable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [identifierArray addObject:obj.searchableIdentifier];
    }];
    
    return identifierArray;
}

+ (NSArray *)genrates:(NSArray *)array {
 
    NSMutableArray *garray = [NSMutableArray arrayWithCapacity:array.count];
#warning 理论上使用 并发遍历可以提高性能 但是 不知为何 会出现 double free
    [array enumerateObjectsWithOptions:0 usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [garray addObject:[self genrate:obj]];
        
    }];
    
    return garray;
}

+ (CSSearchableItem *)genrate:(id <JHCSSearchable >)obj {
    
    NSAssert([obj conformsToProtocol:@protocol(JHCSSearchable)], @"OBJ doesm't conform protocol YBSearchable");
    
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:[obj searchableContentType]];
    
    attributeSet.title = obj.searchableTitle;
    attributeSet.subject = obj.searchableTitle;
    
    if ([obj respondsToSelector:@selector(contentDescription)]) {
        
        NSString *string = [obj contentDescription];
        attributeSet.contentDescription = string;
        
        NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        attributeSet.alternateNames = array;
        
    }
    attributeSet.contentModificationDate = [NSDate date];
//    attributeSet.contentModificationDate
    
    NSArray *keyWords = [obj.searchableTitle componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    attributeSet.keywords = keyWords;
    attributeSet.relatedUniqueIdentifier = obj.searchableIdentifier;
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:attributeSet.relatedUniqueIdentifier domainIdentifier:[obj searchableContentType] attributeSet:attributeSet];
    
    return item;
}

@end
