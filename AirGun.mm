//
//  AirGun.m
//  HelpTheSquirrel
//
//  Created by Xiang Zhang on 6/23/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "AirGun.h"
#import "Nut.h"
#import "SimpleAudioEngine.h"

#define windSound @"wind.wav"


@implementation AirGun

- (id) initWithLayer: (CCLayer*) layer withPosition: (CGPoint) point withDirection:(BOOL)right
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"AirGun.plist"];
    airGunSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"AirGun.png"];
    self = [super initWithSpriteFrameName:@"AirGun1.png"];
    [layer addChild:airGunSpriteSheet];
    if(self){
        self.position = point;
        self->layer = layer;
        self->right = right;
        self.scale = 2;
        [layer addChild:self];
    }
    [[SimpleAudioEngine sharedEngine] preloadEffect:windSound];
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) onEnter{
    [super onEnter];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(CGRect) rect {
    CGSize s = [self.texture contentSize];
    return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

-(BOOL) didTouch: (UITouch*)touch {
    return CGRectContainsPoint( [self rect], [self convertTouchToNodeSpaceAR: touch] );
}

-(void*) remove{
    [self removeFromParentAndCleanup:YES];
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if([self didTouch: touch]) {
        NSLog(@"expect force");
        [[SimpleAudioEngine sharedEngine] playEffect:windSound];
        
        NSMutableArray* nuts = [(HelloWorldLayer*)layer returnCandies];
        for(Nut* nut in nuts)
        {
            b2Body* b2Candy = nut.getBody;
            CGPoint candyPosition = ccp(b2Candy->GetPosition().x * PTM_RATIO,b2Candy->GetPosition().y * PTM_RATIO);
            CGPoint force = ccp(250.0 * PTM_RATIO/abs(candyPosition.y-self.position.y), 0);
            b2Candy->ApplyLinearImpulse(b2Vec2(force.x / PTM_RATIO, force.y / PTM_RATIO), b2Candy->GetPosition());
        }
        
        CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"AirGunParticle.plist"];
        [layer addChild:particle_system];
        
        particle_system.position = ccp(self.position.x+10, self.position.y);
        [particle_system resetSystem];
        
        NSMutableArray* airAnimFrames = [NSMutableArray array];
        for (int i=1; i<=6; i++) {
            [airAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"AirGun%d.png",i]]];
        }
        CCAnimation* airGunAnim = [CCAnimation animationWithSpriteFrames:airAnimFrames delay:0.05f];
        [self runAction:[CCAnimate actionWithAnimation:airGunAnim]];
        return YES;
    }
    return NO;
}
@end
