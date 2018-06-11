#include "RNPixelColor.h"
#import <React/RCTImageLoader.h>
#import "UIImage+ColorAtPixel.h"

UIImage *tempImage;

@implementation RNPixelColor

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createTempImage: (NSString *) path)
{
    [_bridge.imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:path] callback:^(NSError *error, UIImage *image) {
        tempImage = image;
    }];
}
RCT_EXPORT_METHOD(getHex:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{
        NSInteger x = [RCTConvert NSInteger:options[@"x"]];
        NSInteger y = [RCTConvert NSInteger:options[@"y"]];
       
        if (options[@"width"] && options[@"height"]) {
            NSInteger scaledWidth = [RCTConvert NSInteger:options[@"width"]];
            NSInteger scaledHeight = [RCTConvert NSInteger:options[@"height"]];
            float originalWidth = tempImage.size.width;
            float originalHeight = tempImage.size.height;
            
            x = x * (originalWidth / scaledWidth);
            y = y * (originalHeight / scaledHeight);
            
        }
        
        CGPoint point = CGPointMake(x, y);
        
        UIColor *pixelColor = [tempImage colorAtPixel:point];
        callback(@[[NSNull null], hexStringForColor(pixelColor)]);
   // }];
}

NSString * hexStringForColor( UIColor* color ) {
    if (color == nil) {
        return @"transparent";
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];

    return hexString;
}

@end
