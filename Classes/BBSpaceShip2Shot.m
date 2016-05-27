#import "BBSpaceShip2Shot.h"

static NSInteger BBSpaceShip2ShotColorStride = 4;

static CGFloat BBSpaceShip2ShotColorValues[20] = 
{
	0.9,0.1,0.1,1.0,
	0.9,0.1,0.1,1.0, 
	0.9,0.1,0.1,1.0,
	0.9,0.1,0.1,1.0,
	0.9,0.1,0.1,1.0
};

@implementation BBSpaceShip2Shot

-(NSString*)getShipName
{
	return @"ship";
}

-(void)awake
{
	[super awake];
	mesh.colors = BBSpaceShip2ShotColorValues;
}

-(void)awake_scale
{
	[super awake_scale];
	
	CGFloat s = BBRandomFloat(BBRangeMake(32.0, 42.5));
	
	self.scale = BBPointMake(s, s, 1.0);
	//mesh.radius = 0.45;
}

-(BOOL)mainShip
{
	return NO;
}

-(BOOL)hasTail
{
	return YES;
}

-(void)setcolor4render
{
	mesh.colors = BBSpaceShip2ShotColorValues;
	mesh.colorStride = BBSpaceShip2ShotColorStride;	
}

-(void)render
{
	//[self setcolor4render];
	[super render];
}

-(void)update
{
	[super update];
}

@end
