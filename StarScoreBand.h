//
//  StarScoreBand.h
//  HelpTheSquirrel
//
//  Created by Xiang Zhang on 7/1/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StarScoreBand : NSObject {
    CCSprite* scoreBand;
    CCLayer* layer;
    NSArray* scorePics;
    CGPoint position;
}

- (StarScoreBand*) initScoreBand: (CCLayer*)layer;
- (void*) remove;
- (void*) setScore:(int)score;

@end
