//
//  ViewController.m
//  JHCoreSpotlight
//
//  Created by 迅牛 on 15/12/15.
//  Copyright © 2015年 juvham. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "DetailViewController.h"

NSString *const listCell = @"listCell";
NSString *const showDetailSegue = @"showDetailSegue";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenUserAcyivity:) name:@"userActivity" object:nil];
    
    self.tableView.rowHeight = 60;

}

- (NSArray *)array {
    
    if (_array == nil) {
        
        NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"file" withExtension:@"txt"];
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        _array = [MTLJSONAdapter modelsOfClass:[Model class] fromJSONArray:dic[@"data"][@"list"] error:nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
             [JHCoreSpotlight indexObjects:_array];
        });

    }
    
    return _array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    
    Model *model = [self.array objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.collectionName;
    cell.detailTextLabel.text = model.code;
    
    return cell;
    
}

- (void)handleOpenUserAcyivity:(NSNotification *)notifier {
    
    NSDictionary *userInfo =  notifier.userInfo;
    
    if ([userInfo[@"classname"]  isEqualToString:@"DetailViewController"]) {
        
        NSString *code = userInfo[@"code"];
        
       __block Model *model;
        [self.array enumerateObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(Model * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj.code isEqualToString:code]) {
                
                model = obj;
                
                *stop = YES;
            }
            
        }];
        
        if (model ) {
            
            [self.navigationController setViewControllers:@[self]];
            [self performSegueWithIdentifier:showDetailSegue sender:model];
        }
        
    }
    
    
}

//- (NSInteger)itemIndex:()

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Model *model;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        model = [self.array objectAtIndex:indexPath.row];
    } else {
        
        model = sender;
        
    }
    
    ((DetailViewController *)segue.destinationViewController).model = model;
}

@end
