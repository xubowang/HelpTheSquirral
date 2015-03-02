//
//  HelloWorldLayer.mm
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/2/14.
//  Copyright __MyCompanyName__ 2014. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "PhysicsSprite.h"
#import "VRope.h"
#import "Star.h"
#import "Bubble.h"
#import "Nut.h"
#import "RopeSource.h"
#import "Board.h"
#import "Level.h"
#import "EnemyBug.h"
#import "ObstacleFire.h"
#import <set>
#import "levelParser.h"
#import "readLevel.h"
#import "winLayer.h"
#import "loseLayer.h"
#import "pin.h"
#import "wrapper.h"

#import "SimpleAudioEngine.h"

#define bgmusic @"CheeZeeJungle.caf"
#define bubblePopSound @"pop3.mp3"
#define cutRopeSound @"cut.caf"
#define gameOverOO @"game_over_oo.wav"

enum {
	kTagParentNode = 1,
};

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;

@end

@implementation HelloWorldLayer



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

CustomIOS7AlertView *alertView;

-(id) init
{
	if( (self=[super init])) {
		// enable events
		self.isTouchEnabled = YES;
        nutInBubble = 0;
        dynamicGravity = 0;
        //add line dealing with rope
        ropes = [[NSMutableArray alloc] init];
        stars = [[NSMutableArray alloc] init];
        airGuns = [[NSMutableArray alloc] init];
        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"ice.png"];
        bubbles = [[NSMutableArray alloc] init];
        nuts = [[NSMutableArray alloc] init];
        ropesources = [[NSMutableArray alloc] init];
        boards = [[NSMutableArray alloc] init];
        dragonFlyHangers = [[NSMutableArray alloc] init];
        enemybugs = [[NSMutableArray alloc] init];
        obstaclefires = [[NSMutableArray alloc] init];
        pins = [[NSMutableArray alloc]init];
        
        [self addChild:ropeSpriteSheet];
        
        // Load the sprite sheet into the sprite cache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"basic_frame.plist"];              
	    // Add the background
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"icebackground.jpeg"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:-1];
        [self initPhysics];
        [self createMenuButton];
        [self initLevel];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:bgmusic loop:YES];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.4;
        [[SimpleAudioEngine sharedEngine] preloadEffect:bubblePopSound];
        [[SimpleAudioEngine sharedEngine] preloadEffect:cutRopeSound];
        [[SimpleAudioEngine sharedEngine] preloadEffect:gameOverOO];

        
		[self scheduleUpdate]; //
        [Star registerStarAnim:self];
        [Nut registerBubbleAnim:self];
    
        levelNumber = 1;
        traceLineDrawer = [[TraceLineDrawer alloc]initTraceLineDrawer:self];
        
        
        //////////add motion manager to update device motion status.
        motionManager = [[CMMotionManager alloc] init];

        [motionManager startAccelerometerUpdates];


        //motionLabel = [CCLabelTTF labelWithString:@"helle world" fontName:@"Arial" fontSize:20.0 ];
        motionLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20.0 ];
        motionLabel.position = ccp(winSize.width*0.9, winSize.height*0.9);
        
        [self addChild:motionLabel];
        
        
	}
	return self;
}

//init the level
#define cc_to_b2Vec(x,y)   (b2Vec2((x)/PTM_RATIO, (y)/PTM_RATIO))

