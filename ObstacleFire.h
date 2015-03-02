//
//  ObstacleFire.h
//  HelpTheSquirrel
//
//  Created by Lai Danbo on 7/10/14.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Nut.h"
#define PTM_RATIO 32

@interface ObstacleFire : NSObject{
    b2Body* obstacleFireBody;
    b2Fixture* obstacleFireFixture;
    CCSprite* obstacleFireSprite_;
    CCLayer* layer;
    b2World* world;
    
    b2RevoluteJoint *joint;
}

-(void*)initObstacleFire:(CGPoint) obstacleFireLocation withOrientation:(float32) obstacleFireOrientation withLength:(float32) obstacleFireLength withWorld: (b2World*) world withLayer:(CCLayer*)layer;
-(b2Body*)getBody;
-(void*)removeObstacleFire;
-(b2Fixture*)getFixture;
-(void) afterHit:(Nut*)nut;

@end
