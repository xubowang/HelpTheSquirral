//
//  pin.m
//  HelpTheSquirrel
//
//  Created by LiMin on 7/3/14.
//
//

#import "pin.h"
#import "HelloWorldLayer.h"

@implementation pin
@synthesize pinBody = pin;
@synthesize pinSprite = pinSprite;

-(void*)initPin:(CGPoint)pinLocation withWorld:(b2World*)world withLayer:(CCLayer*)layer resArea:(b2Vec2) restrictArea
{
    self = [super init];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCTexture2D *icePinImage = [[CCTextureCache sharedTextureCache] addImage:@"icePin.png"];
    pinSprite = [CCSprite spriteWithTexture:icePinImage];
    //pinSprite.position=ccp(s.width/4, 300);
    [layer addChild:pinSprite];
    
   
    
    b2BodyDef pinBodyDef;
    pinBodyDef.type = b2_dynamicBody;
    pinBodyDef.position.Set(pinLocation.x/PTM_RATIO,pinLocation.y/PTM_RATIO);
    pinBodyDef.userData = pinSprite;
    pinBody = world->CreateBody(&pinBodyDef);
    //pin->SetActive(YES);
    //bubble->SetLinearVelocity(b2Vec2(0.0, 0.0));
    
    b2CircleShape circle;
    circle.m_radius = 15.0/PTM_RATIO;
    
    b2FixtureDef pinShapeDef;
    pinShapeDef.shape = &circle;
    pinShapeDef.density = 100.0f;
    //pinShapeDef.friction = 0.1f;
    //pinShapeDef.restitution = 0.1f;
    pinFixture = pinBody->CreateFixture(&pinShapeDef);
    
    
    
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
    

    b2PrismaticJointDef jointDef;
    //b2Vec2 worldAxis(300.0f, 0.0f);
    jointDef.collideConnected = true;
    jointDef.Initialize(pinBody, groundBody,
                        pinBody->GetWorldCenter(), restrictArea);
    world->CreateJoint(&jointDef);
    
    self->layer = layer;
    self->world = world;
    
    return self;
}

-(CCSprite*)getSprite{
    return pinSprite;
}

-(b2Body*)getBody{
    return pinBody;
}

-(void*)removePin{
    [pinSprite removeFromParentAndCleanup:YES];
    world->DestroyBody(pinBody);
}

-(b2Fixture*)getFixture{
    return pinFixture;
}



@end
