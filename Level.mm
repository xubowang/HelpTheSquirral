//
//  Level.mm
//  HelpTheSquirrel
//
//  Created by yanxuzhou on 6/26/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "HelloWorldLayer.h"
#import "MainMenu.h"


@implementation Level
{
    int lvlSelected;
    NSInteger unlockLevel;
}
+(id) scene
{
    CCScene *scene = [CCScene node];
    Level *layer = [Level node];
    [scene addChild: layer];
    return scene;
}

/*-(void)startGame: (id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}*/

-(void)sendLevel1:(id)sender
{
    
    lvlSelected = 1;
     NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
    
   
    
}
-(void)sendLevel2: (id)sender
{
    lvlSelected = 2;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
    
}
-(void)sendLevel3: (id)sender
{
    lvlSelected = 3;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}
-(void)sendLevel4: (id)sender
{
    lvlSelected = 4;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}
-(void)sendLevel5: (id)sender
{
    lvlSelected = 5;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}

-(void)sendLevel6: (id)sender
{
    lvlSelected = 6;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}
-(void)sendLevel7: (id)sender
{
    lvlSelected = 7;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}

-(void)sendLevel8: (id)sender
{
    lvlSelected = 8;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}

-(void)sendLevel9: (id)sender
{
    lvlSelected = 9;
    NSNumber *myLevel = [[NSNumber alloc] initWithInt:lvlSelected];
    [[NSUserDefaults standardUserDefaults] setValue:myLevel forKey:@"level"];
    if (lvlSelected <= unlockLevel) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}

