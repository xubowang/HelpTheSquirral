//
//  loseLayer.h
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/21/14.
//
//

#import <cocos2d.h>

@interface loseLayer : CCLayerColor
{
    CCSprite *_loseSquirrel;
    CCMenuItemImage *_home;
    CCMenu *_menuHome;
    CCMenuItemImage *_replay;
    CCMenu *_menuReplay;
    CCMenuItemImage *_next;
    CCMenu *_menuNext;
}
+(CCScene *)scene;
-(id)initLose;
@end
