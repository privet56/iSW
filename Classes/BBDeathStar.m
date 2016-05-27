#import "BBDeathStar.h"

static NSInteger BBSpaceShipDSColorStride = 4;

static CGFloat BBSpaceShipDSColorValues[20] = 
{
	1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0, 
	1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0
};

@implementation BBDeathStar

-(NSString*)getShipName
{
	return @"deathstar";
}

-(void)awake
{
	[super awake];
}

-(BOOL)mainShip
{
	return NO;
}

-(void)awake_scale
{
	self.scale = BBPointMake(250, 250, 1.0);
	mesh.radius = 9.45;	
}

-(BOOL)hasTail
{
	return YES;
}

-(void)setcolor4render
{
	mesh.colors = BBSpaceShipDSColorValues;
	mesh.colorStride = BBSpaceShipDSColorStride;
}

- (void)didCollideWith:(BBSceneObject*)sceneObject; 
{
	return;
}

@end
