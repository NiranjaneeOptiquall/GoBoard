//
//  WebSerivceCall.m
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WebSerivceCall.h"

@implementation WebSerivceCall

- (void)callWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure {
    self.complete = completion;
    self.fail = failure;
    strUrl =[NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICE_URL, url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl];
    [request setHTTPMethod:httpMethod];
    if (params) {
        NSData *aData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        NSString *aStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", aStr);
        [request setHTTPBody:aData];
    }
    [NSURLConnection connectionWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _fail(error, nil);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    NSString *aStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"\n%@\n%@",strUrl, aStr);
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        _fail(error, jsonObject);
        return;
    }
    _complete(jsonObject);
}


@end