-(id)init
{
    if(self = [super init]){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userData.plist"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        unlockLevel = dict.count + 1;
        
        for (int i = 1; i < 10; i++) {
            [self setLevel:i];
        }
        
        
//        
//        // Create a title for the scene
//       // CCLabelTTF *title = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Courier" fontSize:30];
//        CGSize size = [[CCDirector sharedDirector] winSize];
//        //title.position = ccp(size.width/2, size.height/2);
//        //[self addChild:title];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userData.plist"];
//        
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//        
//        
//        
//        // Load the sprite sheet into the sprite cache
//        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"iceFrame_bubble.plist"];      //start adding new frame to the scene
//        
	    // Add the background
        CCSprite *background = [CCSprite spriteWithFile:@"levelmenubg.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:-1];
//
//        // level and lock and star
//        CCMenuItemImage *levelimage1 = [CCMenuItemImage itemWithNormalImage:@"levelicon_1.png" selectedImage:@"levelicon_1.png" target:self selector:@selector(sendLevel1:)];
//        
//        CCMenu *level1 = [CCMenu menuWithItems:levelimage1, nil];
//        [level1 setPosition:ccp(size.width/4, size.height/6*5+7)];
//        [self addChild: level1];
//        NSString *lvl1Star = dict[@"1"];
//        if ([lvl1Star isEqualToString:@"1"]) {
//            
//            CCSprite *star11 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
//            star11.position =ccp(size.width/4-23, size.height/6*5-55+7);
//            [self addChild:star11];
//            CCSprite *star12 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//            star12.position =ccp(size.width/4, size.height/6*5-55+7);
//            [self addChild:star12];
//            CCSprite *star13 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//            star13.position =ccp(size.width/4+23, size.height/6*5-55+7);
//            [self addChild:star13];
//            
//        } else if ([lvl1Star isEqualToString:@"2"]) {
//            
//            CCSprite *star11 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
//            star11.position =ccp(size.width/4-23, size.height/6*5-55+7);
//            [self addChild:star11];
//            CCSprite *star12 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
//            star12.position =ccp(size.width/4, size.height/6*5-55+7);
//            [self addChild:star12];
//            CCSprite *star13 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//            star13.position =ccp(size.width/4+23, size.height/6*5-55+7);
//            [self addChild:star13];
//            
//        } else if ([lvl1Star isEqualToString:@"3"]) {
//            
//            CCSprite *star11 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
//            star11.position =ccp(size.width/4-23, size.height/6*5-55+7);
//            [self addChild:star11];
//            CCSprite *star12 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
//            star12.position =ccp(size.width/4, size.height/6*5-55+7);
//            [self addChild:star12];
//            CCSprite *star13 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
//            star13.position =ccp(size.width/4+23, size.height/6*5-55+7);
//            [self addChild:star13];
//            
//        } else {
//            CCSprite *star11 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//            star11.position =ccp(size.width/4-23, size.height/6*5-55+7);
//            [self addChild:star11];
//            CCSprite *star12 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//            star12.position =ccp(size.width/4, size.height/6*5-55+7);
//            [self addChild:star12];
//            CCSprite *star13 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//            star13.position =ccp(size.width/4+23, size.height/6*5-55+7);
//            [self addChild:star13];
//        }
//        
//
//        
//        
//        // level and lock and star
//        CCMenuItemImage *levelimage2 = [CCMenuItemImage itemWithNormalImage:@"levelicon_2.png" selectedImage:@"levelicon_2.png" target:self selector:@selector(sendLevel2:)];
//        
//        CCMenu *level2 = [CCMenu menuWithItems:levelimage2, nil];
//        [level2 setPosition:ccp(size.width/4*2, size.height/6*5+7)];
//        [self addChild: level2];
//        
//        CCSprite *lock2 = [CCSprite spriteWithFile:@"lockicon.png"];
//        lock2.position =ccp(size.width/4*2+20, size.height/6*5-15+7);
//        [self addChild:lock2];
//        
//        CCSprite *star21 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star21.position =ccp(size.width/4*2-23, size.height/6*5-55+7);
//        [self addChild:star21];
//        CCSprite *star22 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star22.position =ccp(size.width/4*2, size.height/6*5-55+7);
//        [self addChild:star22];
//        CCSprite *star23 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star23.position =ccp(size.width/4*2+23, size.height/6*5-55+7);
//        [self addChild:star23];
//        
//        
//        // level and lock and star
//        CCMenuItemImage *levelimage3 = [CCMenuItemImage itemWithNormalImage:@"levelicon_3.png" selectedImage:@"levelicon_3.png" target:self selector:@selector(sendLevel3:)];
//        
//        CCMenu *level3 = [CCMenu menuWithItems:levelimage3, nil];
//        [level3 setPosition:ccp(size.width/4*3, size.height/6*5+7)];
//        [self addChild: level3];
//        
//        CCSprite *lock3 = [CCSprite spriteWithFile:@"lockicon.png"];
//        lock3.position =ccp(size.width/4*3+20, size.height/6*5-15+7);
//        [self addChild:lock3];
//        
//        CCSprite *star31 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star31.position =ccp(size.width/4*3-23, size.height/6*5-55+7);
//        [self addChild:star31];
//        CCSprite *star32 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star32.position =ccp(size.width/4*3, size.height/6*5-55+7);
//        [self addChild:star32];
//        CCSprite *star33 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star33.position =ccp(size.width/4*3+23, size.height/6*5-55+7);
//        [self addChild:star33];
//        
//        
//        
//        // level and lock and star
//        CCMenuItemImage *levelimage4 = [CCMenuItemImage itemWithNormalImage:@"levelicon_4.png" selectedImage:@"levelicon_4.png" target:self selector:@selector(sendLevel4:)];
//        
//        CCMenu *level4 = [CCMenu menuWithItems:levelimage4, nil];
//        [level4 setPosition:ccp(size.width/4, size.height/6*3+7)];
//        [self addChild: level4];
//        
//        CCSprite *lock4 = [CCSprite spriteWithFile:@"lockicon.png"];
//        lock4.position =ccp(size.width/4+20, size.height/6*3-15+7);
//        [self addChild:lock4];
//        
//        CCSprite *star41 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star41.position =ccp(size.width/4-23, size.height/6*3-55+7);
//        [self addChild:star41];
//        CCSprite *star42 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star42.position =ccp(size.width/4, size.height/6*3-55+7);
//        [self addChild:star42];
//        CCSprite *star43 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star43.position =ccp(size.width/4+23, size.height/6*3-55+7);
//        [self addChild:star43];
//
//        
//        
//        // level and lock and star
//        CCMenuItemImage *levelimage5 = [CCMenuItemImage itemWithNormalImage:@"levelicon_5.png" selectedImage:@"levelicon_5.png" target:self selector:@selector(self)];
//        
//        CCMenu *level5 = [CCMenu menuWithItems:levelimage5, nil];
//        [level5 setPosition:ccp(size.width/4*2, size.height/6*3+7)];
//        [self addChild: level5];
//        
//        CCSprite *lock5 = [CCSprite spriteWithFile:@"lockicon.png"];
//        lock5.position =ccp(size.width/4*2+20, size.height/6*3-15+7);
//        [self addChild:lock5];
//        
//        CCSprite *star51 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star51.position =ccp(size.width/4*2-23, size.height/6*3-55+7);
//        [self addChild:star51];
//        CCSprite *star52 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star52.position =ccp(size.width/4*2, size.height/6*3-55+7);
//        [self addChild:star52];
//        CCSprite *star53 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star53.position =ccp(size.width/4*2+23, size.height/6*3-55+7);
//        [self addChild:star53];
//        
//        
//        
//        // level and lock and star
//        CCMenuItemImage *levelimage6 = [CCMenuItemImage itemWithNormalImage:@"levelicon_6.png" selectedImage:@"levelicon_6.png" target:self selector:@selector(self)];
//        
//        CCMenu *level6 = [CCMenu menuWithItems:levelimage6, nil];
//        [level6 setPosition:ccp(size.width/4*3, size.height/6*3+7)];
//        [self addChild: level6];
//        
//        CCSprite *lock6 = [CCSprite spriteWithFile:@"lockicon.png"];
//        lock6.position =ccp(size.width/4*3+20, size.height/6*3-15+7);
//        [self addChild:lock6];
//        
//        CCSprite *star61 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star61.position =ccp(size.width/4*3-23, size.height/6*3-55+7);
//        [self addChild:star61];
//        CCSprite *star62 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star62.position =ccp(size.width/4*3, size.height/6*3-55+7);
//        [self addChild:star62];
//        CCSprite *star63 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star63.position =ccp(size.width/4*3+23, size.height/6*3-55+7);
//        [self addChild:star63];
//        
//        
//        
//        // level and lock and star
//        CCMenuItemImage *levelimage7 = [CCMenuItemImage itemWithNormalImage:@"levelicon_7.png" selectedImage:@"levelicon_7.png" target:self selector:@selector(self)];
//        
//        CCMenu *level7 = [CCMenu menuWithItems:levelimage7, nil];
//        [level7 setPosition:ccp(size.width/4, size.height/6+7)];
//        [self addChild: level7];
//        
//        CCSprite *lock7 = [CCSprite spriteWithFile:@"lockicon.png"];
//        lock7.position =ccp(size.width/4+20, size.height/6-15+7);
//        [self addChild:lock7];
//        
//        CCSprite *star71 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star71.position =ccp(size.width/4-23, size.height/6-55+7);
//        [self addChild:star71];
//        CCSprite *star72 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star72.position =ccp(size.width/4, size.height/6-55+7);
//        [self addChild:star72];
//        CCSprite *star73 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
//        star73.position =ccp(size.width/4+23, size.height/6-55+7);
//        [self addChild:star73];
    }
    
    return self;
}

- (void)setLevel:(NSInteger)level
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    //title.position = ccp(size.width/2, size.height/2);
    //[self addChild:title];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userData.plist"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSString *imageNormal = [NSString stringWithFormat:@"levelicon_%d.png",level];
    CCMenuItemImage *levelimage = [[CCMenuItemImage alloc] init];
    switch (level) {
        case 1:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel1:)];
            break;
        case 2:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel2:)];
            break;
        case 3:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel3:)];
            break;
        case 4:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel4:)];
            break;
        case 5:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel5:)];
            break;
        case 6:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel6:)];
            break;
        case 7:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel7:)];
            break;
        case 8:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel8:)];
            break;
        case 9:
            levelimage = [CCMenuItemImage itemWithNormalImage:imageNormal selectedImage:imageNormal target:self selector:@selector(sendLevel9:)];
            break;
        default:
            break;
    }
    
    NSInteger reminder = (level-1)%3;
    NSInteger quotient = (level-1)/3;
    
    CGFloat myX = size.width/4 * (reminder+1);
    CGFloat myY = size.height/6*(5-2*quotient)+7;
    
    CCMenu *levelPic = [CCMenu menuWithItems:levelimage, nil];
    [levelPic setPosition:ccp(myX,myY)];
    [self addChild: levelPic];
    NSString *levelString = [NSString stringWithFormat:@"%d",level];
    NSString *lvlStar = dict[levelString];
    
    if ([lvlStar isEqualToString:@"1"]) {
        
        CCSprite *star1 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
        star1.position =ccp(myX-23, myY-55);
        [self addChild:star1];
        CCSprite *star2 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
        star2.position =ccp(myX, myY-55);
        [self addChild:star2];
        CCSprite *star3 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
        star3.position =ccp(myX+23, myY-55);
        [self addChild:star3];
        
    } else if ([lvlStar isEqualToString:@"2"]) {
        
        CCSprite *star1 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
        star1.position =ccp(myX-23, myY-55);
        [self addChild:star1];
        CCSprite *star2 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
        star2.position =ccp(myX, myY-55);
        [self addChild:star2];
        CCSprite *star3 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
        star3.position =ccp(myX+23, myY-55);
        [self addChild:star3];
        
    } else if ([lvlStar isEqualToString:@"3"]) {
        
        CCSprite *star1 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
        star1.position =ccp(myX-23, myY-55);
        [self addChild:star1];
        CCSprite *star2 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
        star2.position =ccp(myX, myY-55);
        [self addChild:star2];
        CCSprite *star3 = [CCSprite spriteWithFile:@"staricon_achieved.png"];
        star3.position =ccp(myX+23, myY-55);
        [self addChild:star3];
        
    } else {
        
        if (level > unlockLevel) {
            CCSprite *lock = [CCSprite spriteWithFile:@"lockicon.png"];
            lock.position =ccp(myX+20, myY-15);
            [self addChild:lock];
        }
        
        CCSprite *star1 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
        star1.position =ccp(myX-23, myY-55);
        [self addChild:star1];
        CCSprite *star2 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
        star2.position =ccp(myX, myY-55);
        [self addChild:star2];
        CCSprite *star3 = [CCSprite spriteWithFile:@"staricon_notachieved.png"];
        star3.position =ccp(myX+23, myY-55);
        [self addChild:star3];
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end