-(void) initLevel
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    NSNumber *myLevel = [[NSUserDefaults standardUserDefaults] valueForKey:@"level"];
    //--added a switch to control the level, 1 is the ropesource one, and default is the originalone
    levelNumber = [myLevel intValue];
    _manager = [levelParser loadLevel:levelNumber];
    if (!_manager) {
        [[CCDirector sharedDirector] replaceScene:[Level scene]];
    }
    readLevel *curLevel = [_manager.levels objectAtIndex:0];
    //--danbo--here is the configuration of one very simple level
    if (curLevel != nil) {
        // Sprite
        CGPoint spriteLocation = CGPointMake(s.width * [[curLevel.spriteLocation objectAtIndex:1] floatValue]
                                             + [[curLevel.spriteLocation objectAtIndex:0] floatValue], s.height * [[curLevel.spriteLocation objectAtIndex:3]floatValue] + [[curLevel.spriteLocation objectAtIndex:2]floatValue]);
        // Body
        CGPoint bodyLocation = CGPointMake(s.width * [[curLevel.bodyLocation objectAtIndex:1]floatValue] + [[curLevel.bodyLocation objectAtIndex:0] floatValue], [[curLevel.bodyLocation objectAtIndex:2] floatValue] + s.height * [[curLevel.bodyLocation objectAtIndex:3]floatValue]);
        [self addSquirrel:spriteLocation andBodyLocation: bodyLocation];
        // Nut
        Nut *nut1 = [Nut alloc];
        [nut1 initNutAt:CGPointMake(s.width * [[curLevel.nutLocation objectAtIndex:1]floatValue] + [[curLevel.nutLocation objectAtIndex:0]floatValue], s.height * [[curLevel.nutLocation objectAtIndex:3]floatValue] + [[curLevel.nutLocation objectAtIndex:2]floatValue]) withWorld:world withLayer:self];
        b2Body *body1 = nut1.getBody;
        [nuts addObject:nut1];
        // Pin
        if ([curLevel.pin count]!=0) {
            NSMutableArray *createdPin = [[[NSMutableArray alloc]init]autorelease];
            int pinOfNumber = [curLevel.pin count];
            int i = 0;
            while (i < pinOfNumber) {
                NSArray *pinInfo = [curLevel.pin objectAtIndex:i];
                b2Vec2 restr = b2Vec2([[pinInfo objectAtIndex:4]floatValue], [[pinInfo objectAtIndex:5]floatValue]);
                pin* pin1 = [pin alloc];
                [pin1 initPin:CGPointMake(s.width * [[pinInfo objectAtIndex:1]floatValue] + [[pinInfo objectAtIndex:0]floatValue], s.height * [[pinInfo objectAtIndex:3]floatValue] + [[pinInfo objectAtIndex:2]floatValue]) withWorld:world withLayer:self resArea:restr];
                [pins addObject:pin1];
                b2Body *pinBody = [pin1 getBody];
                wrapper *wrap = [[wrapper alloc]initWithBody:pinBody];
                b2Vec2 pinLoc = pinBody->GetLocalCenter();
                if ([[pinInfo objectAtIndex:6]intValue]==1) {
                    pinLoc.y=pinLoc.y-0.5f;
                }else{
                    pinLoc.x=pinLoc.x-0.5f;
                }
                [createdPin addObject:wrap];
                NSArray *tags = [[pinInfo objectAtIndex:7]autorelease];
                for(NSString *tag in tags){
                    if ([tag isEqualToString:@"nut"]) {
                        [self createRopeWithBodyA:pinBody anchorA:pinLoc
                                            bodyB:body1 anchorB:body1->GetLocalCenter()
                                              sag:1.1];
                    }
                    else{
                        int pinNumber = tag.intValue - 1;
                        if (pinNumber <= [createdPin count]) {
                            [self createRopeWithBodyA:pinBody anchorA:pinLoc
                                                bodyB: [[createdPin objectAtIndex:pinNumber] getBody] anchorB:[[createdPin objectAtIndex:pinNumber] getBody]->GetLocalCenter()
                                                  sag:1.1];
                        }else{NSLog(@"Wrong in pin, only connect with nut or pins that have created before");}
                    }
                }
                i++;
            }
        }
        // Ropes
        if ([curLevel.factorOfRopes count] > 2) {
            for(int i = 0; i < [[curLevel.factorOfRopes objectAtIndex:0]intValue]; i++){
                [self createRopeWithBodyA:groundBody anchorA:cc_to_b2Vec(s.width * [[curLevel.factorOfRopes objectAtIndex:(2*(i+1)-1)]floatValue], s.height * [[curLevel.factorOfRopes objectAtIndex:(2*(i+1))]floatValue])
                                    bodyB:body1 anchorB:body1->GetLocalCenter()
                                      sag:1.1];
            }
        }
        // Star
        if ([curLevel.starLocation count] == 8) {
            for(int i=0;i<3;i++){
                Star* newStar = [Star alloc];
                CGPoint point;
                point.x = s.width * [[curLevel.starLocation objectAtIndex:1]floatValue] + [[curLevel.starLocation objectAtIndex:0]floatValue] + i * [[curLevel.starLocation objectAtIndex:3]floatValue] + [[curLevel.starLocation objectAtIndex:2]floatValue];
                point.y = s.height * [[curLevel.starLocation objectAtIndex:5]floatValue] + [[curLevel.starLocation objectAtIndex:4]floatValue] + [[curLevel.starLocation objectAtIndex:6]floatValue]+i*[[curLevel.starLocation objectAtIndex:7]floatValue];
                [newStar initStarAt:point withWorld:world withLayer:self];
                [stars addObject:newStar];
            }
        }
        else{
            int numOfSpecial = ([curLevel.starLocation count] - 8)/4;
            int count = 0;
            NSMutableArray *special = [[[NSMutableArray alloc]init]autorelease];
            for(int i = 0; i < numOfSpecial; i++){
                [special addObject:[curLevel.starLocation objectAtIndex:(4*i+1)]];
            }
            for(int i = 0; i < 3; i++){
                NSNumber *value = [NSNumber numberWithInt:(i+1)];
                Star* newStar = [Star alloc];
                CGPoint point;
                point.x = s.width * [[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 1)]floatValue] + [[curLevel.starLocation objectAtIndex:(4*numOfSpecial)]floatValue] + [[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 2)]floatValue] + i * [[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 3)]floatValue];
                point.y = [[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 6)]floatValue]+i*[[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 7)]floatValue] + s.height * [[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 5)]floatValue] + [[curLevel.starLocation objectAtIndex:(4*numOfSpecial + 4)]floatValue];
                if ([special containsObject:value]) {
                    if ([[curLevel.starLocation objectAtIndex:(4 * count)]intValue] == 1) {
                        point.y = point.y + [[curLevel.starLocation objectAtIndex:(4 * count + 3)]floatValue];
                        point.x = point.x + [[curLevel.starLocation objectAtIndex:(4 * count + 2)]floatValue];
                        count++;
                    }
                    else{
                        Star* newStar = [Star alloc];
                        CGPoint tpoint;
                        tpoint.x = s.width * [[curLevel.starLocation objectAtIndex:(4 * count + 2)]floatValue];;
                        tpoint.y = s.height * [[curLevel.starLocation objectAtIndex:(4 * count + 3)]floatValue];
                        [newStar initStarAt:tpoint withWorld:world withLayer:self];
                        [stars addObject:newStar];
                        count++;
                        continue;
                    }
                }
                [newStar initStarAt:point withWorld:world withLayer:self];
                [stars addObject:newStar];
            }
        }
        // RopeResources
        if([curLevel.ropeResourceLocation count] > 1){
            int numOfRopeResources = [[curLevel.ropeResourceLocation objectAtIndex:0]intValue];
            for(int i=0;i<numOfRopeResources;i++){
                RopeSource* newRopeSource = [RopeSource alloc];
                [newRopeSource updateR:[[curLevel.ropeResourceLocation objectAtIndex:1]floatValue]];
                CGPoint point;
                point.x = [[curLevel.ropeResourceLocation objectAtIndex:2]floatValue]+i*[[curLevel.ropeResourceLocation objectAtIndex:3]floatValue];
                point.y = [[curLevel.ropeResourceLocation objectAtIndex:4]floatValue]+i*[[curLevel.ropeResourceLocation objectAtIndex:5]floatValue];
                [newRopeSource updatePosition:point];
                [newRopeSource initRopesourceAt:point withWorld:world withLayer:self];
                [ropesources addObject:newRopeSource];
                
                if ([curLevel.enemy containsObject:[NSNumber numberWithInteger:(i+1)]]) {
                    //add bug
                    EnemyBug* newEnemyBug = [EnemyBug alloc];
                    [newEnemyBug updatePosition:point];
                    [newEnemyBug initEnemyBugAt:point withWorld:world withLayer:self];
                    
                    [enemybugs addObject:newEnemyBug];
                    [newRopeSource setBugBool:true];
                    [newRopeSource setBug:newEnemyBug];
                }
            }
        }
        // Bubble
        CGPoint bubbleLocation;
        if ([curLevel.bubble count]!=0) {
            int numOfBubble = [curLevel.bubble count]/2;
            for (int i = 0; i < numOfBubble; ++i) {
                Bubble *newBubble = [Bubble alloc];
                bubbleLocation = CGPointMake([[curLevel.bubble objectAtIndex:2*i]floatValue], [[curLevel.bubble objectAtIndex:2*i+1]floatValue]);
                [newBubble initBubble:bubbleLocation withWorld:world withLayer:self];
                [bubbles addObject:newBubble];
            }
        }
        // Board
        if ([curLevel.board count]!=0) {
            int numOfBoard = [curLevel.board count]/5;
            for (int i = 0; i < numOfBoard; ++i) {
                Board* newBoard = [Board alloc];
                CGPoint boardLocation1 = CGPointMake([[curLevel.board objectAtIndex:(5*i)]floatValue], [[curLevel.board objectAtIndex:(5*i + 1)]floatValue]);
                float boardStartingLocation1 = [[curLevel.board objectAtIndex:(5*i + 2)]floatValue];
                float boardOrientation;
                if ([[curLevel.board objectAtIndex:(5*i + 3)]floatValue] == 1) {
                    boardOrientation = [[curLevel.board objectAtIndex:(5*i + 4)]floatValue] / 180 * M_PI;
                }
                else{
                    boardOrientation = [[curLevel.board objectAtIndex:(5*i + 4)]floatValue];
                }
                [newBoard initBoard:&boardLocation1 withOrientation:boardOrientation withStartigLocation:boardStartingLocation1 withWorld:world withLayer:self];
                [boards addObject:newBoard];

            }
        }
        // airGun
        if ([curLevel.airGun count]!=0) {
            int numOfAirGun = [curLevel.airGun count]/2;
            for (int i = 0; i < numOfAirGun; ++i) {
                AirGun * airGun = [[AirGun alloc]initWithLayer:self withPosition:ccp([[curLevel.airGun objectAtIndex:(2*i)]floatValue],[[curLevel.airGun objectAtIndex:(2*i + 1)]floatValue]) withDirection:YES];
                [airGuns addObject:airGun];
            }
        }
        // dragonFly
        if ([curLevel.dragonFly count] != 0) {
            int numOfDragonFly = [curLevel.dragonFly count]/8;
            for (int i = 0; i < numOfDragonFly; ++i) {
                DragonFlyHanger* dragonFlyHanger = [[DragonFlyHanger alloc]initDragonFlyHanger:ccp(s.width * [[curLevel.dragonFly objectAtIndex:8 * i + 1]floatValue]+ [[curLevel.dragonFly objectAtIndex:8 * i + 0]floatValue], [[curLevel.dragonFly objectAtIndex:8 * i + 2]floatValue] + s.height * [[curLevel.dragonFly objectAtIndex:8 * i + 3]floatValue]) withWorld:world withLayer:self];
                [dragonFlyHanger configure:20 withLeft:s.width*[[curLevel.dragonFly objectAtIndex:8 * i + 4]floatValue]+[[curLevel.dragonFly objectAtIndex:8 * i + 5]floatValue] withRight:s.width*[[curLevel.dragonFly objectAtIndex:8 * i + 6]floatValue]+[[curLevel.dragonFly objectAtIndex:8 * i + 7]floatValue]];
                [dragonFlyHangers addObject:dragonFlyHanger];
            }
        }
        // dynamicGravity
        if (curLevel.dynamicGravity !=0) {
            dynamicGravity = 1;
        }
        
        // obstacle
        if ([curLevel.obstacle count] != 0) {
            int numOfObstacle = [curLevel.obstacle count] / 6;
            for (int i = 0; i < numOfObstacle; ++i) {
                CGPoint obstacleLocation = CGPointMake(s.width * [[curLevel.obstacle objectAtIndex:(6 * i + 1)]floatValue] + [[curLevel.obstacle objectAtIndex:(6 * i)]floatValue], s.height * [[curLevel.obstacle objectAtIndex:(6 * i + 3)]floatValue] + [[curLevel.obstacle objectAtIndex:(6 * i + 2)]floatValue]);
                float32 obstacleFireLength = [[curLevel.obstacle objectAtIndex:(6 * i + 4)]floatValue];
                float32 obstacleFireRotation = [[curLevel.obstacle objectAtIndex:(6 * i + 5)]floatValue] / 180 * M_PI;
                ObstacleFire *obstaclefire = [ObstacleFire alloc];
                [obstaclefire initObstacleFire:obstacleLocation withOrientation:obstacleFireRotation withLength:obstacleFireLength withWorld:world withLayer:self];
                [obstaclefires addObject:obstaclefire];
            }
        }
        [self schedule:@selector(gameLogic:) interval:10.0f];
    }
    // Advance the world by a few seconds to stabilize everything.
    int n = 10 * 60;
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    float32 dt = 1.0 / 60.0;
    while (n--)
    {
        // Instruct the world to perform a single step of simulation.
        world->Step(dt, velocityIterations, positionIterations);
        for (VRope *rope in ropes)
        {
            [rope update:dt];
        }
    }
    // This last update takes care of the texture repositioning.
    nutonfire = NO;
    nuteaten = NO;
    
    [self update:dt];
    starScore=0;
    winSize  = [[CCDirector sharedDirector] winSize];
    
    scoreBand = [[StarScoreBand alloc]initScoreBand:self];
    
}

