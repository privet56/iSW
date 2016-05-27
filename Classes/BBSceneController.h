#import <Foundation/Foundation.h>
#import "OpenALSoundController.h"

@class BBInputViewController;
@class EAGLView;
@class BBSceneObject;
@class BBCollisionController;

@interface BBSceneController : NSObject <EWSoundCallbackDelegate> {
	NSMutableArray * sceneObjects;
	NSMutableArray * objectsToRemove;
	NSMutableArray * objectsToAdd;
	BBInputViewController * inputController;
	EAGLView * openGLView;
	BBCollisionController * collisionController;
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
	
	NSTimeInterval deltaTime;
	NSDate* levelStartDate;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval thisFrameStartTime;
}

@property (retain) BBInputViewController * inputController;
@property (retain) EAGLView * openGLView;

@property (retain) NSDate* levelStartDate;

@property NSTimeInterval animationInterval;
@property NSTimeInterval deltaTime;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (BBSceneController*)sharedSceneController;
- (void)dealloc;
- (void)loadScene;
- (void)startScene;
- (void)gameLoop;
- (void)renderScene;
- (void)setAnimationInterval:(NSTimeInterval)interval ;
- (void)setAnimationTimer:(NSTimer *)newTimer ;
- (void)startAnimation ;
- (void)stopAnimation ;
- (void)updateModel;
- (void)setupLighting;
- (void)generateRocks;
- (void)addObjectToScene:(BBSceneObject*)sceneObject;
- (void)removeObjectFromScene:(BBSceneObject*)sceneObject;
- (void)invokeLoadResources;
// For EWSoundCallbackDelegate
- (void) soundDidFinishPlaying:(NSNumber*)source_number;

@end
