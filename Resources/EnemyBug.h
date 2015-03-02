//
//  EnemyBug.h
//  HelpTheSquirrel
//
//  Created by Lai Danbo on 7/8/14.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#define RS_RATIO 24
#import "VRope.h"

@interface EnemyBug : NSObject{
    b2Body *enemybugBody;
    CCSprite *enemybugSprite;
    b2Fixture *enemybugFixture;
    b2World *world;
    CCLayer *layer;
    float x;
    float y;
    VRope* rope;
    int enemybugPositionIndex;
    int count;
    BOOL drop;
    b2RevoluteJoint *joint;
}

@property (nonatomic,assign) NSInteger ropesize;

- (void*) initEnemyBugAt:(CGPoint)point withWorld: (b2World*)world withLayer:(CCLayer*) layer;
- (void*) removeEnemyBug;
- (b2Body*) getBody;
- (b2Fixture*) getFixture;
- (void) updatePosition:(CGPoint)point;
- (float) getX;
- (float) getY;
- (int) getIndex;
- (void) updateIndex:(int) index;
- (VRope*) getRope;
- (void) setRope:(VRope*)therope;
- (void) updateLocation;
- (int) toUpdate;
- (void)toDrop;

@end
