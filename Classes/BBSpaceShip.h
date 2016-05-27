#import "BBMobileObject.h"
#import "EWSoundListenerObject.h"
#import "BBParticleSystem.h"

@interface BBSpaceShip : BBMobileObject
{
	BOOL dead;
	EWSoundListenerObject* soundListenerObject;
	BBParticleSystem * particleEmitter;
	BBRange xVeloRange;
	BBRange yVeloRange;
	BOOL explosionDidEnd;
	NSUInteger explosionID;
}

- (void)awake;
- (void)deadUpdate;
- (void)didCollideWith:(BBSceneObject*)sceneObject;
- (void)fireMissile;
- (void)update;

-(NSString*)getShipName;
-(void)setcolor4render;
-(void)awake_scale;

-(BOOL)mainShip;
-(BOOL)hasTail;

@end
