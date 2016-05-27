#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "BBMesh.h"
#import "BBPoint.h"
#import "BBSceneController.h";
#import "BBInputViewController.h";
#import "BBMaterialController.h";
#import "BBTexturedQuad.h"
#import "BBPoint.h";
#import "BBConfiguration.h";
#import "BBAnimatedQuad.h"
#import "OpenALSoundController.h"
#import "EWSoundSourceObject.h"


@class BBCollider;

@interface BBSceneObject : NSObject
{
	// transform values
	BBPoint translation;
	BBPoint rotation;
	BBPoint scale;

	BOOL active;

	BBMesh * mesh;

	CGFloat* matrix;

	CGRect meshBounds;

	BBCollider * collider;
	EWSoundSourceObject* soundSourceObject;
}

@property (assign) CGRect meshBounds;
@property (retain) BBMesh * mesh;
@property (retain) BBCollider * collider;
@property (assign) CGFloat * matrix;

@property (assign) BBPoint translation;
@property (assign) BBPoint rotation;
@property (assign) BBPoint scale;

@property (assign) BOOL active;

@property (retain) EWSoundSourceObject* soundSourceObject;
- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;

- (void) soundDidFinishPlaying:(NSNumber*)source_number;


@end