-(void) dealloc
{
	delete world;
	world = NULL;
	delete m_debugDraw;
	m_debugDraw = NULL;
    [ropes release];
    [stars release];
    [bubbles release];
    [nuts release];
    [airGuns release];
    [ropesources release];
    [boards release];
    
    [squirrelAttitudeTimer invalidate];
    [squirrelAttitudeTimer release];
    
    delete contactListener;
    contactListener = NULL;
	
	[super dealloc];
}	

-(void) initPhysics
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	nutInBubble = 0;
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    //create contact listener
    contactListener = new MyContactListener();
    world->SetContactListener(contactListener);
}


-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	world->DrawDebugData();
	kmGLPopMatrix();
    [traceLineDrawer drawTraceLine];
}

-(void) update: (ccTime) dt     //check every dt time to see if there is any action to do when certain environment happens
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    Nut *currNut = [nuts lastObject];
    //Iterate over the bodies in the physics world
    
    //add dynamic gravity
    accelerometerData = motionManager.accelerometerData;
    acceleration = accelerometerData.acceleration;
    newLabelP = motionLabel.position.x + acceleration.x * 10;
    motionLabel.position = CGPointMake(newLabelP, motionLabel.position.y);
    
    ///////////
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        CCSprite *myActor = (CCSprite*)b->GetUserData();
        if (myActor)
        {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
        //go through every body add bouncy to every bubble
        if(nutInBubble){
            if(b == [currNut getBody]){
                b->SetLinearVelocity(b2Vec2(0.0, 2.0));
            }
        }else{
            [currNut setSpriteBack];
        }
        
        
        if(dynamicGravity == 1){
            if(b == [currNut getBody]){
                b2Vec2 currNutVelocity = b2Vec2(acceleration.x * 0.5, 0.0);
                b2Vec2 currNutOri = b->GetLinearVelocity();
                b2Vec2 newVelocity = currNutVelocity + currNutOri;
//                b->ApplyForceToCenter(currNutVelocity);
                b->SetLinearVelocity(newVelocity);
            }
        }
    }
    // Update all the ropes
    for (VRope *rope in ropes)
    {
        [rope update:dt];
        [rope updateSprites];
    }
    //Check for collisions to test winning
    bool shouldCloseCrocMouth = NO;
    std::vector<b2Body*>toDestroy;
    std::vector<MyContact>::iterator pos;
    std::set<Star*> toDestroyStars;
    std::set<Bubble*> toDestroyBubble;
    
    //--danbo
    std::set<EnemyBug*> toDestroyEnemyBug;
    
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos){
        MyContact contact = *pos;
        bool hitTheFloor = NO;
        b2Body *potentialCandy = nil;
        
        //The candy can hit the floor or the croc's mouth. Let's check what it's touching.
        if(contact.fixtureA == squirrelBoundingBox_)
        {
            potentialCandy = contact.fixtureB->GetBody();
        }else if(contact.fixtureB == squirrelBoundingBox_)
        {
            potentialCandy = contact.fixtureA->GetBody();
        }else if(contact.fixtureA->GetBody() == groundBody)
        {
            potentialCandy = contact.fixtureB->GetBody();
            hitTheFloor = YES;
        }else if(contact.fixtureB->GetBody() == groundBody)
        {
            potentialCandy = contact.fixtureA->GetBody();
            hitTheFloor = YES;
        }

        for(EnemyBug* enemybug in enemybugs){
            if([enemybug getFixture]==contact.fixtureA){
                if([currNut getFixture] == contact.fixtureB){
                        [self cuttherope];
                        nuteaten = YES;
                    dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
                        [self checkLevelFinish:YES];;
                    });
                 
                }
            }
            else if([enemybug getFixture]==contact.fixtureB){
                if([currNut getFixture] == contact.fixtureA){
                        [self cuttherope];
                        nuteaten = YES;
                    dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
                        [self checkLevelFinish:YES];;
                    });
                 
                }
            }
        }
        
        //if obstacle hit nut, level finish
        for(ObstacleFire* obstaclefire in obstaclefires){
            if([obstaclefire getFixture]==contact.fixtureA){
                if([currNut getFixture] == contact.fixtureB){
                     [currNut setSprite_Fire];
                    [obstaclefire afterHit: currNut];
                    nutonfire = YES;
                    [self checkLevelFinish:YES];
                    
                    
                }
            }
            else if([obstaclefire getFixture]==contact.fixtureB){
                if([currNut getFixture] == contact.fixtureA){
                     [currNut setSprite_Fire];
                    [obstaclefire afterHit: currNut];
                    nutonfire = YES;
                    [self checkLevelFinish:YES];
                    
                }
            }
        }
        
        for(Star* star in stars){
            if([star getFixture]==contact.fixtureA){
                if([currNut getFixture] == contact.fixtureB){
                    toDestroyStars.insert(star);
                }
            }
            else if([star getFixture]==contact.fixtureB){
                if([currNut getFixture] == contact.fixtureA){
                    toDestroyStars.insert(star);
                }
            }
        }
        for(Bubble* bubble in bubbles){
            if([bubble getFixture] == contact.fixtureA){
                if([currNut getFixture] == contact.fixtureB){
                    toDestroyBubble.insert(bubble);
                    [currNut setSprite];
                    nutInBubble = 1;
                }
            }else if([bubble getFixture] == contact.fixtureB){
                if([currNut getFixture] == contact.fixtureA){
                    toDestroyBubble.insert(bubble);
                    [currNut setSprite];
                    nutInBubble = 1;
                }
            }
        }
       
        
        //Check if the body was indeed one of the candies
        if (potentialCandy && currNut.getBody == potentialCandy) {
            //Set it to be destroyed
            toDestroy.push_back(potentialCandy);
            if(hitTheFloor){
                //If it hits the floor you'll remove all the physics of it and just simulate the pineapple sinking
                CCSprite *sinkingCandy = (CCSprite*)potentialCandy->GetUserData();
                //Sink the pineapple
                CCFiniteTimeAction *sink = [CCMoveBy actionWithDuration:3.0 position:CGPointMake(0, -sinkingCandy.textureRect.size.height)];
                //Remove the sprite and check if should finish the level
                CCFiniteTimeAction *finish = [CCCallBlockN actionWithBlock:^(CCNode *node){
                    [self removeChild:node cleanup:YES];
                    [self checkLevelFinish:YES];     //still don't have this method
                }];
                //Run the actions sequentially
                [sinkingCandy runAction:[CCSequence actions:sink, finish, nil]];
                //All the physics will be destroyed below, but you don't want the sprite do be removed, so you set it to null here
                potentialCandy->SetUserData(NULL);
            }else{
                if((!nuteaten)&&(!nutonfire)){
                    shouldCloseCrocMouth = YES;
                }
                else shouldCloseCrocMouth = NO;
            }
        }
    }
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2){
        b2Body *body = *pos2;
        if(body->GetUserData() != NULL){
            // Remove the sprite
            CCSprite *sprite = (CCSprite*) body->GetUserData();
            [self removeChild:sprite cleanup:YES];
            body->SetUserData(NULL);
        }
        //Iterate though the joints and check if any are a rope
        b2JointEdge* joints = body->GetJointList();
        while (joints) {
            b2Joint *joint = joints->joint;
            // Look in all the ropes
            for(VRope *rope in ropes){
                if(rope.joint == joint){
                    //This destroy the rope
                    [rope removeSprites];
                    [ropes removeObject:rope];
                    break;
                }
            }
            joints = joints->next;
            world->DestroyJoint(joint);
        }
        //Destroy the physics body
        world->DestroyBody(body);
        Nut *currNut = [nuts lastObject];
        if (currNut.getBody == body) {
            [nuts removeAllObjects];
        }
    }
    for(std::set<Star*>::iterator star=toDestroyStars.begin();star!=toDestroyStars.end();star++){
        Star *currStar = *star;
        [currStar removeStar];
        [stars removeObject:currStar];
        starScore++;
        [scoreBand setScore:starScore];
    }
    for(RopeSource* ropesource in ropesources){
        if(![ropesource readVisit]){
            b2Vec2 rsposition = [ropesource getBody]->GetPosition();
            float32 dist;
            Nut *nut;
            if(nuts.count!=0){
                nut = [nuts lastObject];
                b2Body *thenut = [nut getBody];
                dist = (thenut->GetPosition().x-rsposition.x)*(thenut->GetPosition().x-rsposition.x)+(thenut->GetPosition().y-rsposition.y)*(thenut->GetPosition().y-rsposition.y);
                
                if(dist<=ropesource.getR){
                    [ropesource updateVisit:true];
                    
                    VRope* thisrope = [self createRopeWithBodyA:thenut anchorA:thenut->GetLocalCenter()
                                        bodyB:[ropesource getBody] anchorB:[ropesource getBody]->GetLocalCenter()
                                          sag:1.1];
                    
                    [ropesource drawTouchCircle];
                    
                    //--danbo update bug
                    if(ropesource.readBugBool){
                        EnemyBug* thebug = ropesource.getBug;
                        [thebug setRope:thisrope];
                        [thebug updateIndex:[thisrope->vPoints count]-1];
                        thebug.ropesize = [thisrope->vPoints count];
                    }
                    //--end
                }
            }
        }
    }
    
    
    
    //enemybug behavior
    for(EnemyBug* enemybug in enemybugs){
        if(!nuteaten){
            int result = [enemybug toUpdate];
            if (result==1) {// rope cutted
                toDestroyEnemyBug.insert(enemybug);
            }
            else if (result==2){// hit the nut
                nuteaten = YES;
                [self checkLevelFinish:YES];
            }
            
            if(nuts.count!=0){
                b2Body *thenut = [[nuts lastObject] getBody];
                b2Body *thebug = [enemybug getBody];
                float dist = (thenut->GetPosition().x-thebug->GetPosition().x)*(thenut->GetPosition().x-thebug->GetPosition().x)+(thenut->GetPosition().y-thebug->GetPosition().y)*(thenut->GetPosition().y-thebug->GetPosition().y);
                
                //NSLog(@"nutx:%f, nuty:%f, enemybugx:%f, enemybugy:%f, dist %f", thenut->GetPosition().x, thenut->GetPosition().y, enemybug.getX, enemybug.getY, dist);
                if(dist<0.4){//--hard coded distance
                    
                    [self cuttherope];
                    nuteaten = YES;
                    
                    dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
                        [self checkLevelFinish:YES];;
                    });

                    
                    //[self checkLevelFinish:YES];
                }
                
            }
            
        }//--end !nuteaten
        else{
            [enemybug toDrop:[nuts lastObject]];
        }
    }
    
   
    
    //toDestroyEnemyBug while necessary
    for(std::set<EnemyBug*>::iterator enemybug=toDestroyEnemyBug.begin();enemybug!=toDestroyEnemyBug.end();enemybug++){
        EnemyBug *currEnemyBug = *enemybug;
        [currEnemyBug removeEnemyBug];
        [enemybugs removeObject:currEnemyBug];
    }
 
    
    for(std::set<Bubble*>::iterator bubble=toDestroyBubble.begin(); bubble!=toDestroyBubble.end();bubble++){
        Bubble* currBubble = *bubble;
        [currBubble removeBubble];
        [bubbles removeObject:currBubble];
    }
    if(shouldCloseCrocMouth){
        if((!nutonfire)&&(!nuteaten)){
            [self checkLevelFinish:NO];
        }
        else{
            [self checkLevelFinish:YES];
        }
    }
    for(DragonFlyHanger* hanger in dragonFlyHangers){
        for(Nut* nut in nuts){
            [hanger onUpdate:nut withTime:dt];
        }
    }
    
    
    //add motion control
    
    
    
    
    
    
    //add motion control by Phone
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

