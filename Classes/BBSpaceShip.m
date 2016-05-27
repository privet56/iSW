#import "BBSpaceShip.h"
#import "BBMissile.h"
#import "BBRock.h"
#import "BBCollider.h"
#import "BBBoom.h"
#import "BBAnimation.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BBParticleSystem.h"
#import "EWSoundListenerObject.h"

#pragma mark Space Ship

static CGFloat BBSpaceShipCollisionVertexes[12] = {0.0,0.4,0.0,-0.4,-0.3,0.05,0.3,0.05,-0.45,-0.35,0.45,-0.35};
static CGFloat BBSpaceShipCollisionVertCount = 6;

static NSInteger BBSpaceShipVertexStride= 2;
static NSInteger BBSpaceShipColorStride = 4;

static NSInteger BBSpaceShipOutlineVertexesCount = 5;
static CGFloat BBSpaceShipOutlineVertexes[10] = 
{
	0.0, 4.0,    3.0, -4.0,
	1.0, -2.0,   -1.0, -2.0,
	-3.0, -4.0
};

static CGFloat BBSpaceShipColorValues[20] = 
{
	0.9,0.0,0.9,1.0,
	0.7,0.0,0.9,1.0, 
	0.5,0.0,0.9,1.0,
	0.2,0.0,0.9,1.0,
	0.1,0.0,0.9,1.0
};

@interface BBSpaceShip ()
@property(nonatomic, retain) EWSoundListenerObject* soundListenerObject;
@end

@implementation BBSpaceShip

@synthesize soundListenerObject;

+ (void) loadResources
{
	//[[OpenALSoundController sharedSoundController] soundBufferDataFromFileBaseName:EXPLOSION3];
}

-(NSString*)getShipName
{
	return @"falcon";
}

-(void)awake_scale
{
	self.scale = BBPointMake(40, 40, 1.0);
	mesh.radius = 0.45;	
}

// called once when the object is first created.
-(void)awake
{
	self.mesh = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:[self getShipName]];
	[self awake_scale];
	//mesh.colors = BBSpaceShipColorValues;
	//mesh.colorStride = BBSpaceShipColorStride;
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];

	dead = NO;

	if([self hasTail])
	{
		particleEmitter = [[BBParticleSystem alloc] init];
		particleEmitter.emissionRange = BBRangeMake(4.0, 1.0);
		particleEmitter.sizeRange = BBRangeMake(8.0, 1.0);
		particleEmitter.growRange = BBRangeMake(-0.8, 0.5);
		xVeloRange = BBRangeMake(-0.5, 1.0);
		yVeloRange = BBRangeMake(-0.5, 1.0);
		particleEmitter.xVelocityRange = xVeloRange;
		particleEmitter.yVelocityRange = yVeloRange;
		particleEmitter.lifeRange = BBRangeMake(0.0, 2.5);
		particleEmitter.decayRange = BBRangeMake(0.03, 0.05);
		if([self mainShip])
			[particleEmitter setParticle:@"greenBlur"];
		else
			[particleEmitter setParticle:@"redBlur"];
		particleEmitter.emit = YES;
		particleEmitter.emitCounter = -1;
		[[BBSceneController sharedSceneController] addObjectToScene:particleEmitter];
		
		particleEmitter.translation    = BBPointMatrixMultiply(BBPointMake(0.0, -0.4, 0.0), matrix);
	}
	
//	particleEmitter.emitCounter = 4;
	
//	secondaryColliders = [[NSMutableArray alloc] init];
//	BBCollider * secondaryCollider1 = [BBCollider collider];
//	secondaryCollider1
	explosionDidEnd = NO;
	self.soundSourceObject.audioLooping = AL_TRUE;
	
	soundListenerObject	= [[EWSoundListenerObject alloc] init];
//	soundListenerObject.gainLevel = 1.0;  // Change this value if you want to play with the listener volume
	soundListenerObject.objectPosition = translation;
	CGFloat radians = rotation.z/BBRADIANS_TO_DEGREES;
	self.soundListenerObject.atOrientation = BBPointMake(-sinf(radians), cosf(radians), 0.0);

}

