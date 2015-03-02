//
//  EnemyBug.m
//  HelpTheSquirrel
//
//  Created by Lai Danbo on 7/8/14.
//
//

#import "EnemyBug.h"
#import "Nut.h"

@implementation EnemyBug

- (void*) initEnemyBugAt:(CGPoint)point withWorld: (b2World*)world withLayer:(CCLayer*) layer{
    self = [super init];
    if(self){
        enemybugSprite = [CCSprite spriteWithFile:@"enemyBug.png"];
        [layer addChild:enemybugSprite];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position = b2Vec2(point.x/RS_RATIO, point.y/RS_RATIO);
        bodyDef.userData = enemybugSprite;
        bodyDef.linearDamping = 0.0f;
        enemybugBody = world->CreateBody(&bodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 6.0/RS_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 30.0f;
        enemybugFixture = enemybugBody->CreateFixture(&fixtureDef);
        
        self->layer=layer;
        self->world=world;
        
        self->rope=NULL;
        self->enemybugPositionIndex=0;
        self->count=0;
        self.ropesize=-1;
        self->drop = NO;
        self->joint=NULL;
    }
    return self;
}
- (void*) removeEnemyBug{
    [enemybugSprite removeFromParentAndCleanup:YES];
    world->DestroyBody(enemybugBody);
}
- (b2Body*) getBody{
    return enemybugBody;
}
- (b2Fixture*) getFixture{
    return enemybugFixture;
}
- (void) updatePosition:(CGPoint)point{
    self->x = point.x;
    self->y = point.y;
    
}
- (void) updateLocation{
    enemybugBody->SetTransform(b2Vec2((self->x)/PTM_RATIO,(self->y)/PTM_RATIO), enemybugBody->GetAngle());
}

- (float) getX{
    return x;
}
- (float) getY{
    return y;
}

- (int) getIndex{
    return enemybugPositionIndex;
}
- (void) updateIndex:(int)index{
    self->enemybugPositionIndex=index;
    //NSLog(@"index:%d", enemybugPositionIndex);
}
- (VRope*) getRope{
    return rope;
}
- (void) setRope:(VRope*)therope{
    self->rope = therope;
}

- (int) toUpdate{
    if(self.getIndex!=0){
        VRope* therope = self.getRope;
        if(therope!=NULL){
            NSMutableArray* points = therope->vPoints;
            if([points count]!=self.ropesize){return 1;}//the rope already cutted
            
            if(count==60){
                count=0;
                int currentindex=self.getIndex-1;
                if(self.getIndex>0){
                    if(self.getIndex<[points count]){
                        [self updateIndex:currentindex];
                        VPoint* location =points[self.getIndex];
                        [self updatePosition:location.point];
                        [self updateLocation];
                        return 0;
                    }else{
                        //toDestroyEnemyBug.insert(enemybug);
                        return 1; //to destroy
                    }
                }
                else{
                    //[self checkLevelFinish:YES];
                    return 2;
                }
                
            }
            else{
                //int currentindex=enemybug.getIndex-1;
                count++;
                if(self.getIndex>0){
                    if(self.getIndex<[points count]){
                        VPoint* location =points[self.getIndex];
                        //continuous move
                        VPoint* nextlocation=points[self.getIndex-1];
                        CGFloat weight = ((CGFloat)count)/60;
                        CGFloat posx = (nextlocation.x)*weight+(location.x)*(1-weight);
                        CGFloat posy = (nextlocation.y)*weight+(location.y)*(1-weight);
                        CGPoint continuousPos = CGPointMake(posx,posy);
                        [self updatePosition:continuousPos];
                        [self updateLocation];
                    }else{
                        //toDestroyEnemyBug.insert(enemybug);
                        return 1;
                    }
                }
                else{
                    //[self checkLevelFinish:YES];
                    return 2; //checkLevelFinish
                }                
            }
        }//end of therope!=null
        else{
            //toDestroyEnemyBug.insert(enemybug);
            return 1;
        }
    }
}

- (void) toDrop:(Nut*)nut{
    if(drop){
        if(self.getY>20){
            CGPoint newPos = CGPointMake(self.getX, self.getY-3);
            [self updatePosition:newPos];
            [self updateLocation];
        }
    }
    else{
        CGPoint nutPosition = ccp([nut getBody]->GetPosition().x * PTM_RATIO, [nut getBody]->GetPosition().y * PTM_RATIO);
            drop = YES;
            b2RevoluteJointDef revoluteJointDef;
            revoluteJointDef.bodyA = self.getBody;
            revoluteJointDef.bodyB = [nut getBody];
            revoluteJointDef.collideConnected = NO;
            revoluteJointDef.localAnchorA.Set(0,1);
            revoluteJointDef.localAnchorB.Set(0,0);
            joint = (b2RevoluteJoint*)world->CreateJoint(&revoluteJointDef);
    }
}

@end
