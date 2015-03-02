//
//  Nut.h
//  HelpTheSquirrel
//
//  Created by 印轩 on 14-6-18.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Box2D.h"

//PTM_RATIO defined here is for testing purposes, it should obviously be the same as your box2d world or, better yet, import a common header where PTM_RATIO is defined
#define PTM_RATIO 32

static CCSpriteBatchNode *bubblePopSpriteSheet = NULL;
@interface Nut : NSObject{
    
    b2Body *nutBody;
    CCSprite *nutSprite;
    b2Fixture *nutFixture;
    b2World *world;
    CCLayer *layer;
	CGRect nutRect;
}

-(id)initNutAt:(CGPoint)point withWorld:(b2World*)world withLayer:(CCLayer*) layer;
- (void*) removeNut;
+ (void*) registerBubbleAnim: (CCLayer*) layer;
- (b2Body*) getBody;
- (b2Fixture*) getFixture;
- (CCSprite*) getSprite;
- (CGRect)getRect;
- (void)setSprite;
-(void)setSpriteBack;

-(void)setSprite_Fire;
- (void*) bubblePop:(b2Body*)currNut;
@end
