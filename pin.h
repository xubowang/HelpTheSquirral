//
//  pin.h
//  HelpTheSquirrel
//
//  Created by LiMin on 7/3/14.
//
//


#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "Box2D.h"

//PTM_RATIO defined here is for testing purposes, it should obviously be the same as your box2d world or, better yet, import a common header where PTM_RATIO is defined
#define PTM_RATIO 32

@interface pin : NSObject{
    b2Body *pinBody;
    CCSprite *pinSprite;
    CCLayer *layer;
    b2World *world;
    b2Fixture *pinFixture;
    
    b2Body *groundBody;
}

@property (assign) CCSprite* pinSprite;
@property (assign) b2Body* pinBody;

-(void*)initPin: (CGPoint) pinLocation withWorld :(b2World*)world withLayer:(CCLayer*)layer resArea:(b2Vec2) restrictArea;
-(CCSprite*)getSprite;
-(b2Body*)getBody;
-(b2Fixture*) getFixture;
-(void*)removePin;
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;


@end