//create rope the connect two body
//--danbo changed return void to return the rope
-(VRope*) createRopeWithBodyA:(b2Body*)bodyA anchorA:(b2Vec2)anchorA bodyB:(b2Body*)bodyB anchorB:(b2Vec2)anchorB sag:(float32)sag
{
    b2RopeJointDef jd;
    jd.bodyA = bodyA;
    jd.bodyB = bodyB;
    jd.localAnchorA = anchorA;
    jd.localAnchorB = anchorB;
    
    // Max length of joint = current distance between bodies * sag
    float32 ropeLength = (bodyA->GetWorldPoint(anchorA) - bodyB->GetWorldPoint(anchorB)).Length() * sag;
    jd.maxLength = ropeLength;
    
    // Create joint
    b2RopeJoint *ropeJoint = (b2RopeJoint *)world->CreateJoint(&jd);
    
    VRope *newRope = [[VRope alloc] initWithRopeJoint:ropeJoint spriteSheet:ropeSpriteSheet];
    
    [ropes addObject:newRope];
    //[newRope release];
    return newRope;
}

//detact whether the user swap intersact with the rope or not
-(BOOL)checkLineIntersection:(CGPoint)p1 :(CGPoint)p2 :(CGPoint)p3 :(CGPoint)p4
{
    // http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
    CGFloat denominator = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    
    // In this case the lines are parallel so you assume they don't intersect
    if (denominator == 0.0f)
        return NO;
    CGFloat ua = ((p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)) / denominator;
    CGFloat ub = ((p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x)) / denominator;
    
    if (ua >= 0.0 && ua <= 1.0 && ub >= 0.0 && ub <= 1.0)
    {
        return YES;
    }
    return NO;
}
//where they intersact 
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[SimpleAudioEngine sharedEngine] playEffect:cutRopeSound];

    static CGSize s = [[CCDirector sharedDirector] winSize];
    [traceLineDrawer addLinePoint:touches];
    UITouch *touch = [touches anyObject];
    CGPoint pt0 = [touch previousLocationInView:[touch view]];
    CGPoint pt1 = [touch locationInView:[touch view]];
    // Correct Y axis coordinates to cocos2d coordinates
    pt0.y = s.height - pt0.y;
    pt1.y = s.height - pt1.y;
    for (VRope *rope in ropes)
    {
        for (VStick *stick in rope.sticks)
        {
            CGPoint pa = [[stick getPointA] point];
            CGPoint pb = [[stick getPointB] point];
            if ([self checkLineIntersection:pt0 :pt1 :pa :pb])
            {
                // Cut the rope here
                b2Body *newBodyA = [self createRopeTipBody];
                b2Body *newBodyB = [self createRopeTipBody];
                VRope *newRope = [rope cutRopeInStick:stick newBodyA:newBodyA newBodyB:newBodyB];
                
                NSInvocation* timerInvocationA = [[NSInvocation invocationWithMethodSignature:
                                   [self methodSignatureForSelector:@selector(destroyRope:)]]retain];
                [timerInvocationA setSelector:@selector(destroyRope:)];
                [timerInvocationA setTarget:self];
                [timerInvocationA setArgument:&newBodyA atIndex:2];   // argument indexing is offset by 2 hidden args
                [NSTimer scheduledTimerWithTimeInterval:2.0
                                             invocation:timerInvocationA
                                                repeats:NO];
                
                NSInvocation* timerInvocationB = [[NSInvocation invocationWithMethodSignature:
                                                 [self methodSignatureForSelector:@selector(destroyRope:)]]retain];
                [timerInvocationB setSelector:@selector(destroyRope:)];
                [timerInvocationB setTarget:self];
                [timerInvocationB setArgument:&newBodyB atIndex:2];   // argument indexing is offset by 2 hidden args
                [NSTimer scheduledTimerWithTimeInterval:2.0
                                             invocation:timerInvocationB
                                                repeats:NO];
                
                b2JointEdge* jointsA = newBodyA->GetJointList();
                b2JointEdge* jointsB = newBodyB->GetJointList();
                while (jointsA) {
                    b2Joint *joint = jointsA->joint;
                    for(VRope *rope in ropes){
                        if(rope.joint == joint){
                            [rope fadeOut];
                            break;
                        }
                    }
                    jointsA = jointsA->next;
                }
                while (jointsB) {
                    b2Joint *joint = jointsB->joint;
                    for(VRope *rope in ropes){
                        if(rope.joint == joint){
                            [rope fadeOut];
                            break;
                        }
                    }
                    jointsB = jointsB->next;
                }
                [newRope fadeOut];
                return[ropes addObject:newRope];
            }
        }
    }
    if (_mouseJoint == NULL) return;
    
    //pin detect
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint p1 = [touch locationInView:[touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:p1];
    Nut* currNut = [nuts lastObject];
    if(CGRectContainsPoint([currNut getSprite].boundingBox, convertedLocation)){
        nutInBubble = 0;
        [currNut bubblePop:[currNut getBody]];
        [[SimpleAudioEngine sharedEngine] playEffect:bubblePopSound];

    }
    for(DragonFlyHanger* hanger in dragonFlyHangers){
        [hanger onTouchUpdate:convertedLocation];
    }
    [traceLineDrawer addLinePoint:touches];
    
    b2Vec2 locationWorld = b2Vec2(convertedLocation.x/PTM_RATIO, convertedLocation.y/PTM_RATIO);
    
    
    for(pin* curPin in pins){
        if (_mouseJoint != NULL) return;
        
        if(CGRectContainsPoint([curPin getSprite].boundingBox, convertedLocation)){
            if ([curPin getFixture]->TestPoint(locationWorld)) {
                b2MouseJointDef md;
                md.bodyA = groundBody;
                md.bodyB = [curPin getBody];
                md.target = locationWorld;
                md.collideConnected = true;
                md.maxForce = 1000.0f *  [curPin getBody]->GetMass();
                
                _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
                [curPin getBody]->SetAwake(true);
            }
        }
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [traceLineDrawer clearPoint];
    
    if (_mouseJoint) {
        NSLog(@"Mouse Joint end");
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

-(void*)destroyRope:(b2Body*)body
{
    b2Body *destroyBody = body;
    b2JointEdge* joints = destroyBody->GetJointList();
    while (joints) {
        b2Joint *joint = joints->joint;
        // Look in all the ropes
        for(VRope *rope in ropes){
            if(rope.joint == joint){
                //This destroy the rope
                [rope removeSprites];
                [ropes removeObject:rope];
                break;
            }
        }
        joints = joints->next;
        world->DestroyJoint(joint);
    }
    world->DestroyBody(destroyBody);
    return 0;
}

-(void*)destroyBubble:(b2Body*)body{
    world->DestroyBody(body);
    return 0;
}

-(b2Body*)createRopeTipBody
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.linearDamping = 0.5f;
    b2Body *body = world->CreateBody(&bodyDef);
    b2FixtureDef circleDef;
    b2CircleShape circle;
    circle.m_radius = 1.0/PTM_RATIO;
    circleDef.shape = &circle;
    circleDef.density = 10.0f;
    
    //Since these tips don't have to collide with anything set the mask bits to zero
    circleDef.filter.maskBits = 0;
    body->CreateFixture(&circleDef);
    
    return body;
}

-(void)checkLevelFinish:(BOOL)forceFinish
{
    if([nuts count] == 0 && forceFinish)
    {
        //Destroy everything
        dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
            [self finishedLevel];
        });
        
        CCScene *loseScene = [loseLayer scene];
        
        [[CCDirector sharedDirector] replaceScene:loseScene];

    }
    
    if ([nuts count]==0 && !forceFinish) {
        NSNumber *level = [[NSUserDefaults standardUserDefaults] valueForKey:@"level"];
        NSString *theLevel = [level stringValue];
        NSString *theScore = [NSString stringWithFormat:@"%d",starScore];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userData.plist"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if ([NSMutableDictionary dictionaryWithContentsOfFile:path]) {
            dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        }
        NSInteger lastScore = 0;
        if (dict[theLevel]) {
            
            lastScore = [dict[theLevel] integerValue];
        }
        BOOL isUpdate = NO;
        if (lastScore <= starScore) {
            isUpdate = YES;
        }
        if (isUpdate) {
            [dict setValue:theScore forKey:theLevel];
            [dict writeToFile:path atomically:YES];
        }
        
        //[self finishedLevel];
        CCScene *winScene = [winLayer scene:starScore];
        [[CCDirector sharedDirector] replaceScene:winScene];
    }
    
    if(nutonfire||nuteaten){
        //Destroy everything
        [[SimpleAudioEngine sharedEngine] playEffect:gameOverOO];
        
        dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
        dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
            [self finishedLevel];
        });
        
        CCScene *loseScene = [loseLayer scene];
        [[CCDirector sharedDirector] replaceScene:loseScene];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ( [alertView tag] ) {
        case 1:break;
        case 2:break;
        case 3:
            if (buttonIndex == 0) {
                [[CCDirector sharedDirector] resume];
                [[CCDirector sharedDirector] replaceScene:[Level scene]];
                
            } else if (buttonIndex == 1) {
                [[CCDirector sharedDirector] resume];
                
            } else if (buttonIndex == 2) {
                [[CCDirector sharedDirector] resume];
                //[nuts removeAllObjects];
                dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
                    [self finishedLevel];
                    [self initLevel];
                });
                
            }
            break;
    }
}


