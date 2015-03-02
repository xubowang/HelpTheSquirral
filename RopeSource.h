//
//  RopeSource.h
//  HelpTheSquirrel
//
//  Created by Lai Danbo on 6/19/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "EnemyBug.h"
#define RS_RATIO 24


@interface RopeSource : NSObject {
    b2Body *ropesourceBody;
    CCSprite *ropesourceSprite;
    b2Fixture *ropesourceFixture;
    b2World *world;
    CCLayer *layer;
    bool visited;
    float x;
    float y;
    float rad;
    
    bool bug;
    EnemyBug* enemybug;
    
    b2FixtureDef initfixture;
   
    
}
- (void*) initRopesourceAt:(CGPoint)point withWorld: (b2World*)world withLayer:(CCLayer*) layer;
- (void*) removeRopesource;
- (b2Body*) getBody;
- (b2Fixture*) getFixture;
- (void) updatePosition:(CGPoint)point;
- (float) getX;
- (float) getY;
- (void) updateVisit:(bool)visit;
- (bool) readVisit;
- (float) getR;
- (void) updateR:(float) radios;
- (bool) readBugBool;
- (void) setBugBool:(bool)bugvalue;
- (EnemyBug*) getBug;
- (void) setBug: (EnemyBug*)thebug;
- (void) drawTouchCircle;

@end
