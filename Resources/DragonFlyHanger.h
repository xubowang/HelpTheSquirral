//
//  MyCocos2DClass.h
//  HelpTheSquirrel
//
//  Created by Student on 7/5/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Nut.h"
#define PTM_RATIO 32.0
static CCSpriteBatchNode *beeAnimSpriteSheet = NULL;
@interface DragonFlyHanger : NSObject {
    b2Body *dragonFlyHangerBody;
    CCSprite *dragonFlyHangerSprite;
    b2Fixture *dragonFlyHangerFixture;
    b2World *world;
    CCLayer *layer;
    int left;
    int right;
    int speed;
    b2RevoluteJoint *joint;
    bool canHang;
    CGPoint position;
}

- (DragonFlyHanger*) initDragonFlyHanger:(CGPoint)point withWorld:(b2World*)world withLayer:(CCLayer*)layer;
- (void*) onUpdate:(Nut*) nut withTime:(float)dt;
- (void*) onTouchUpdate:(CGPoint)touchPoint;
- (void*) remove;
- (void*) configure: (int)speed withLeft:(int)left withRight: (int)right;
@end