-(void) finishedLevel
{
    std::set<b2Body*>toDestroy;
    //Destroy every rope and add the objects that should be destroyed
    for(VRope *rope in ropes){
        [rope removeSprites];
        //Dont destroy the groung body...
        if(rope.joint->GetBodyA() != groundBody){
            toDestroy.insert(rope.joint->GetBodyA());
        }
        if(rope.joint->GetBodyB() != groundBody){
            toDestroy.insert(rope.joint->GetBodyB());
        }
        //Destroy the joint already
        world->DestroyJoint(rope.joint);
    }
    [ropes removeAllObjects];

    for (pin *pin in pins) {
        toDestroy.insert([pin getBody]);
    }
    [pins removeAllObjects];
    
    for(Star *star in stars){
        toDestroy.insert([star getBody]);
    }
    [stars removeAllObjects];
    
    for(AirGun *airGun in airGuns){
        [airGun remove];
    }
    [airGuns removeAllObjects];
    
    for(Bubble *bubble in bubbles){
        toDestroy.insert([bubble getBody]);
    }
    [bubbles removeAllObjects];

    for(RopeSource *ropesource in ropesources){
        toDestroy.insert([ropesource getBody]);
    }
    [ropesources removeAllObjects];
    for(EnemyBug *enemybug in enemybugs){
        toDestroy.insert([enemybug getBody]);
    }
    [enemybugs removeAllObjects];
    for(ObstacleFire *obstaclefire in obstaclefires){
        toDestroy.insert([obstaclefire getBody]);
    }
    [obstaclefires removeAllObjects];
    for(Nut *nut in nuts){
        toDestroy.insert([nut getBody]);
    }
    
    
    //Destroy all the objects
    std::set<b2Body*>::iterator pos;
    for(pos = toDestroy.begin(); pos != toDestroy.end(); ++pos){
        b2Body *body = *pos;
        if(body->GetUserData() != NULL){
            //Remove the sprite
            CCSprite *sprite = (CCSprite*) body->GetUserData();
            [self removeChild:sprite cleanup:YES];
            body->SetUserData(NULL);
        }
        world->DestroyBody(body);
    }
    [nuts removeAllObjects];
    
    for(Board* board in boards){
        [board removeBoard];
    }
    [boards removeAllObjects];
    
    for(DragonFlyHanger* hanger in dragonFlyHangers){
        [hanger remove];
    }
    [dragonFlyHangers removeAllObjects];
    [self removeSquirrel];
    //what else to remove
    [scoreBand remove];
    
    for(EnemyBug *enemybug in enemybugs){
        toDestroy.insert([enemybug getBody]);
    }
    [enemybugs removeAllObjects];

    
}

