//
//  Apiconnect.m
//  LexiMusicSearch
//
//  Created by GerryPW_Lin on 2019/4/30.
//  Copyright © 2019 GerryPW_Lin. All rights reserved.
//

#import "Apiconnect.h"

@implementation Apiconnect

+ (instancetype)sharedInstance
{
    static Apiconnect *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Apiconnect alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


- (void) getTopSongs: (void (^)(NSDictionary *returnData)) callback {
    //create the Method "GET"
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rss.itunes.apple.com/api/v1/tw/apple-music/top-songs/all/100/explicit.json"]]];
    [urlRequest setHTTPMethod:@"GET"];
    
    //header
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error) {
            NSDictionary *returnDic = @{@"success":@(NO)}.mutableCopy;
            callback(returnDic);
        }
        else{
            if(httpResponse.statusCode == 200)
            {
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                //NSLog(@"The response is - %@",responseDictionary);
                NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:responseDictionary];
                [returnDic setObject:@(YES) forKey:@"success"];
                callback(returnDic);
            }
            else
            {
                NSDictionary *returnDic = @{@"success":@(NO)}.mutableCopy;
                callback(returnDic);
            }
            
        }
    }];
    [dataTask resume];
}

@end
