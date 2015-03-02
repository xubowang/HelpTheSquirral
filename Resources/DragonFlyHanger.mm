//
//  MyCocos2DClass.m
//  HelpTheSquirrel
//
//  Created by Student on 7/5/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "DragonFlyHanger.h"


@implementation DragonFlyHanger

- (DragonFlyHanger*) initDragonFlyHanger:(CGPoint)point withWorld:(b2World*)world withLayer:(CCLayer*) layer{
    self = [super init];
    if(self){
        //Animation part
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"BeeAnim.plist"];
        beeAnimSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"BeeAnim.png"];
        [layer addChild:beeAnimSpriteSheet];
        
        NSMutableArray *beeAnimFrames = [NSMutableArray array];
        for (int i=1; i<=8; i++) {
            [beeAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"bee%d.png",i]]];
        }
        CCAnimation *beeAnim = [CCAnimation animationWithSpriteFrames:beeAnimFrames delay:0.1f];
        dragonFlyHangerSprite = [CCSprite spriteWithSpriteFrameName:@"bee1.png"];
        [dragonFlyHangerSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:beeAnim]]];
        [beeAnimSpriteSheet addChild:dragonFlyHangerSprite];
        dragonFlyHangerSprite.scale = 2;
        //[layer addChild:dragonFlyHangerSprite];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        bodyDef.userData = dragonFlyHangerSprite;
        bodyDef.linearDamping = 0.3f;
        dragonFlyHangerBody = world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 15.0/PTM_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 10.0f;
        fixtureDef.isSensor = true;
        dragonFlyHangerFixture = dragonFlyHangerBody->CreateFixture(&fixtureDef);
        
        self->layer=layer;
        self->world=world;
        self->position=point;
        canHang = true;
        joint = NULL;
    }
    return self;
}

- (void*) configure: (int)speed withLeft:(int)left withRight: (int)right{
    self->speed = speed;
    self->left = left;
    self->right = right;
}

- (void*) onUpdate:(Nut *)nut withTime:(float)dt{
    if(self->position.x>=right || self->position.x<=left){
        speed *= -1;
    }
    dragonFlyHangerBody->SetTransform(b2Vec2((position.x + dt * speed) / PTM_RATIO, position.y / PTM_RATIO), dragonFlyHangerBody->GetAngle());
    position = ccp(dragonFlyHangerBody->GetPosition().x * PTM_RATIO, dragonFlyHangerBody->GetPosition().y * PTM_RATIO);
    
    if(canHang){
        CGPoint nutPosition = ccp([nut getBody]->GetPosition().x * PTM_RATIO, [nut getBody]->GetPosition().y * PTM_RATIO);
        if(ccpDistance(nutPosition, position)<30){
            canHang = false;
            b2RevoluteJointDef revoluteJointDef;
            revoluteJointDef.bodyA = dragonFlyHangerBody;
            revoluteJointDef.bodyB = [nut getBody];
            revoluteJointDef.collideConnected = false;
            revoluteJointDef.localAnchorA.Set(0,-1);
            revoluteJointDef.localAnchorB.Set(0,0);
            joint = (b2RevoluteJoint*)world->CreateJoint(&revoluteJointDef);
        }
    }
}

- (void*) onTouchUpdate:(CGPoint)touchPoint{
    if(!canHang){
        if(ccpDistance(touchPoint, position)<20){
            canHang = true;
            world->DestroyJoint(joint);
            joint=NULL;
        }
    }
}

- (void*) remove{
    [dragonFlyHangerSprite removeFromParentAndCleanup:YES];
    if(canHang==false && joint!=NULL)
    {
        world->DestroyJoint(joint);
        joint = NULL;
    }
    world->DestroyBody(dragonFlyHangerBody);
}
@end
