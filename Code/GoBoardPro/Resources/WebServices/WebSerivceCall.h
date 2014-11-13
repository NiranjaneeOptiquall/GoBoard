//
//  WebSerivceCall.h
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface WebSerivceCall : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    NSMutableData *responseData;
    NSString *strUrl;
}

@property (copy, nonatomic) void (^complete)(NSDictionary*);
@property (copy, nonatomic) void (^fail)(NSError*, NSDictionary*);

- (void)callWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure;



@end
