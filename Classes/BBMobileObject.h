#import "BBSceneObject.h"

@interface BBMobileObject : BBSceneObject
{
	BBPoint speed;
	BBPoint rotationalSpeed;
}

@property (assign) BBPoint speed;
@property (assign) BBPoint rotationalSpeed;

- (void)checkArenaBounds;
- (void)update;

// 2 methods


@end
