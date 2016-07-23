//
//  HelloPlugin.h
//  OrderAPP
//
//  Created by Mac5 on 11/02/14.
//
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDVPlugin.h>

@interface HelloPlugin : CDVPlugin
- (void) nativeFunction:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
