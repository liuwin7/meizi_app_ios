//
//  UMEUUID.m
//  meinv
//
//  Created by tropsci on 16/3/17.
//  Copyright © 2016年 topsci. All rights reserved.
//

#import "UMEUUID.h"

@implementation UMEUUID

+ (nullable NSString *)umengUUID {
    Class cls = NSClassFromString(@"UMANUtil");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL deviceIDSelector = @selector(openUDIDString);
#pragma clang diagnostic pop
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        deviceID = [cls performSelector:deviceIDSelector];
#pragma clang diagnostic pop
    } else {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
