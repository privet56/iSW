#import "BBMesh.h"
#import "BBMaterialController.h"

@interface BBTexturedMesh : BBMesh
{
	GLfloat * uvCoordinates;
	GLfloat * normals;
	NSString * materialKey;
}

@property (assign) GLfloat * uvCoordinates;
@property (assign) GLfloat * normals;
@property (retain) NSString * materialKey;

@end
