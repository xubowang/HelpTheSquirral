//
//  AirGun.h
//  HelpTheSquirrel
//
//  Created by Xiang Zhang on 6/23/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"

static CCSpriteBatchNode *airGunSpriteSheet = NULL;
@interface AirGun : CCSprite <CCTargetedTouchDelegate> {
    CCLayer* layer;
    BOOL right;
}
- (id) initWithLayer: (CCLayer*) layer withPosition: (CGPoint) point withDirection:(BOOL) left;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void*) remove;
@end
