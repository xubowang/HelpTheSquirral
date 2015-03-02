//
//  wrapper.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/26/14.
//
//

#import "wrapper.h"

@implementation wrapper
@synthesize pinBody_ = pinBody_;
-(id)initWithBody:(b2Body*)pinB{
    self = [super init];
    if (self) {
        pinBody_ = pinB;
    }
    return self;
}

-(b2Body*)getBody{
    return pinBody_;
}
@end
