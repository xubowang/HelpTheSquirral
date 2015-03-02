//
//  Star.m
//  HelpTheSquirrel
//
//  Created by Xiang Zhang on 6/15/14.
//
//

#import "Star.h"

@implementation Star

- (void*) initStarAt:(CGPoint)point withWorld:(b2World*)world withLayer:(CCLayer*) layer{
    self = [super init];
    if(self){
        starSprite = [CCSprite spriteWithFile:@"star.png"];
        [layer addChild:starSprite];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        bodyDef.userData = starSprite;
        bodyDef.linearDamping = 0.3f;
        starBody = world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 15.0/PTM_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 30.0f;
        fixtureDef.isSensor = true;
        starFixture = starBody->CreateFixture(&fixtureDef);
        
        self->layer=layer;
        self->world=world;
    }
    return self;
}

+ (void*) registerStarAnim: (CCLayer*) layer{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CloudAnim.plist"];
    starExplodeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"CloudAnim.png"];
    [layer addChild:starExplodeSpriteSheet];
}

+ (void*) removeStarAnim{
    [starExplodeSpriteSheet removeFromParentAndCleanup:YES];
}

- (void*) removeStar{
    [starSprite removeFromParentAndCleanup:YES];
    world->DestroyBody(starBody);
    [self starExplodeAnim];
}

- (b2Body*) getBody{
    return starBody;
}

- (b2Fixture*) getFixture{
    return starFixture;
}

- (void*) starExplodeAnim{
    NSMutableArray *starExplodeAnimFrames = [NSMutableArray array];
    for (int i=1; i<=3; i++) {
        [starExplodeAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"cloud%d.png",i]]];
    }
    CCAnimation *starExplodeAnim = [CCAnimation animationWithSpriteFrames:starExplodeAnimFrames delay:0.045f];
    CCSprite *starExplodeSprite = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    [starExplodeSprite setPosition:ccp(self->starBody->GetPosition().x*PTM_RATIO, self->starBody->GetPosition().y*PTM_RATIO)];
    [starExplodeSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:starExplodeAnim]]];
    [starExplodeSpriteSheet addChild:starExplodeSprite];
    
    NSInvocation* deleteExplodeInvocation = [[NSInvocation                                       invocationWithMethodSignature:[self methodSignatureForSelector:@selector(deleteExplode:)]]retain];
    [deleteExplodeInvocation setSelector:@selector(deleteExplode:)];
    [deleteExplodeInvocation setTarget:self];
    [deleteExplodeInvocation setArgument:&starExplodeSprite atIndex:2];
    [NSTimer scheduledTimerWithTimeInterval:0.135
                                 invocation:deleteExplodeInvocation
                                    repeats:NO];
}

- (void*) deleteExplode:(CCSprite*) starExplodeSprite{
    [starExplodeSprite removeFromParentAndCleanup:YES];
}
@end
