#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import "BBPoint.h"

@interface EWSoundState : NSObject
{
	ALfloat gainLevel;
	BBPoint objectPosition;
	BBPoint objectVelocity;
}

@property(nonatomic, assign) ALfloat gainLevel;
@property(nonatomic, assign) BBPoint objectPosition;
@property(nonatomic, assign) BBPoint objectVelocity;

// virtual functions which should be overridden by subclasses
- (void) applyState;
- (void) update;

@end
