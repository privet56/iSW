#import "BBMobileObject.h"
#import "BBParticleSystem.h"

@interface BBRock : BBMobileObject
{
	CGFloat * verts;
	CGFloat * colors;
	NSInteger smashCount;
	//BBParticleSystem * particleEmitter;
}

@property (assign) NSInteger smashCount;

+ (BBRock*)randomRock;
+ (BBRock*)randomRockWithScale:(NSRange)scaleRange;
- (id) init;
- (void) dealloc;
- (void)awake;
- (void)smash;
- (void)update;

// 7 methods


@end
