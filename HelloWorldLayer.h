//
//  HelloWorldLayer.h
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/2/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#include <CoreMotion/CoreMotion.h>
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "AirGun.h"
#import "TraceLineDrawer.h"
#import "StarScoreBand.h"
#import "DragonFlyHanger.h"
#import "EnemyBug.h"
#import "allLevels.h"
#import "CustomIOS7AlertView.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
static int test=0;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate,UIAlertViewDelegate,CustomIOS7AlertViewDelegate>
{
//	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;
    CCSprite *squirrelSprite_;  // strong ref
    NSMutableArray *ropes;
    NSMutableArray *nuts;
    NSMutableArray *stars;
    NSMutableArray *bubbles;
    NSMutableArray *airGuns;
    NSMutableArray *ropesources;
    NSMutableArray *boards;
    NSMutableArray *dragonFlyHangers;
    NSMutableArray *enemybugs;
    NSMutableArray *obstaclefires;
    NSMutableArray *pins;
    BOOL nutonfire;
    BOOL nuteaten;
    
    b2Body *groundBody;
    CCSpriteBatchNode *ropeSpriteSheet;
    
    b2MouseJoint *_mouseJoint;
    
    b2Body *squirrel_;
    b2Fixture *squirrelBoundingBox_;
    

    int nutInBubble;
    int starScore;
    int levelNumber;
    NSTimer *squirrelAttitudeTimer;
    NSTimer *timerA;
    NSTimer *timerB;
    
    CGSize winSize;
    
    CMMotionManager *motionManager;//add motion manager to detect device motion
    CCLabelTTF *motionLabel;
    CMAccelerometerData *accelerometerData;
    CMAcceleration acceleration;
    CGFloat newLabelP;
    int dynamicGravity;
    
    MyContactListener *contactListener;  //contact listener
    TraceLineDrawer* traceLineDrawer;
    StarScoreBand* scoreBand;
    allLevels* _manager;


}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (NSMutableArray*) returnCandies;

@end










