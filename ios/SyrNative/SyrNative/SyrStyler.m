//
//  SyrStyler.m
//  SyrNative
//
//  Created by Anderson,Derek on 12/14/17.
//  Copyright © 2017 Anderson,Derek. All rights reserved.
//

#import "SyrStyler.h"

@implementation SyrStyler

+(UIColor*) color:(NSString*) color {
  if([color containsString:@"#"]) {
    return [SyrStyler colorFromHash:color];
  }
  return [SyrStyler colorFromRGBA:color];
}

+(UIColor*) colorFromHash:(NSString*) color {
  color = [color stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
  unsigned colorInt = 0;
  [[NSScanner scannerWithString:color] scanHexInt:&colorInt];
  return UIColorFromRGB(colorInt);
}

+(UIColor*) colorFromRGBA:(NSString*) color {
  NSString* cleanColor = [color stringByReplacingOccurrencesOfString:@"rgba(" withString:@""];
  cleanColor = [cleanColor stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
  cleanColor = [cleanColor stringByReplacingOccurrencesOfString:@")" withString:@""];
  
  NSArray* colors = [cleanColor componentsSeparatedByString:@","];
  NSNumber* red = [colors objectAtIndex:0];
  NSNumber* green = [colors objectAtIndex:1];
  NSNumber* blue = [colors objectAtIndex:2];
  
  NSNumber* alpha = [colors objectAtIndex:3];
  if(alpha == nil) {
    alpha = [NSNumber numberWithInt:1];
  }
  
  return RGBA([red doubleValue], [green doubleValue], [blue doubleValue], [alpha doubleValue]);
}

+(UIView*) styleView: (UIView*) view withStyle: (NSDictionary*) style {
  //view.frame = [self styleFrame:style];
  NSString* backgroundColor = [style valueForKey:@"backgroundColor"];
  if (backgroundColor == nil) {
    view.backgroundColor = [UIColor clearColor];
  } else {
    view.backgroundColor = [self color:backgroundColor];
  }
  
  NSNumber* borderRadius = [style valueForKey:@"borderRadius"];
  if (borderRadius) {
    view.layer.cornerRadius = [borderRadius doubleValue];
  }
  
  NSNumber* borderWidth = [style valueForKey:@"borderWidth"];
  UIColor* borderColor = [self colorFromHash:[style valueForKey:@"borderColor"]];
  
	NSNumber* borderTopWidth = [style valueForKey:@"borderTopWidth"];
  NSNumber* borderLeftWidth = [style valueForKey:@"borderLeftWidth"];
  NSNumber* borderRightWidth = [style valueForKey:@"borderRightWidth"];
  NSNumber* borderBottomWidth = [style valueForKey:@"borderBottomWidth"];
  
  if(borderTopWidth == nil) {
    borderTopWidth = borderWidth;
  }
  
  if(borderLeftWidth == nil) {
    borderLeftWidth = borderWidth;
  }
  
  if(borderRightWidth == nil) {
    borderRightWidth = borderWidth;
  }
  
  if(borderBottomWidth == nil) {
    borderBottomWidth = borderWidth;
  }
  
  if(borderWidth != nil) {
    
    if(borderTopWidth > 0){
      CALayer *upperBorder = [CALayer layer];
      upperBorder.backgroundColor = [borderColor CGColor];
      upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), [borderTopWidth doubleValue]);
      [view.layer addSublayer:upperBorder];
    }
    
    if(borderRightWidth > 0) {
      CALayer *rightBorder = [CALayer layer];
      rightBorder.backgroundColor = [borderColor CGColor];
      rightBorder.frame = CGRectMake(CGRectGetWidth(view.frame) - [borderRightWidth doubleValue], 0, [borderRightWidth doubleValue], CGRectGetHeight(view.frame));
      [view.layer addSublayer:rightBorder];
    }
    
    if(borderBottomWidth > 0) {
      CALayer *bottomBorder = [CALayer layer];
      bottomBorder.backgroundColor = [borderColor CGColor];
      bottomBorder.frame = CGRectMake(0, 0, [borderBottomWidth doubleValue], CGRectGetHeight(view.frame));
      [view.layer addSublayer:bottomBorder];
    }
    
    if(borderLeftWidth > 0) {
      CALayer *leftBorder = [CALayer layer];
      leftBorder.backgroundColor = [borderColor CGColor];
      leftBorder.frame = CGRectMake(0, CGRectGetHeight(view.frame) - [borderLeftWidth doubleValue], CGRectGetWidth(view.frame), [borderLeftWidth doubleValue]);
      [view.layer addSublayer:leftBorder];
    }
  }
  
  // overflow hidden
  view.layer.masksToBounds = true;
  return view;
}

+(CGRect) styleFrame:(NSDictionary*)styleDictionary {
  NSNumber* frameHeight = [styleDictionary objectForKey:@"height"];
  NSNumber* frameWidth = [styleDictionary objectForKey:@"width"];
  NSNumber* framex = [styleDictionary objectForKey:@"left"];
  NSNumber* framey = [styleDictionary objectForKey:@"top"];
  return CGRectMake([framex doubleValue], [framey doubleValue], [frameWidth doubleValue], [frameHeight doubleValue]);
}

@end
