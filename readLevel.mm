//
//  readLevel.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/5/14.
//
//

#import "readLevel.h"

@implementation readLevel

@synthesize levelNum, dynamicGravity, spriteLocation, bodyLocation, nutLocation, dragonFly, enemy, obstacle;
@synthesize factorOfRopes, starLocation, ropeResourceLocation, bubble, board, airGun, pin;

-(id)initWithLevel:(int)lNum dynamicGravity:(int)dynamicG spriteLocation:(NSMutableArray *)sLoc bodyLocation:(NSMutableArray *)bLoc nutLocation:(NSMutableArray *)nLoc factorOfRopes:(NSMutableArray *)fOfRopes starLocation:(NSMutableArray *)starLoc ropeReourceLocation:(NSMutableArray *)ropeRLoc bubble:(NSMutableArray *)bub board:(NSMutableArray *)boa airGun:(NSMutableArray *)airG dragonFly:(NSMutableArray *)dFly enemy:(NSMutableArray *)ene obstacle:(NSMutableArray *)obst pin:(NSMutableArray *)pi{
    if (self = [super init]) {
        self.levelNum = lNum;
        self.dynamicGravity = dynamicG;
        self.spriteLocation = sLoc;
        self.bodyLocation = bLoc;
        self.nutLocation = nLoc;
        self.factorOfRopes = fOfRopes;
        self.starLocation = starLoc;
        self.ropeResourceLocation = ropeRLoc;
        self.bubble = bub;
        self.board = boa;
        self.airGun = airG;
        self.dragonFly = dFly;
        self.enemy = ene;
        self.obstacle = obst;
        self.pin = pi;
    }
    return self;
}

-(void)dealloc{
    [self.spriteLocation release];
    self.spriteLocation = nil;
    [self.bodyLocation release];
    self.bodyLocation = nil;
    [self.nutLocation release];
    self.nutLocation = nil;
    [self.factorOfRopes release];
    self.factorOfRopes = nil;
    [self.starLocation release];
    self.starLocation = nil;
    [self.ropeResourceLocation release];
    self.ropeResourceLocation = nil;
    [self.bubble release];
    self.bubble = nil;
    [self.board release];
    self.board = nil;
    [self.airGun release];
    self.airGun = nil;
    [self.dragonFly release];
    self.dragonFly = nil;
    [self.enemy release];
    self.enemy = nil;
    [self.obstacle release];
    self.obstacle = nil;
    [self.pin release];
    self.pin = nil;
    [super dealloc];
}
@end
