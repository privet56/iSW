#import "BBTexturedQuad.h"

static CGFloat BBTexturedQuadVertexes[8] = {-0.5,-0.5, 0.5,-0.5, -0.5,0.5, 0.5,0.5};
static CGFloat BBTexturedQuadColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation BBTexturedQuad

@synthesize uvCoordinates,materialKey;

- (id) init
{
	self = [super initWithVertexes:BBTexturedQuadVertexes vertexCount:4 vertexStride:2 renderStyle:GL_TRIANGLE_STRIP];
	if (self != nil)
	{
		uvCoordinates = (CGFloat*) malloc(8 * sizeof(CGFloat));
		colors = BBTexturedQuadColorValues;
		colorStride = 4;
	}
	return self;
}

//called once every frame
-(void)render
{
	glVertexPointer(vertexStride, GL_FLOAT, 0, vertexes);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(colorStride, GL_FLOAT, 0, colors);	
	glEnableClientState(GL_COLOR_ARRAY);	
	
	if (materialKey != nil)
	{
		[[BBMaterialController sharedMaterialController] bindMaterial:materialKey];
		glEnableClientState(GL_TEXTURE_COORD_ARRAY); 
		glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
	} 
	//render
	glDrawArrays(renderStyle, 0, vertexCount);	
}

- (void) dealloc
{
	free(uvCoordinates);
	[super dealloc];
}

@end
