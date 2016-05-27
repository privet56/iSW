#import "BBMesh.h"
#import "BBMaterialController.h"

@interface BBTexturedQuad : BBMesh
{
	GLfloat* uvCoordinates;
	NSString* materialKey;
}

@property (assign) GLfloat* uvCoordinates;
@property (retain) NSString* materialKey;

@end
