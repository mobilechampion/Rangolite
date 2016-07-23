//
//  HelloPlugin.m
//  OrderAPP
//
//  Created by Mac5 on 11/02/14.
//
//

#import "HelloPlugin.h"


@implementation HelloPlugin
- (void) nativeFunction:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    //get the callback id    [arguments pop]
    
   // NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    //NSLog(@"UDID:: %@", uniqueIdentifier);
    
    
    
    NSString *callbackId =[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    // NSString *callbackId =@"MYAPP5 PHONEGAP APP..........NICE APP TO BUILT5";
    
   
    NSString *resultType = [arguments objectAtIndex:0];
    
    
    
  //  CDVPluginResult *result;
    
    
    
    
    if ( [resultType isEqualToString:@"success"] )
    {
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"Success "];
//        
//        [self writeJavascript:[result toSuccessCallbackString:callbackId]];
        
        
        [self callbackWithFuntion:callbackId withData:resultType];
    }
    else
    {
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"Error "];
//        [self writeJavascript:[result toErrorCallbackString:callbackId]];
        
        
          [self callbackWithFuntion:resultType withData:callbackId];
    }
    // NSLog(@"Hello, this is a native function called from PhoneGap/Cordova %@",result);
    //[self.commandDelegate sendPluginResult:result callbackId:callbackId];
    

}



-(void) callbackWithFuntion:(NSString *)function withData:(NSString *)value{
    
    
    NSLog(@"Hid %@ ",function);
    NSLog(@"vvv %@ ",value);
    value=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Couse Talk" message: [[NSUserDefaults standardUserDefaults]objectForKey:@"token"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//    [alert show];
    
    
    
    
    if (!function || [@"" isEqualToString:function]){
        return;
    }
    
    // NSString* jsCallBack = [NSString stringWithFormat:@"%@(%@);", function, value];
    // NSString* jsCallBack = [NSString stringWithFormat:@"cordova.callbackSuccess('%@',%@);", function, [self toJSONString]];
    
    // NSLog(jsCallBack);
    // [self writeJavascript: jsCallBack];
    
    
    
    
    
    CDVPluginResult *result;
    
    
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
    
    
    [self writeJavascript:[result toSuccessCallbackString:function]];
    
    
    
    
    
    
}

@end
