//
//  winLayer.h
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/20/14.
//
//

#import <cocos2d.h>

@interface winLayer : CCLayerColor
{
    CCSprite *_winSquirrel;
    CCSprite *_score;
    CCMenuItemImage *_home;
    CCMenu *_menuHome;
    CCMenuItemImage *_replay;
    CCMenu *_menuReplay;
    CCMenuItemImage *_next;
    CCMenu *_menuNext;
    int _count;
    int _star;
}

+(CCScene *)scene:(int)star;
-(id)initWithNumber:(int)star;
-(void)animateStar:(ccTime)dt;


@end
