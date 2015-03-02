//
//  Nut.m
//  HelpTheSquirrel
//
//  Created by 印轩 on 14-6-18.
//
//

#import "Nut.h"

@implementation Nut

- (id)initNutAt:(CGPoint)point withWorld:(b2World *)world withLayer:(CCLayer *)layer
{
    self = [super init];
    if (self) {
        
        // Get the sprite from the sprite sheet
        nutSprite = [CCSprite spriteWithSpriteFrameName:@"nut.png"];
        [layer addChild:nutSprite];
        
        CGSize s = [nutSprite contentSize];
        CGPoint p = [nutSprite position];
        nutRect = CGRectMake(p.x - 0.5 * s.width, p.y - 0.5 * s.height, s.width, s.height);
        
        // Defines the body of your candy
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        bodyDef.position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        bodyDef.userData = nutSprite;
        bodyDef.linearDamping = 0.3f;
        nutBody = world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 15.0/PTM_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 30.0f;
        fixtureDef.filter.categoryBits = 0x01;
        fixtureDef.filter.maskBits = 0x01;
        nutFixture = nutBody->CreateFixture(&fixtureDef);
        
        self->layer=layer;
        self->world=world;
        
    }
    
    return self;
}

- (void*) removeNut{
    [nutSprite removeFromParentAndCleanup:YES];
    world->DestroyBody(self->nutBody);
}

- (b2Body*) getBody{
    return nutBody;
}

- (b2Fixture*) getFixture{
    return nutFixture;
}

- (CCSprite *)getSprite
{
    return nutSprite;
}

-(CGRect)getRect
{
    return nutRect;
}

-(void)setSprite{
    [nutSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bubble_nut.png"]];
    
}
//--danbo temp for set fire spirit
-(void)setSprite_Fire{
    //[nutSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"nut.png"]];
    //NSLog(@"set sprit fire");    
}

+ (void*) registerBubbleAnim: (CCLayer*) layer{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bubblePop.plist"];
    bubblePopSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bubblePop.png"];
    [layer addChild:bubblePopSpriteSheet];
}


-(void)setSpriteBack{
    [nutSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"nut.png"]];
}

- (void*) bubblePop:(b2Body*)currNut{
    NSMutableArray *bubblePopAnimFrames = [NSMutableArray array];
    for(int i=1; i<=4; ++i){
        [bubblePopAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bubblePop%d.png",i]]];
    }
    CCAnimation *bubblePopAnim = [CCAnimation animationWithSpriteFrames:bubblePopAnimFrames delay:0.1f];
    CCSprite *bubblePopSprite = [CCSprite spriteWithSpriteFrameName:@"bubblePop1.png"];
    [bubblePopSprite setPosition:ccp(currNut->GetPosition().x * PTM_RATIO, currNut->GetPosition().y * PTM_RATIO)];
    [bubblePopSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:bubblePopAnim]]];
    [bubblePopSpriteSheet addChild:bubblePopSprite];   //undefined thing
    NSInvocation* deletePopInvocation = [[NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(deletePop:)]]retain];
    [deletePopInvocation setSelector:@selector(deletePop:)];
    
    [deletePopInvocation setTarget:self];
    [deletePopInvocation setArgument:&bubblePopSprite atIndex:2];
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                 invocation:deletePopInvocation
                                    repeats:NO];
}

-(void*) deletePop:(CCSprite*) bubblePopSprite{
    [bubblePopSprite removeFromParentAndCleanup:YES];
}

@end
