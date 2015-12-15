//
//  DetailViewController.m
//  JHCoreSpotlight
//
//  Created by 迅牛 on 15/12/15.
//  Copyright © 2015年 juvham. All rights reserved.
//

#import "DetailViewController.h"


@interface UIColor (colorConfig)
+ (UIColor *)zixuanGreen;
+ (UIColor *)zixuanGray;
+ (UIColor *)zixuanRed;
@end
@implementation UIColor (colorConfig)
+ (UIColor *)zixuanGray {
    
    return [UIColor colorWithWhite:151/255.0 alpha:1];
}

+ (UIColor *)zixuanGreen {
    
    return [UIColor colorWithRed:61/255.0 green:216/255.0 blue:76/255.0 alpha:1];
}

+ (UIColor *)zixuanRed {
    
    return [UIColor colorWithRed:1 green:30/255.0 blue:29/255.0 alpha:1];
}

@end

@interface DetailViewController ()
@property (nonatomic ,weak) IBOutlet UILabel *codeLabel;
@property (nonatomic ,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic ,weak) IBOutlet UILabel *yelidLabel;
@property (nonatomic ,weak) IBOutlet UILabel *yelidPriceLabel;
@property (nonatomic ,weak) IBOutlet UILabel *marketPriceLabel;
@property (nonatomic ,weak) IBOutlet UILabel *marketCurLabel;
@property (nonatomic ,weak) IBOutlet UILabel *turnOverLabel;
@property (nonatomic ,weak) IBOutlet UILabel *priceRangeLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.model.collectionName;
    self.codeLabel.text = self.model.code;
    self.priceLabel.text = self.model.currentPrice;
    CGFloat yel = [self.model.yieldRate floatValue];
    self.yelidLabel.text = [NSString stringWithFormat:@"%.2f%%",yel];
    self.yelidPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.currentPrice.floatValue * yel/100.0];
    self.marketPriceLabel.text = self.model.marketPrice;
    self.marketCurLabel.text = self.model.marketCirculation;
    self.turnOverLabel.text = [NSString stringWithFormat:@"%.2f%%",self.model.turnoverRate.floatValue];
    self.priceRangeLabel.text = [NSString stringWithFormat:@"%.2f%%",self.model.priceRange.floatValue];
    
    
    UIColor *color = [UIColor zixuanGray];
    
    if (yel > 0) {
        
        color = [UIColor zixuanRed];
    } else if (yel == 0){
        color = [UIColor zixuanGray];
    } else {
        color = [UIColor zixuanGreen];
    }
    self.yelidLabel.textColor = color;
    self.yelidPriceLabel.textColor = color;
    self.priceLabel.textColor = color;

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
