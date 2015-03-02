//
//  loseLayer.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/21/14.
//
//

#import "loseLayer.h"
#import "Level.h"
#import "HelloWorldLayer.h"

@implementation loseLayer
+(CCScene *)scene{
    CCScene *scene = [CCScene node];
    loseLayer *layer = [[[loseLayer alloc]initLose]autorelease];
    [scene addChild:layer];
    return scene;
}

-(void)animateSquirrel:(ccTime)dt{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMoveTo *right = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(winSize.width/2 + _loseSquirrel.contentSize.width/2 + 33, winSize.height/2 - _loseSquirrel.contentSize.height/2)];
    CCMoveTo *left = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(winSize.width/2 + _loseSquirrel.contentSize.width/2 + 27, winSize.height/2 - _loseSquirrel.contentSize.height/2)];
    CCMoveTo *center = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(winSize.width/2 + _loseSquirrel.contentSize.width/2 + 30, winSize.height/2 - _loseSquirrel.contentSize.height/2)];
    [_loseSquirrel runAction:[CCRepeat actionWithAction:[CCSequence actions:right, left, center, nil] times:2]];
}

-(id)initLose{
    if (self = [super initWithColor:ccc4(200, 200, 200, 200)]) {
        _loseSquirrel = [CCSprite spriteWithFile:@"squirrell.png"];
        [_loseSquirrel setScale:1.6];
        _loseSquirrel.anchorPoint = CGPointMake(1.0, 0.0);
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _loseSquirrel.position = CGPointMake(winSize.width/2 + _loseSquirrel.contentSize.width/2 + 30, winSize.height/2 - _loseSquirrel.contentSize.height/2);
        
        NSString *message = @"MAYBE NEXT TIME...";
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"MarkerFelt-Thin" fontSize:32];
        label.color = ccc3(0, 0, 0);
        label.position = ccp(winSize.width/2, winSize.height * 0.8);
        
        [self addChild:label];

        [self addChild:_loseSquirrel];
        
        [self schedule:@selector(animateSquirrel:) interval:2.0f];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _home = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home.png" target:self selector:@selector(animateHomeButton:)];
            [_home setScale:0.1];
            _home.anchorPoint = CGPointMake(1.0, 0.0);
            _menuHome = [CCMenu menuWithItems:_home, nil];
            _menuHome.position = CGPointMake(winSize.width/2 - 20, winSize.height * 0.3);
            [self addChild:_menuHome];
            
            _replay = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay.png" target:self selector:@selector(animateReplayButton:)];
            [_replay setScale:0.1];
            _replay.anchorPoint = CGPointMake(1.0, 0.0);
            _menuReplay = [CCMenu menuWithItems:_replay, nil];
            _menuReplay.position = CGPointMake(winSize.width/2 + 50, winSize.height * 0.3);
            [self addChild:_menuReplay];
            
            CCScaleTo *homeScale = [CCScaleTo actionWithDuration:0.8 scale:1.0];
            [_home runAction: homeScale];
            CCScaleTo *replayScale = [CCScaleTo actionWithDuration:0.8 scale:1.0];
            [_replay runAction:replayScale];
        });
    }
    return  self;
}

-(void)animateHomeButton:(id)sender{
    CCMoveTo *right = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuHome.position.x + 5, _menuHome.position.y)];
    CCMoveTo *left = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuHome.position.x - 5, _menuHome.position.y)];
    CCMoveTo *center = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuHome.position.x, _menuHome.position.y)];
    [_menuHome runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:right, left , center, nil] times:4], [CCCallBlockN actionWithBlock:^(CCNode *node){
        [[CCDirector sharedDirector] replaceScene:[Level scene]];
    }], nil]];
}

-(void)animateReplayButton:(id)sender{
    CCMoveTo *right = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuReplay.position.x + 5, _menuReplay.position.y)];
    CCMoveTo *left = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuReplay.position.x - 5, _menuReplay.position.y)];
    CCMoveTo *center = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuReplay.position.x, _menuReplay.position.y)];
    [_menuReplay runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:right, left, center, nil] times:4], [CCCallBlockN actionWithBlock:^(CCNode *node){
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }],nil]];
}
@end
