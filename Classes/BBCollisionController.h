#import "BBSceneObject.h"

@interface BBCollisionController : BBSceneObject {
	NSArray * sceneObjects;
	NSMutableArray * allColliders;
	NSMutableArray * collidersToCheck;
}

@property (retain) NSArray * sceneObjects;

- (void)awake;
- (void)handleCollisions;
- (void)render;
- (void)update;

// 4 methods

@end
