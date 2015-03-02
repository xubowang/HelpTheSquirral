//
//  bubble.h
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/15/14.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Box2D.h"
#define PTM_RATIO 32

@interface Bubble : NSObject{
    b2Body *bubble;
    CCSprite *bubbleSprite_;
    CCLayer *layer;
    b2World *world;
    b2Fixture *bubbleFixture;
}

@property (assign) CCSprite* bubbleSprite;
@property (assign) b2Body* bubble;

-(void*)initBubble: (CGPoint) bubbleLocation withWorld :(b2World*)world withLayer:(CCLayer*)layer;

-(CCSprite*)getSprite;
-(b2Body*)getBody;
-(b2Fixture*) getFixture;
-(void*)removeBubble;

@end
