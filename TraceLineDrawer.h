//
//  TraceLineDrawer.h
//  HelpTheSquirrel
//
//  Created by Student on 6/29/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import <list>

@interface TraceLineDrawer : NSObject {
    std::list<CGPoint> pointList;
    CCLayer* layer;
}

- (TraceLineDrawer*)initTraceLineDrawer: (CCLayer*) layer;
- (void*)addLinePoint: (NSSet*) pTouches;
- (void*)clearPoint;
- (void*)drawTraceLine;
@end
