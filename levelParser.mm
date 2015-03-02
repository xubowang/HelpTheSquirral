//
//  levelParser.m
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/5/14.
//
//

#import "levelParser.h"
#import "GDataXMLNode.h"
#import "allLevels.h"
#import "readLevel.h"

@implementation levelParser
+(NSString*)dataFilePath:(BOOL)forSave Number:(int)LevelNumber{
    NSString *nameOfFile = [NSString stringWithFormat:@"levelInfo%d", LevelNumber];
    return [[NSBundle mainBundle] pathForResource:nameOfFile ofType:@"xml"];
}

+(NSMutableArray *)extractInfo:(NSArray *)origin{
    NSArray *child = [[[NSArray alloc]init]autorelease];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    child = [[origin objectAtIndex:0]children];
    if ([child count] > 0) {
        for(GDataXMLElement *traverse in child){
            NSNumber *info = [NSNumber numberWithFloat:traverse.stringValue.floatValue];
            [result addObject:info];
        }
    }else{NSLog(@"Wrong pattern"); return nil;}
    return result;
}

+(NSMutableArray*)extractPinInfo:(NSArray*)source{
    NSMutableArray *result = [[[NSMutableArray alloc]init]autorelease];
    NSLog(@"%@",source);
    for (int i = 0; i < [source count] - 1; ++i) {
        GDataXMLElement *traverse = [source objectAtIndex:i];
        NSNumber *info = [NSNumber numberWithFloat:traverse.stringValue.floatValue];
        [result addObject:info];
    }
    NSArray *tags = [[source lastObject] children];
    NSMutableArray *tagInfo = [[[NSMutableArray alloc]init]autorelease];
    for(GDataXMLElement *traverse in tags){
        NSString *tag = traverse.stringValue;
        [tagInfo addObject:tag];
    }
    [result addObject:tagInfo];
    return result;
}

+(NSMutableArray *)anotherExtract:(NSArray *)origin{
    NSMutableArray *final = [[[NSMutableArray alloc]init]autorelease];
    for(GDataXMLElement *traverse in origin){
        NSArray *result = [traverse children];
        for(GDataXMLElement *child in result){
            NSNumber *info = [NSNumber numberWithFloat:child.stringValue.floatValue];
            [final addObject:info];
        }
    }
    return final;
}

