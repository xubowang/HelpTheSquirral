//
//  startAnimation.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/22/14.
//
//

#import "startAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation startAnimation
+(CCScene*)scene{
    CCScene *scene = [CCScene node];
    startAnimation *layer = [[[startAnimation alloc]init]autorelease];
    [scene addChild:layer];
    return scene;
}

-(id)init{
    
}
@end
