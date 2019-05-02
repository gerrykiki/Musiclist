//
//  ViewController.m
//  LexiMusicSearch
//
//  Created by GerryPW_Lin on 2019/4/30.
//  Copyright © 2019 GerryPW_Lin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController{
    BOOL searchbool;
}
@synthesize listtable,itemarray,musicsearch,searchitemarray;

- (void)viewDidLoad {
    [super viewDidLoad];
    searchbool = NO;
    listtable.delegate = self;
    listtable.dataSource = self;
    musicsearch.delegate = self;
    searchitemarray = [[NSMutableArray alloc]init];
    Apiconnect *apiconnect = [Apiconnect sharedInstance];
    _waitdownload = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _waitdownload.backgroundColor = [UIColor grayColor];
    UILabel *waitinglable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    waitinglable.center = _waitdownload.center;
    waitinglable.text = @"Loading Music list";
    waitinglable.textColor = UIColor.whiteColor;
    waitinglable.textAlignment = NSTextAlignmentCenter;
    [_waitdownload addSubview:waitinglable];
    [self.view addSubview:_waitdownload];
    [apiconnect getTopSongs:^(NSDictionary * _Nonnull returnData) {
        NSLog(@"returndata = %@",returnData);
        [self->itemarray removeAllObjects];
        self->itemarray  = [[returnData objectForKey:@"feed"] objectForKey:@"results"];
        [self->listtable reloadData];
        [self->_waitdownload removeFromSuperview];
        
    }];
}

#pragma mark - TableViewController funciton

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchbool) {
        return searchitemarray.count;
        
    }
    else{
        return itemarray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    // 判断是有空闲的cell,有进行重用，没有就创建一个
    UITableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // 设置名字
    if (searchbool) {
        NSString *name = [searchitemarray[indexPath.row]objectForKey:@"name"];
        cell.textLabel.text = name;
        NSString *artisName = [searchitemarray[indexPath.row]objectForKey:@"artistName"];
        cell.detailTextLabel.text = artisName;
        NSString *urlString = [searchitemarray[indexPath.row]objectForKey:@"artworkUrl100"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
        return cell;
        
        
    }
    else{
        NSString *name = [itemarray[indexPath.row]objectForKey:@"name"];
        cell.textLabel.text = name;
        NSString *artisName = [itemarray[indexPath.row]objectForKey:@"artistName"];
        cell.detailTextLabel.text = artisName;
        NSString *urlString = [itemarray[indexPath.row]objectForKey:@"artworkUrl100"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
        return cell;
        
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchbool) {
        
    }
    else{
        NSString *artisName = [itemarray[indexPath.row]objectForKey:@"artistName"];
        NSString *name = [itemarray[indexPath.row]objectForKey:@"name"];
        NSString *alerttext = [NSString stringWithFormat:@"Singer is %@",artisName];
        UIAlertController *selectalert = [UIAlertController alertControllerWithTitle:name
                                                                              message:alerttext preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [selectalert addAction:cancelAction];
        
        [self presentViewController:selectalert animated:YES completion:nil];
        
    }
}

#pragma mark - Search Bar Implementation

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //Remove all objects first.
    [searchitemarray removeAllObjects];
    
    if([searchText length] != 0) {
        [self searchTableList];
    }
    else {
        searchbool = NO;
        [listtable reloadData];
    }
}

#pragma mark - Search Function Responsible For Searching

- (void)searchTableList {
    
    NSString *searchString = musicsearch.text;
    searchbool = YES;
    for (int i = 0;i < itemarray.count;i++) {
        NSString *tempStr = [[itemarray objectAtIndex:i]objectForKey:@"name"];
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [searchitemarray addObject:[itemarray objectAtIndex:i]];
        }
    }
    [listtable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}

@end
