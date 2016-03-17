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
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    } else {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