- (NSMutableArray*) returnCandies{
    return nuts;
}

-(void)removeSquirrel{
    world->DestroyBody(squirrel_);
    [squirrelSprite_ removeFromParentAndCleanup:YES];
}

-(void)addSquirrel:(CGPoint)spriteLocation andBodyLocation: (CGPoint)bodyLocation{
    squirrelSprite_ = [CCSprite spriteWithFile:@"squirreln.png"];
    [squirrelSprite_ setScale: 1.4];
    squirrelSprite_.anchorPoint = CGPointMake(1.0, 0.0);
    squirrelSprite_.position = spriteLocation;
    
    [self addChild:squirrelSprite_ z:1];
    
    /*Create Circle BoundingBox for Squirrel*/
    b2BodyDef squirrelBodyDef;
    squirrelBodyDef.position.Set(bodyLocation.x / PTM_RATIO, bodyLocation.y / PTM_RATIO);
    squirrel_ = world->CreateBody(&squirrelBodyDef);
    
    b2CircleShape squirrelBox;
    squirrelBox.m_radius = 25.0/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &squirrelBox;
    fixtureDef.density = 40.0f;
    squirrelBoundingBox_ = squirrel_->CreateFixture(&fixtureDef);
    squirrel_->SetActive(YES);

}


-(void) createMenuButton {
    CCLabelTTF* menuLabel = [CCLabelTTF labelWithString:@"Menu" fontName:@"Marker Felt" fontSize:24];
    CCMenuItem* menuItem = [CCMenuItemLabel itemWithLabel:menuLabel target:self selector:@selector(menuShow)];
    CGSize s = [[CCDirector sharedDirector] winSize];
    // Create menu with buttons
    CCMenu* menu = [CCMenu menuWithItems: menuItem, nil];
    [menu alignItemsHorizontallyWithPadding:s.width*0.1f];
    menu.position = CGPointMake(s.width-40, s.height-30);
    [self addChild:menu z:100];
}
//-(void) menuShow {
//    [[CCDirector sharedDirector] pause]; //Pauses current scene
//    
//    UIAlertView *alertMenu = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:@"Continue", @"Retry", nil];
//    [alertMenu setTag:3];
//    [alertMenu show];
//}

