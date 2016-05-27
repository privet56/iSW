#import "BBMobileObject.h"

@implementation BBMobileObject

@synthesize speed,rotationalSpeed;

- (void) awake
{
	[super awake];
	soundSourceObject.objectVelocity = speed;
}

// called once every frame, sublcasses need to remember to call this
// method via [super update]
-(void)update
{
	translation.x += speed.x;
	translation.y += speed.y;
	translation.z += speed.z;
    rotation.x += rotationalSpeed.x;
	rotation.y += rotationalSpeed.y;
	rotation.z += rotationalSpeed.z;
/*	
	CGFloat deltaTime = [[BBSceneController sharedSceneController] deltaTime];
	translation.x += speed.x * deltaTime;
	translation.y += speed.y * deltaTime;
	translation.z += speed.z * deltaTime;
	
	rotation.x += rotationalSpeed.x * deltaTime;
	rotation.y += rotationalSpeed.y * deltaTime;
	rotation.z += rotationalSpeed.z * deltaTime;
*/
	soundSourceObject.objectVelocity = speed;

	[self checkArenaBounds];
	[super update];
}

-(void)checkArenaBounds
{
	if (translation.x > ((DEVICE_HEIGHT/2.0) + CGRectGetWidth(self.meshBounds)/2.0)) translation.x -= DEVICE_HEIGHT + CGRectGetWidth(self.meshBounds); 
	if (translation.x < (-(DEVICE_HEIGHT/2.0) - CGRectGetWidth(self.meshBounds)/2.0)) translation.x += DEVICE_HEIGHT + CGRectGetWidth(self.meshBounds); 
	
	if (translation.y > ((DEVICE_WIDTH/2.0) + CGRectGetHeight(self.meshBounds)/2.0)) translation.y -= DEVICE_WIDTH + CGRectGetHeight(self.meshBounds); 
	if (translation.y < (-(DEVICE_WIDTH/2.0) - CGRectGetHeight(self.meshBounds)/2.0)) translation.y += DEVICE_WIDTH + CGRectGetHeight(self.meshBounds); 
}

@end
