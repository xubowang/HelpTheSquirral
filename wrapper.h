//
//  wrapper.h
//  HelpTheSquirrel
//
//  Created by DejieMen on 7/26/14.
//
//

#import <Foundation/Foundation.h>
#import "Box2D/Dynamics/b2Body.h"
#import "cocos2d.h"


@interface wrapper : NSObject{
    b2Body *pinBody_;
}
-(id)initWithBody:(b2Body*)pinBody;
-(b2Body*)getBody;

@property (nonatomic, assign) b2Body *pinBody_;
@end
