//
//  StarScoreBand.m
//  HelpTheSquirrel
//
//  Created by Xiang Zhang on 7/1/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "StarScoreBand.h"


@implementation StarScoreBand


- (StarScoreBand*) initScoreBand: (CCLayer*)layer{
    self = [super init];
    if(self){
        scorePics = [[NSArray arrayWithObjects:@"starScore0.png",@"starScore1.png",@"starScore2.png",@"starScore3.png",nil]retain];
        scoreBand = [CCSprite spriteWithFile:scorePics[0]];
        CGSize size = [[CCDirector sharedDirector] winSize];
        scoreBand.position = ccp(50, size.height-50);
        scoreBand.scale = 0.5;
        self->layer = layer;
        [layer addChild:scoreBand];
    }
    return self;
}

- (void*) setScore: (int) score{
    [scoreBand setTexture:[[CCTextureCache sharedTextureCache] addImage:scorePics[score]]];
}

- (void*) remove{
    [scoreBand removeFromParentAndCleanup:YES];
}
@end
