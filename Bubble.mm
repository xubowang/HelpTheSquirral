//
//  bubble.m
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/15/14.
//
//

#import "Bubble.h"

@implementation Bubble

@synthesize bubble = bubble;
@synthesize bubbleSprite = bubbleSprite_;

-(void*)initBubble:(CGPoint)bubbleLocation withWorld:(b2World*)world withLayer:(CCLayer*)layer{
    self = [super init];
    bubbleSprite_ = [CCSprite spriteWithSpriteFrameName:@"bubble.png"];
    [layer addChild:bubbleSprite_];
    
    b2BodyDef bubbleBodyDef;
    bubbleBodyDef.type = b2_staticBody;
    bubbleBodyDef.position.Set(bubbleLocation.x/PTM_RATIO, bubbleLocation.y/PTM_RATIO);
    bubbleBodyDef.userData = bubbleSprite_;
    
    bubble = world->CreateBody(&bubbleBodyDef);
    bubble->SetActive(YES);
//    bubble->SetLinearVelocity(b2Vec2(0.0, 0.0));
    
    b2CircleShape circle;
    circle.m_radius = 25.0/PTM_RATIO;
    
    b2FixtureDef bubbleShapeDef;
    bubbleShapeDef.shape = &circle;
    bubbleShapeDef.density = 0.5f;
    bubbleShapeDef.friction = 0.2f;
    bubbleShapeDef.restitution = 0.8f;
    bubbleFixture = bubble->CreateFixture(&bubbleShapeDef);
    
    self->layer = layer;
    self->world = world;
    
    return self;
}

-(CCSprite*)getSprite{
    return bubbleSprite_;
}

-(b2Body*)getBody{
    return bubble;
}

-(void*)removeBubble{
    [bubbleSprite_ removeFromParentAndCleanup:YES];
    world->DestroyBody(bubble);
}

-(b2Fixture*)getFixture{
    return bubbleFixture;
}



@end