-(void)fireMissile
{
	static int __i=0;
	if(((__i++) % 10) != 0)
		return;
	
	{
		NSURL* u = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"laser1" ofType:@"wav"]];
		static SystemSoundID sid=0;
		if(sid == 0)AudioServicesCreateSystemSoundID((CFURLRef)u,&sid);
		AudioServicesPlaySystemSound(sid);
	}
	
	for(int i=0; i<2;i++)
	{
		// need to spawn a missile
		BBMissile* missile = [[BBMissile alloc] init];
		missile.scale = BBPointMake(5.0, 5.0, 1.0);
		// we need to position it at the tip of our ship
		CGFloat radians= rotation.z/BBRADIANS_TO_DEGREES;
		CGFloat speedX = -sinf(radians)* 9.0;
		CGFloat speedY = cosf(radians) * 9.0;

		missile.speed = BBPointMake(speedX, speedY, 0.0);
		
		if(i==0)
			missile.translation = BBPointMake((translation.x + missile.speed.x * 3.0)-5.0, (translation.y + missile.speed.y * 3.0)-5.0, 0.0);
		else
			missile.translation = BBPointMake((translation.x + missile.speed.x * 3.0)+5.0, (translation.y + missile.speed.y * 3.0)+5.0, 0.0);
		
		missile.rotation = BBPointMake(0.0, 0.0, self.rotation.z);

		[[BBSceneController sharedSceneController] addObjectToScene:missile];
		[missile release];
	}
	
	[[BBSceneController sharedSceneController].inputController setFireMissile:NO];
}

-(void)setcolor4render
{
	mesh.colors = BBSpaceShipColorValues;
	mesh.colorStride = BBSpaceShipColorStride;
}

-(BOOL)hasTail
{
	return YES;
}

-(void)render
{
	[self setcolor4render];
	[super render];
}

// called once every frame
-(void)update
{
	[super update];
	
	if (dead)
	{
		[self deadUpdate];
		return;		
	}

	CGFloat radians = rotation.z/BBRADIANS_TO_DEGREES;
	if([self hasTail])
	{
		CGFloat speedX = sinf(radians);
		CGFloat speedY = -cosf(radians);
		if([self mainShip])
			particleEmitter.translation    = BBPointMatrixMultiply(BBPointMake(0.1, -0.4, 0.0), matrix);
		else
		{
			particleEmitter.translation    = BBPointMatrixMultiply(BBPointMake(-0.15, 0.1, 0.0), matrix);	
		}

		particleEmitter.xVelocityRange = BBRangeMake(speedX * 2 , speedX * 2);
		particleEmitter.yVelocityRange = BBRangeMake(speedY * 2 , speedY * 2);		
	}
	
	if(![self mainShip])
	{
		return;
	}	

#define MOVE_FALCON 1
	
#ifdef MOVE_FALCON
	int iTURN		= 0;
	int iTURN_RIGHT	= 1;
	int iTURN_LEFT	= 2;
	if([[BBSceneController sharedSceneController].inputController rightMagnitude] > 0.6)
		iTURN = iTURN_RIGHT;
	else if([[BBSceneController sharedSceneController].inputController leftMagnitude] > 0.6)
		iTURN = iTURN_LEFT;
	if (iTURN ==iTURN_LEFT)
		translation.x -= 2.0;
	if (iTURN ==iTURN_RIGHT)
		translation.x += 2.0;
	
	CGFloat rightTurn = 0.0;
	CGFloat leftTurn  = 0.0;
	
	if(abs([[BBSceneController sharedSceneController].inputController m_acceleration_y]) > 0.2)
	{
		if([[BBSceneController sharedSceneController].inputController m_acceleration_y] > 0.2)
		{
			translation.x -= [[BBSceneController sharedSceneController].inputController m_acceleration_y]*1.5;
		}
		if([[BBSceneController sharedSceneController].inputController m_acceleration_y] < -0.2)
		{
			translation.x -= [[BBSceneController sharedSceneController].inputController m_acceleration_y]*1.5;
		}		
	}
	
#else
	CGFloat rightTurn = [[BBSceneController sharedSceneController].inputController rightMagnitude];
	CGFloat leftTurn  = [[BBSceneController sharedSceneController].inputController leftMagnitude];
#endif
	
	rotation.z += ((rightTurn * -1.0) + leftTurn) * TURN_SPEED_FACTOR;
	
	if ([[BBSceneController sharedSceneController].inputController fireMissile]) [self fireMissile];
	
	CGFloat forwardMag = [[BBSceneController sharedSceneController].inputController forwardMagnitude] * THRUST_SPEED_FACTOR;
	//particleEmitter.emissionRange = BBRangeMake([[BBSceneController sharedSceneController].inputController forwardMagnitude] * 5, [[BBSceneController sharedSceneController].inputController forwardMagnitude] * 5);

	self.soundListenerObject.objectPosition = translation;
	self.soundListenerObject.atOrientation = BBPointMake(-sinf(radians), cosf(radians), 0.0);
	[self.soundListenerObject update];

	if (forwardMag <= 0.0001) return; // we are not moving so return early
	
	
	// now we need to do the thrusters
	// figure out the components of the speed
	speed.x += sinf(radians) * -forwardMag;
	speed.y += cosf(radians) * forwardMag;
}

