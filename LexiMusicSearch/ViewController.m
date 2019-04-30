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
    //itemarray = [[NSMutableArray alloc]initWithObjects:@"123",@"456", nil];
    
    NSString *urlstring = @"https://rss.itunes.apple.com/api/v1/tw/apple-music/top-songs/all/100/explicit.json";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    // Asynchronously API is hit here
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                dispatch_sync(dispatch_get_main_queue(), ^{
                                                    // Update the UI on the main thread.
                                                    //NSLog(@"%@",data);
                                                    if (error){
                                                        
                                                    }
                                                    else {
                                                        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        [self->itemarray removeAllObjects];
                                                        self->itemarray  = [[json objectForKey:@"feed"] objectForKey:@"results"];
                                                        [self->listtable reloadData];
                                                    }
                                                });
                                            }];
    [dataTask resume];
    //itemarray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

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