+(allLevels *)loadLevel:(int)levelNumber{
    NSString *filePath = [self dataFilePath:false Number:levelNumber];
    if (!filePath) {
        return nil;
    }
    NSData *xmlData = [[NSMutableData alloc]initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:xmlData options:0 error:&error];
    if(doc == nil){return nil;}
    allLevels *alLevels = [[[allLevels alloc]init]autorelease];
    NSArray *levelMembers = [doc.rootElement elementsForName:@"Level"];
    for(GDataXMLElement *levelMember in levelMembers){
        int levelNum, dynamicGravity = 0;
        NSMutableArray *spriteInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *bodyInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *nutInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *ropesInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *starInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *ropeResourceInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *bubbleInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *boardInfo = [[[NSMutableArray alloc] init]autorelease];
        NSMutableArray *airGunInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *dragonInfo = [[[NSMutableArray alloc] init]autorelease];
        NSMutableArray *enemyInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *obstInfo = [[[NSMutableArray alloc]init]autorelease];
        NSMutableArray *pinInfo = [[[NSMutableArray alloc]init]autorelease];
        NSArray *omnip = [[[NSArray alloc]init]autorelease];
        
        // Level Number
        omnip = [levelMember elementsForName:@"levelNum"];
        if ([omnip count]>0) {
            GDataXMLElement *first = (GDataXMLElement*)[omnip objectAtIndex:0];
            levelNum = first.stringValue.intValue;
        }else {NSLog(@"Not find any Level Number"); return nil;};
        
        // DynamicGravity
        omnip = [levelMember elementsForName:@"dynamicGravity"];
        if ([omnip count]>0) {
            GDataXMLElement *first = (GDataXMLElement*)[omnip objectAtIndex:0];
            dynamicGravity = first.stringValue.intValue;
        }
        
        // SpriteLocation
        omnip = [levelMember elementsForName:@"sprite"];
        if([omnip count]>0){
            spriteInfo = [self extractInfo:omnip];
        }else{NSLog(@"Not find sprite tag or wrong pattern"); return  nil;}
        
        // BodyLocation
        omnip = [levelMember elementsForName:@"body"];
        if([omnip count]>0){
            bodyInfo  = [self extractInfo:omnip];
        }else{NSLog(@"Not find body tag or wrong pattern"); return  nil;}
        
        // NutLocation
        omnip = [levelMember elementsForName:@"nut"];
        if([omnip count]>0){
            nutInfo = [self extractInfo: omnip];
        }else{NSLog(@"Not find body tag or wrong pattern"); return  nil;}
        
        // Ropes
        omnip = [levelMember elementsForName:@"ropes"];
        if ([omnip count] > 0) {
            int numOfRopes;
            NSArray *num = [[[NSArray alloc]init]autorelease];
            num = [[omnip objectAtIndex:0] elementsForName:@"numOfRopes"];
            if ([num count]>0) {
                GDataXMLElement *first = (GDataXMLElement*)[num objectAtIndex:0];
                numOfRopes = first.stringValue.intValue;
                NSNumber *info = [NSNumber numberWithInt: first.stringValue.intValue];
                [ropesInfo addObject:info];
            }
            else{NSLog(@"Not find numOfRopes tag"); return nil;}
            NSArray *rope = [[omnip objectAtIndex:0] elementsForName:@"rope"];
            if ([rope count] == [[ropesInfo objectAtIndex:0]floatValue]) {
                for(GDataXMLElement *traverse in rope){
                    NSArray *child = [traverse children];
                    for(GDataXMLElement *ctraverse in child){
                        NSNumber *info = [NSNumber numberWithFloat:ctraverse.stringValue.floatValue];
                        [ropesInfo addObject:info];
                    }
                }
            }else{NSLog(@"Number of ropes not match with numOfRopes"); return nil;}
        }else{NSLog(@"Not find ropes tag or wrong pattern"); return nil;}
        
        // Stars
        // Problem: What if all stars belong to special??
        omnip = [levelMember elementsForName:@"stars"];
        if ([omnip count]>0) {
            NSArray *specials = [[omnip objectAtIndex:0]elementsForName:@"special"];
            int numOfSpecial = [specials count];
            if ([specials count] > 0) {
                for(GDataXMLElement *special in specials){
                    NSArray *spec = [special children];
                    if ([spec count] == 4) {
                        for(GDataXMLElement *traverse in spec){
                            NSNumber *info = [NSNumber numberWithFloat:traverse.stringValue.floatValue];
                            [starInfo addObject:info];
                        }
                    }else{NSLog(@"Special has wrong pattern"); return nil;}
                }
            }
            if (numOfSpecial != 3) {
                NSArray *child = [[omnip objectAtIndex:0]children];
                if (child != nil && [child count] > 4) {
                    GDataXMLElement *traverse;
                    for(int i = 0; i < 8; ++i){
                        traverse = [child objectAtIndex:i];
                        NSNumber *info = [NSNumber numberWithFloat:traverse.stringValue.floatValue];
                        [starInfo addObject:info];
                    }
                }else{NSLog(@"star information has wrong pattern"); return nil;}
            }
        }else{NSLog(@"Not find stars tag or wrong pattern"); return nil;}
        
        // RopeResources
        omnip = [levelMember elementsForName:@"ropeResources"];
        if ([omnip count]>0) {
            ropeResourceInfo = [self extractInfo:omnip];
        }
        
        // Bubble
        omnip = [levelMember elementsForName:@"bubbles"];
        if ([omnip count] > 0) {
            NSArray *bubble = [[omnip objectAtIndex:0] elementsForName:@"bubble"];
            bubbleInfo = [self anotherExtract:bubble];
        }
        
        // Board
        omnip = [levelMember elementsForName:@"boards"];
        if ([omnip count]>0) {
            NSArray *board = [[omnip objectAtIndex:0] elementsForName:@"board"];
            boardInfo = [self anotherExtract:board];
        }
        
        // airGun
        omnip = [levelMember elementsForName:@"airGuns"];
        if ([omnip count]>0) {
            NSArray *airGun = [[omnip objectAtIndex:0] elementsForName:@"airGun"];
            airGunInfo = [self anotherExtract:airGun];
        }
        
        // dragonFly
        omnip = [levelMember elementsForName:@"dragonFlys"];
        if ([omnip count] > 0) {
            NSArray *dragonFly = [[omnip objectAtIndex:0] elementsForName:@"dragonFly"];
            dragonInfo = [self anotherExtract:dragonFly];
        }
        
        // enemy
        omnip = [levelMember elementsForName:@"enemies"];
        if ([omnip count] > 0) {
            NSArray *enemy = [[omnip objectAtIndex:0] elementsForName:@"enemy"];
            enemyInfo = [self anotherExtract:enemy];
        }
        
        // obstacle
        omnip = [levelMember elementsForName:@"obstacles"];
        if ([omnip count] > 0) {
            NSArray *obstacle = [[omnip objectAtIndex:0] elementsForName:@"obstacle"];
            obstInfo = [self anotherExtract:obstacle];
        }
        
        // pin
        omnip = [levelMember elementsForName:@"pins"];
        if ([omnip count] > 0) {
            NSArray *pins = [[omnip objectAtIndex:0] elementsForName:@"pin"];
            for(GDataXMLElement *traverse in pins){
                NSMutableArray *onePinInfo = [self extractPinInfo:[traverse children]];
                [pinInfo addObject:onePinInfo];
            }
        }
        
        readLevel *level = [[readLevel alloc]initWithLevel:levelNum dynamicGravity:dynamicGravity spriteLocation:spriteInfo bodyLocation:bodyInfo nutLocation:nutInfo factorOfRopes:ropesInfo starLocation:starInfo ropeReourceLocation:ropeResourceInfo bubble:bubbleInfo board:boardInfo airGun:airGunInfo dragonFly:dragonInfo enemy:enemyInfo obstacle:obstInfo pin:pinInfo];
        [alLevels.levels addObject:level];
    }
    [doc release];
    [xmlData release];
    return alLevels;
}
@end
