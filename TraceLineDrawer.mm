//
//  TraceLineDrawer.m
//  HelpTheSquirrel
//
//  Created by Student on 6/29/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "TraceLineDrawer.h"

@implementation TraceLineDrawer

- (TraceLineDrawer*)initTraceLineDrawer: (CCLayer*)layer{
    self = [super init];
    if(self){
        self->layer = layer;
        pointList.clear();
    }
    return self;
}

- (void *)clearPoint{
    pointList.clear();
}

- (void*)addLinePoint: (NSSet*)pTouches{
    UITouch *touch = [pTouches anyObject];
    CGSize s = [[CCDirector sharedDirector] winSize];
    CGPoint pt0 = [touch previousLocationInView:[touch view]];
    CGPoint pt1 = [touch locationInView:[touch view]];
    pt0.y = s.height - pt0.y;
    pt1.y = s.height - pt1.y;
    float distance = ccpDistance(pt0, pt1);
    if(distance > 1){
        int d = distance;
        float distanceX = pt1.x-pt0.x;
        float distanceY = pt1.y-pt0.y;
        for(int i=0;i<d;i++){
            float percent = i / distance;
            CGPoint newPoint = ccp(pt0.x + percent * distanceX, pt0.y + percent * distanceY);
            pointList.push_back(newPoint);
        }
    }
}

- (void*)drawTraceLine{
    int maxPoint = 500;
    while(pointList.size()>maxPoint){
        pointList.pop_front();
    }
    int maxLineWidth = 4;
    int minLintWidth = 1;
    int alphaMin = 10;
    int alphaMax = 100;
    int count = 0;
    
    for(std::list<CGPoint>::iterator i = pointList.begin(); i != pointList.end(); i++){
        float percent = count++ * 1.0 / pointList.size();
        float alpha = alphaMin + alphaMax * percent;
        float lineWidth = minLintWidth + maxLineWidth * percent;
        ccDrawColor4B(235, 237, 57, alpha);
        ccPointSize(lineWidth);
        ccDrawPoint(*i);
//        NSLog(@"already drawed");
    }
}
@end
