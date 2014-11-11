//
//  WebSerivceCall.h
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebSerivceCall : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    NSMutableData *responseData;
}

@property (copy, nonatomic) void (^complete)(NSDictionary*);
@property (copy, nonatomic) void (^fail)(NSError*);

- (void)callWebService:(NSString*)url parameters:(NSDictionary*)params complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error))failure;



@end
