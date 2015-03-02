//
//  Block.h
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/26/14.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Box2D.h"
#define PTM_RATIO 32

@interface Board : NSObject{
    b2Body* boardBody;
    b2Fixture* boardFixture;
    CCSprite* boardSprite_;
    CCLayer* layer;
    b2World* world;
}

-(void*)initBoard:(CGPoint *)boardLocation withOrientation:
(float) boardOrientation withStartigLocation:(float)boardStartingLocation withWorld:(b2World *)world withLayer:(CCLayer *)layer;
-(b2Body*)getBody;
-(void*)removeBoard;
@end