-(void)deadUpdate
{
	if ((particleEmitter.emitCounter <= 0) && (![particleEmitter activeParticles]))
    {
		self.active = NO;
	}

	[(BBAnimatedQuad*)mesh updateAnimation];
	if ([(BBAnimatedQuad*)mesh didFinish])
	{

		[[BBSceneController sharedSceneController] removeObjectFromScene:self];	
		//TODO
		//[[BBSceneController sharedSceneController] gameOver];
	}
}

- (void)didCollideWith:(BBSceneObject*)sceneObject; 
{
	{
		if([self mainShip])
			return;
		if (![sceneObject isKindOfClass:[BBMissile class]]) return;
		[[BBSceneController sharedSceneController] removeObjectFromScene:self];
		[[BBSceneController sharedSceneController] removeObjectFromScene:sceneObject];
		
		{
			dead = YES;
			
			//BBAnimation* boom = [[BBAnimation alloc] initWithAtlasKeys:[NSArray arrayWithObjects:@"bang1",@"bang2",@"bang3",nil] loops:NO speed:1];
			BBAnimation* boom = [[BBAnimation alloc] initWithAtlasKeys:[NSArray arrayWithObjects:@"shipDestroy1",@"shipDestroy2",@"shipDestroy3",@"shipDestroy4",nil] loops:NO speed:1];
			boom.active = YES;
			boom.translation = self.translation;
			boom.scale = self.scale;
			[[BBSceneController sharedSceneController] addObjectToScene:boom];
			[boom release];
			
			{
				NSURL* u = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"explosion2" ofType:@"wav"]];
				static SystemSoundID sid=0;
				if(sid == 0)AudioServicesCreateSystemSoundID((CFURLRef)u,&sid);
				AudioServicesPlaySystemSound(sid);
			}
			
			return;
		}
		{
			BBBoom* boom = [[BBBoom alloc] init];
			boom.rotationalSpeed = BBPointMake(0.0, 0.0, 99.9);
			boom.translation= BBPointMake(self.translation.x, self.translation.y, self.translation.z);
			boom.rotation	= BBPointMake(0.0, 0.0, 1.0);
			boom.speed		= BBPointMake(0.9, -0.9, 0.0);
			
			[[BBSceneController sharedSceneController] addObjectToScene:boom];
			//[boom release];			
		}
		
		return;
	}
	
	// if we did not hit a rock, then get out early
	if (![sceneObject isKindOfClass:[BBRock class]]) return;
	// OK, we really want to make sure that we were hit.
	// so we are going to do a secondary check to make sure one of our vertexes is inside the
	// collision radius of the rock

//below better	
	if (![sceneObject.collider doesCollideWithMesh:self]) return;
	
	//if (![sceneObject.collider doesCollideWithVertexes:BBSpaceShipCollisionVertexes	count:BBSpaceShipCollisionVertCount size:2 matrix:[self matrix]])
	//	return;
	
	// we did hit a rock! smash it!
	[(BBRock*)sceneObject smash];
	// now destroy ourself
	
	// we are dead! bummer
	dead = YES;
	
	self.mesh = [[BBMaterialController sharedMaterialController] animationFromAtlasKeys:[NSArray arrayWithObjects:@"shipDestroy1",@"shipDestroy2",@"shipDestroy3",@"shipDestroy4",nil]];
	self.collider.checkForCollision = NO;
	[(BBAnimatedQuad*)mesh setSpeed:6];
	
	//[[BBSceneController sharedSceneController] removeObjectFromScene:self];	
}

-(BOOL)mainShip
{
	return YES;
}

- (void) dealloc
{
	if (particleEmitter != nil) [[BBSceneController sharedSceneController] removeObjectFromScene:particleEmitter];
	[particleEmitter release];

	[soundListenerObject release];
	[super dealloc];
}

- (void) soundDidFinishPlaying:(NSNumber*)source_number
{
	[super soundDidFinishPlaying:source_number];

	if([source_number unsignedIntValue] == explosionID)
	{
		explosionDidEnd = YES;
	}



























}


@end
