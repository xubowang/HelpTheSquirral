//
//  Block.m
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/26/14.
//
//

#import "Board.h"

@implementation Board

-(void*)initBoard:(CGPoint *)boardLocation withOrientation:
(float) boardOrientation withStartigLocation:(float)boardStartingLocation withWorld:(b2World *)world withLayer:(CCLayer *)layer{
    self = [self init];
    NSLog(@"%f", boardOrientation);
    if(boardOrientation > 0){
        boardSprite_ = [CCSprite spriteWithSpriteFrameName:@"peddle35.png"];
    }else if(boardOrientation < 0){
        boardSprite_ = [CCSprite spriteWithSpriteFrameName:@"peddle48.png"];
    }
    [layer addChild:boardSprite_];
    
    b2BodyDef boardBodyDef;
    boardBodyDef.type = b2_staticBody;
    boardBodyDef.position.Set(boardLocation->x/PTM_RATIO, boardLocation->y/PTM_RATIO);
    boardBodyDef.userData = boardSprite_;
    
    boardBody = world->CreateBody(&boardBodyDef);
    boardBody->SetActive(YES);
    
    b2Vec2 temp;
    temp.Set(0.0/PTM_RATIO, -0.0/PTM_RATIO);
    
    b2PolygonShape boardShape;
    boardShape.SetAsBox(10.0/PTM_RATIO, 60.0/PTM_RATIO, temp, boardOrientation);
    
    b2FixtureDef boardFixtureDef;
    boardFixtureDef.shape = &boardShape;
    boardFixtureDef.density = 30.0f;
    boardFixture = boardBody->CreateFixture(&boardFixtureDef);
    
    self->layer = layer;
    self->world = world;
    
    
    return self;
}

-(b2Body*)getBody{
    return boardBody;
}

-(void*)removeBoard{
    world->DestroyBody(boardBody);
    [boardSprite_ removeFromParentAndCleanup:YES];

    
}

@end
