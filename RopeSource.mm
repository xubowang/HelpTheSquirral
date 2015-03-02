//
//  RopeSource.m
//  HelpTheSquirrel
//
//  Created by Lai Danbo on 6/19/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "RopeSource.h"


@implementation RopeSource

- (void*) initRopesourceAt:(CGPoint)point withWorld:(b2World*)world withLayer:(CCLayer*) layer{
    self = [super init];
    if(self){
        ropesourceSprite = [CCSprite spriteWithFile:@"ropesorce_init.png"];
        [layer addChild:ropesourceSprite];
        //self.draw;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position = b2Vec2(point.x/RS_RATIO, point.y/RS_RATIO);
        bodyDef.userData = ropesourceSprite;
        bodyDef.linearDamping = 0.1f;
        ropesourceBody = world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 2.0/RS_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 0.0f;
        
        ropesourceFixture = ropesourceBody->CreateFixture(&fixtureDef);
        
        initfixture = fixtureDef;
        
        self->layer=layer;
        self->world=world;
        
        self->rad = 3; //default value
        
        visited = FALSE;
        bug = FALSE;
        enemybug = NULL;
        
    }
    return self;
}

- (void*) removeRopesource{
    //[starSprite removeFromParentAndCleanup:YES];
    world->DestroyBody(ropesourceBody);
}

- (b2Body*) getBody{
    return ropesourceBody;
}

- (b2Fixture*) getFixture{
    return ropesourceFixture;
}

- (void) updatePosition:(CGPoint)point{
    self->x = point.x;
    self->y = point.y;
}
- (float) getX{
    return x;
}
- (float) getY{
    return y;
}

- (void) updateVisit:(bool)visit{
    self->visited = visit;
}
- (bool) readVisit{
    return visited;
}

- (float) getR{
    return rad;
}
- (void) updateR:(float) radios{
    self->rad = radios;
}

- (bool) readBugBool{
    return bug;
}
- (void) setBugBool:(bool)bugvalue{
    self->bug = bugvalue;
}

- (EnemyBug*) getBug{
    return enemybug;
}
- (void) setBug: (EnemyBug*)thebug{
    enemybug = thebug;
}


- (void) drawTouchCircle
{
    [ropesourceSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ropesorce_after.png"]];
}


@end
