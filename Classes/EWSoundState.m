#import "EWSoundState.h"

@implementation EWSoundState

@synthesize gainLevel;
@synthesize objectPosition;
@synthesize objectVelocity;

- (id) init
{
	self = [super init];
	if(nil != self)
	{
		gainLevel = 1.0f;
		objectPosition = BBPointMake(0.0, 0.0, 0.0);
		objectVelocity = BBPointMake(0.0, 0.0, 0.0);
	}
	return self;
}

- (void) applyState
{
	
}

- (void) update
{
	
}

@end
