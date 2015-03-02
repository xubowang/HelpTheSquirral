//
//  MainMenu.m
//  HelpTheSquirrel
//
//  Created by XuboWang on 6/28/14.
//
//

#import "MainMenu.h"
#import "HelloWorldLayer.h"

@implementation MainMenu

+(id)scene{
    CCScene *scene = [CCScene node];
    MainMenu *layer = [MainMenu node];
    [scene addChild:layer];
    return scene;
}

-(void)startGame:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[Level scene]];
}

-(id)init
{
    if(self = [super init]){
        // Create a title for the scene
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Help The Squirrel" fontName:@"Courier" fontSize:30];
        CGSize size = [[CCDirector sharedDirector] winSize];
        title.position = ccp(size.width/2, size.height/2);
        [self addChild:title];
        
        // Create a layer for the menu
        CCLayer *menulayer = [[CCLayer alloc] init];  // This layer wil contain all of our meny items
        [self addChild:menulayer];
        
        // Create a button/link to start our game
        CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"startButton.png" selectedImage:@"startButtonSelected.png" target:self selector:@selector(startGame:)];
        //        CCMenuItem *start = [CCMenuItemFont itemWithString:@"Leaderboard"];
        
        // Actually create the menu and add startButton to it, we are adding the menu to the menuLayer we just created
        CCMenu *menu = [CCMenu menuWithItems:startButton, nil];
        [menu setPosition:ccp(size.width/2, size.height/2 - 50)];
        [self addChild: menu];
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end