- (void) cuttherope{
    for (VRope *rope in ropes)
    {
    
           
                // Cut the rope here
                b2Body *newBodyA = [self createRopeTipBody];
                b2Body *newBodyB = [self createRopeTipBody];
                VRope *newRope = [rope cutRopeInStick:[rope->vSticks lastObject] newBodyA:newBodyA newBodyB:newBodyB];
                
                NSInvocation* timerInvocationA = [[NSInvocation invocationWithMethodSignature:
                                                   [self methodSignatureForSelector:@selector(destroyRope:)]]retain];
                [timerInvocationA setSelector:@selector(destroyRope:)];
                [timerInvocationA setTarget:self];
                [timerInvocationA setArgument:&newBodyA atIndex:2];   // argument indexing is offset by 2 hidden args
                [NSTimer scheduledTimerWithTimeInterval:2.0
                                             invocation:timerInvocationA
                                                repeats:NO];
                
                NSInvocation* timerInvocationB = [[NSInvocation invocationWithMethodSignature:
                                                   [self methodSignatureForSelector:@selector(destroyRope:)]]retain];
                [timerInvocationB setSelector:@selector(destroyRope:)];
                [timerInvocationB setTarget:self];
                [timerInvocationB setArgument:&newBodyB atIndex:2];   // argument indexing is offset by 2 hidden args
                [NSTimer scheduledTimerWithTimeInterval:2.0
                                             invocation:timerInvocationB
                                                repeats:NO];
                
                b2JointEdge* jointsA = newBodyA->GetJointList();
                b2JointEdge* jointsB = newBodyB->GetJointList();
                while (jointsA) {
                    b2Joint *joint = jointsA->joint;
                    for(VRope *rope in ropes){
                        if(rope.joint == joint){
                            [rope fadeOut];
                            break;
                        }
                    }
                    jointsA = jointsA->next;
                }
                while (jointsB) {
                    b2Joint *joint = jointsB->joint;
                    for(VRope *rope in ropes){
                        if(rope.joint == joint){
                            [rope fadeOut];
                            break;
                        }
                    }
                    jointsB = jointsB->next;
                }
                [newRope fadeOut];
                //[ropes addObject:newRope];
        
        
    }//end of for ropses
    
    //[self checkLevelFinish:YES];
    
}

