//
//  winLayer.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/20/14.
//
//

#import "winLayer.h"
#import "Level.h"
#import "HelloWorldLayer.h"

@implementation winLayer
+(CCScene *)scene:(int)star {
    CCScene *scene = [CCScene node];
    winLayer *layer = [[[winLayer alloc]initWithNumber:star]autorelease];
    [scene addChild:layer];
    return scene;
}


-(id)initWithNumber:(int)star{
    if (self = [super initWithColor:ccc4(255, 50, 50, 255)]) {
        _count = 0;
        _star = star;
        _winSquirrel = [CCSprite spriteWithFile:@"squirrels.png"];
        [_winSquirrel setScale:1.4];
        _winSquirrel.anchorPoint = CGPointMake(1.0, 0.0);
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _winSquirrel.position = CGPointMake(winSize.width/2 + _winSquirrel.contentSize.width/2 + 20, winSize.height/2 - _winSquirrel.contentSize.height/2 + 20);
        
        NSString *message = @"CONGRATULATION !";
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"MarkerFelt-Thin" fontSize:32];
        label.color = ccc3(255, 255, 0);
        label.position = ccp(winSize.width/2, winSize.height * 0.8);
        [self addChild:label];
        [self addChild:_winSquirrel];
        
        _score = [CCSprite spriteWithFile:@"starScore0.png"];
        _score.anchorPoint = CGPointMake(1.0, 0.0);
        _score.position = CGPointMake(winSize.width/2 + _winSquirrel.contentSize.width/2 + 60, winSize.height/2 - _winSquirrel.contentSize.height/2 - 50);
        [self addChild:_score];
        
        [self schedule:@selector(animateStar:) interval:0.8f];
    }
    return self;
}

-(void)animateSquirrel:(ccTime)dt{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMoveTo *right = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(winSize.width/2 + _winSquirrel.contentSize.width/2 + 20, winSize.height/2 - _winSquirrel.contentSize.height/2 + 25)];
    CCMoveTo *left = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(winSize.width/2 + _winSquirrel.contentSize.width/2 + 20, winSize.height/2 - _winSquirrel.contentSize.height/2 + 15)];
    [_winSquirrel runAction:[CCRepeat actionWithAction:[CCSequence actions:right, left, nil] times:5]];
}

-(void)animateStar:(ccTime)dt{
    if (_count <= _star) {
        [self removeChild:_score cleanup:YES];
        _score = [CCSprite spriteWithFile:[NSString stringWithFormat:@"starScore%d.png", _count]];
        _score.anchorPoint = CGPointMake(1.0, 0.0);
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _score.position = CGPointMake(winSize.width/2 + _winSquirrel.contentSize.width/2 + 60, winSize.height/2 - _winSquirrel.contentSize.height/2 - 50);
        [self addChild:_score];
        if (_count == _star) {
            [self schedule:@selector(animateSquirrel:) interval:2.0f];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _home = [CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home.png" target:self selector:@selector(animateHomeButton:)];
                [_home setScale:0.1];
                _home.anchorPoint = CGPointMake(1.0, 0.0);
                _menuHome = [CCMenu menuWithItems:_home, nil];
                _menuHome.position = CGPointMake(winSize.width/2 - 50, winSize.height * 0.2);
                [self addChild:_menuHome];
                
                _replay = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay.png" target:self selector:@selector(animateReplayButton:)];
                [_replay setScale:0.1];
                _replay.anchorPoint = CGPointMake(1.0, 0.0);
                _menuReplay = [CCMenu menuWithItems:_replay, nil];
                _menuReplay.position = CGPointMake(winSize.width/2 + 20, winSize.height * 0.2);
                [self addChild:_menuReplay];
                
                _next = [CCMenuItemImage itemWithNormalImage:@"next.png" selectedImage:@"next.png" target:self selector:@selector(animateNextButton:)];
                [_next setScale:0.1];
                _next.anchorPoint = CGPointMake(1.0, 0.0);
                _menuNext = [CCMenu menuWithItems:_next, nil];
                _menuNext.position = CGPointMake(winSize.width/2 + 90, winSize.height * 0.2);
                [self addChild:_menuNext];
                
                CCScaleTo *homeScale = [CCScaleTo actionWithDuration:0.8 scale:1.0];
                [_home runAction: homeScale];
                CCScaleTo *replayScale = [CCScaleTo actionWithDuration:0.8 scale:1.0];
                [_replay runAction:replayScale];
                CCScaleTo *nextScale = [CCScaleTo actionWithDuration:0.8 scale:1.0];
                [_next runAction:nextScale];
            });
            
        }
        _count++;
    }
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

-(void)animateNextButton:(id)sender{
    CCMoveTo *right = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuNext.position.x + 5, _menuNext.position.y)];
    CCMoveTo *left = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuNext.position.x - 5, _menuNext.position.y)];
    CCMoveTo *center = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(_menuNext.position.x, _menuNext.position.y)];
    [_menuNext runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:right, left, center, nil] times:4], [CCCallBlockN actionWithBlock:^(CCNode *node){
        NSNumber *myLevel = [[NSUserDefaults standardUserDefaults] valueForKey:@"level"];
        myLevel = @([myLevel integerValue]+1);
        [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
        [[CCDirector sharedDirector]replaceScene:[HelloWorldLayer scene]];
    }],nil]];
}

@end
