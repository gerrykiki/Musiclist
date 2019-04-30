//
//  Apiconnect.h
//  LexiMusicSearch
//
//  Created by GerryPW_Lin on 2019/4/30.
//  Copyright © 2019 GerryPW_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Apiconnect : NSObject

+ (instancetype)sharedInstance;


- (void) getTopSongs: (void (^)(NSDictionary *returnData)) callback;



@end

NS_ASSUME_NONNULL_END