-(void)gameLogic:(ccTime)dt{
    [self moveSquirrel];
}

-(void)moveSquirrel{
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:0.1 position:ccp(squirrelSprite_.position.x, squirrelSprite_.position.y + 5)];
    CCMoveTo *reverseAction = [CCMoveTo actionWithDuration:0.1 position:ccp(squirrelSprite_.position.x, squirrelSprite_.position.y)];
    [squirrelSprite_ runAction:[CCSequence actions:actionMove, reverseAction, actionMove, reverseAction, actionMove, reverseAction, actionMove, reverseAction, actionMove, reverseAction, actionMove, reverseAction, nil]];
}

-(void) menuShow {
    [[CCDirector sharedDirector] pause]; //Pauses current scene
    
    //    UIAlertView *alertMenu = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:@"Continue", @"Retry", nil];
    //    [alertMenu setTag:3];
    //    [alertMenu show];
    // Here we need to pass a full frame
    alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    //    [alertView setButtonTitles:nil];
    //    [alertView setDelegate:self];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 10, 90, 120)];
    [demoView setBackgroundColor:[UIColor lightGrayColor]];
    [imageView setImage:[UIImage imageNamed:@"squirreln.png"]];
    [demoView addSubview:imageView];
    UIButton *goOnBtn = [[UIButton alloc] init];
    goOnBtn.frame = CGRectMake(35, 120, 50, 50);
    [goOnBtn setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [goOnBtn addTarget:self action:@selector(goOn) forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:goOnBtn];
    
    UIButton *homeBtn = [[UIButton alloc] init];
    homeBtn.frame = CGRectMake(105, 120, 50, 50);
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:homeBtn];
    
    UIButton *retryBtn = [[UIButton alloc] init];
    retryBtn.frame = CGRectMake(175, 120, 50, 50);
    [retryBtn setBackgroundImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
    [retryBtn addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:retryBtn];
    
    return demoView;
}

- (void)goOn
{
    [alertView close];
    [[CCDirector sharedDirector] resume];
}

- (void)goHome
{
    [alertView close];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[Level scene]];
}

- (void)retry
{
    [alertView close];
    [[CCDirector sharedDirector] resume];
    //[nuts removeAllObjects];
    dispatch_time_t popTimeFinishLevel = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTimeFinishLevel, dispatch_get_main_queue(), ^(void){
        [self finishedLevel];
        [self initLevel];
    });
}

@end
