#import "BBBoom.h"
#import "BBPoint.h"

@implementation BBBoom

-(void)awake
{
	[super awake];
	
	static NSInteger starVertexesCount = 6;
	static NSInteger BBRockColorStride = 4;
	NSInteger vertexIndex = 0;
	for (vertexIndex = 0; vertexIndex < starVertexesCount; vertexIndex++)
	{
		NSInteger pos = vertexIndex * BBRockColorStride;
		colors[pos]   = 0.8;
		colors[pos+1] = 0.1;
		colors[pos+2] = 0.1;
		colors[pos+3] = 1.0;
	}
	
	self.scale = BBPointMake(1.2, 1.2, 1.0);
}

-(void)update
{
	[super update];
	
	self.scale = BBPointMake(self.scale.x + 0.1, self.scale.y + 0.1, self.scale.z);

	if(self.scale.x > 9.9)
	{
		[[BBSceneController sharedSceneController] removeObjectFromScene:self];
	}
}

@end
