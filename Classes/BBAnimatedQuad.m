#import "BBAnimatedQuad.h"
#import "BBSceneController.h"

@implementation BBAnimatedQuad

@synthesize speed,loops,didFinish;
- (id) init
{
	self = [super init];
	if (self != nil)
	{
		self.speed		= 12; // 12 fps
		self.loops		= NO;
		self.didFinish	= NO;
		elapsedTime		= 0.0;
	}
	return self;
}

-(void)addFrame:(BBTexturedQuad*)aQuad
{
	if (frameQuads == nil) frameQuads = [[NSMutableArray alloc] init];
	[frameQuads addObject:aQuad];
}

-(void)updateAnimation
{
	elapsedTime += [BBSceneController sharedSceneController].deltaTime;
	NSInteger frame  = abs((int)(elapsedTime/(99.0/speed)));
	if (loops) frame = frame % [frameQuads count];
//NSLog(@"frame:%d framescount:%d speed:%f 1/speed:%f elapsedtime:%f",frame,[frameQuads count],speed,(1.0/speed),elapsedTime);
	if (frame >= [frameQuads count])
	{
		didFinish = YES;
		return;
	}
	[self setFrame:[frameQuads objectAtIndex:frame]];
}

-(void)setFrame:(BBTexturedQuad*)quad
{
	self.uvCoordinates	= quad.uvCoordinates;
	self.materialKey	= quad.materialKey;
}

- (void) dealloc
{
	uvCoordinates = 0;
	[super dealloc];
}

@end
