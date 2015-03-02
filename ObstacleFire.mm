//
//  ObstacleFire.m
//  HelpTheSquirrel
//
//  Created by Lai Danbo on 7/10/14.
//
//

#import "ObstacleFire.h"

@implementation ObstacleFire

-(void*)initObstacleFire:(CGPoint) obstacleFireLocation withOrientation:(float32) obstacleFireOrientation withLength:(float32) obstacleFireLength withWorld: (b2World*) world withLayer:(CCLayer*)layer{
    self = [super init];
    
    
    //don't know how to dynamiclly change the rotation of the sprite
    if((obstacleFireOrientation-0.0)<0.001){
        obstacleFireSprite_ = [CCSprite spriteWithFile:@"obstacle_2.png"];
    }
    else{
        obstacleFireSprite_ = [CCSprite spriteWithFile:@"obstacle.png"];
    }
   
    [layer addChild:obstacleFireSprite_];
    
    b2BodyDef obstacleFireBodyDef;
    obstacleFireBodyDef.type = b2_staticBody;
    obstacleFireBodyDef.position.Set((obstacleFireLocation.x-100)/PTM_RATIO,obstacleFireLocation.y/PTM_RATIO);
    obstacleFireBodyDef.userData = obstacleFireSprite_;
    
    obstacleFireBody = world->CreateBody(&obstacleFireBodyDef);
    obstacleFireBody->SetActive(YES);
    
    b2Vec2 temp;
    temp.Set(0/PTM_RATIO, 0/PTM_RATIO);
    
    b2PolygonShape obstacleFireShape;
    obstacleFireShape.SetAsBox(2.0/PTM_RATIO, obstacleFireLength/PTM_RATIO, temp, obstacleFireOrientation);
    //obstacleFireShape.SetAsBox();
    
    b2FixtureDef obstacleFireFixtureDef;
    obstacleFireFixtureDef.shape = &obstacleFireShape;
    obstacleFireFixtureDef.density = 0.0f;
    obstacleFireFixture = obstacleFireBody->CreateFixture(&obstacleFireFixtureDef);

    
    self->layer = layer;
    self->world = world;
        
    return self;
}
-(b2Body*)getBody{
    return obstacleFireBody;
}
-(void*)removeObstacleFire{
    world->DestroyBody(obstacleFireBody);
    //[boardSprite_ removeFromParentAndCleanup:YES];
}
-(b2Fixture*)getFixture{
    return obstacleFireFixture;
}

-(void) afterHit:(Nut*)nut{
    b2Vec2 vel = nut.getBody->GetLinearVelocity();
    b2Vec2 force = b2Vec2(-100*vel.x,-100*vel.y);
    nut.getBody->ApplyForce(force, nut.getBody->GetPosition());}


@end
