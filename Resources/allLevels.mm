//
//  allLevels.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/5/14.
//
//

#import "allLevels.h"

@implementation allLevels
@synthesize levels = _levels;
-(id)init{
    if(self = [super init]){
        self.levels = [[[NSMutableArray alloc]init]autorelease];
    }
    return self;
}

//-(int)getLength{
//    return [_levels count];
//}

-(void)dealloc{
    self.levels = nil;
    [super dealloc];
}
@end
