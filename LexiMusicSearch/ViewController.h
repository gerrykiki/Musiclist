//
//  ViewController.h
//  LexiMusicSearch
//
//  Created by GerryPW_Lin on 2019/4/30.
//  Copyright © 2019 GerryPW_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listtable;
@property (strong, nonatomic) NSMutableArray *itemarray;
@property (strong, nonatomic) NSMutableArray *searchitemarray;
@property (strong, nonatomic) IBOutlet UISearchBar *musicsearch;

@end

