//
//  Star.h
//  HelpTheSquirrel
//
//  Created by Xiang Zhang on 6/15/14.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#define PTM_RATIO 32

static CCSpriteBatchNode *starExplodeSpriteSheet = NULL;
@interface Star : NSObject{
    b2Body *starBody;
    CCSprite *starSprite;
    b2Fixture *starFixture;
    b2World *world;
    CCLayer *layer;
}

- (void*) initStarAt:(CGPoint)point withWorld: (b2World*)world withLayer:(CCLayer*) layer;
- (void*) deleteExplode;//:(CCSprite*) explodeSprite;
- (void*) removeStar;
- (b2Body*) getBody;
- (b2Fixture*) getFixture;
+ (void*) registerStarAnim: (CCLayer*) layer;
+ (void*) removeStarAnim;
+ (void*) starAnimRegister;
@end
