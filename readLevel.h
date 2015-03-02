//
//  readLevel.h
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/5/14.
//
//

#import <Foundation/Foundation.h>

@interface readLevel : NSObject{
    int levelNum;
    int dynamicGravity;
    NSMutableArray *spriteLocation;
    NSMutableArray *bodyLocation;
    NSMutableArray *nutLocation;
    NSMutableArray *pin;
    NSMutableArray *factorOfRopes;
    NSMutableArray *starLocation;
    NSMutableArray *ropeResourceLocation;
    NSMutableArray *bubble;
    NSMutableArray *board;
    NSMutableArray *airGun;
    NSMutableArray *dragonFly;
    NSMutableArray *enemy;
    NSMutableArray *obstacle;
}

@property (nonatomic) int levelNum, dynamicGravity;
@property (nonatomic, retain) NSMutableArray *spriteLocation, *bodyLocation, *nutLocation;
@property (nonatomic, retain) NSMutableArray *factorOfRopes, *pin;
@property (nonatomic, retain) NSMutableArray *starLocation, *ropeResourceLocation, *obstacle;
@property (nonatomic, retain) NSMutableArray *bubble, *board, *airGun, *dragonFly, *enemy;


-(id)initWithLevel:(int)levelNum dynamicGravity:(int)dynamicGravity spriteLocation:(NSMutableArray*)spriteLocation bodyLocation:(NSMutableArray*)bodyLocation nutLocation:(NSMutableArray*)nutLocation factorOfRopes:(NSMutableArray*)factorOfRopes starLocation:(NSMutableArray*)starLocation ropeReourceLocation:(NSMutableArray*)ropeResourceLocation bubble:(NSMutableArray*)bubble board:(NSMutableArray*)board airGun:(NSMutableArray*)airGun dragonFly:(NSMutableArray*)dragonFly enemy:(NSMutableArray*)enemy obstacle:(NSMutableArray*)obstacle pin:(NSMutableArray*)pin;

@end
