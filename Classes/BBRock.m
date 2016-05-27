#import "BBRock.h"
#import "BBCollider.h"

#pragma mark Rocks mesh
// the rocks are going to be randomly generated
// so we just need some basic info about them
static NSInteger BBRockVertexStride = 2;
static NSInteger BBRockColorStride = 4;
static NSInteger BBRockOutlineVertexesCount = 16;

@implementation BBRock

@synthesize smashCount;

- (id) init
{
	self = [super init];
	if (self != nil) {
		smashCount = 0;
	}
	return self;
}

+(BBRock*)randomRock
{
	return [BBRock randomRockWithScale:NSMakeRange(0.0,0.0)];
}

+(void)calcPos:(BBRock*)rock newObject:(BOOL)newObject
{
	NSRange scaleRange = NSMakeRange(1.0, 1.0);
	CGFloat scale = RANDOM_INT(scaleRange.location,NSMaxRange(scaleRange)); 
	rock.scale = BBPointMake(scale, scale, 1.0);
	
	CGFloat x = 0;
	{
		int xmax = DEVICE_HEIGHT;
		int xmax2= DEVICE_HEIGHT / 2;
		x = RANDOM_INT(0,xmax) - xmax2;
		//RANDOM_INT(100,230);	//iPhone
	}
	CGFloat y = (DEVICE_WIDTH/2.0);
	if(newObject)
	{
		int ymax = DEVICE_WIDTH;
		int ymax2= DEVICE_WIDTH / 2;
		y = RANDOM_INT(0,ymax) - ymax2;
		//y = DEVICE_WIDTH / 2;			//begin on top
	}
	
	rock.translation = BBPointMake(x, y, 0.0);
	// the rocks will be moving either up or down in the y axis
	CGFloat speed = -((RANDOM_INT(1,100)/50.0)+1.5);
	//NSInteger flipY = RANDOM_INT(1,10);
	//if (flipY <= 5) speed *= -1.0;
	
	CGFloat xspeed = 1;
	
	xspeed = ((((x+(DEVICE_HEIGHT/12.0))-(DEVICE_HEIGHT/12.0))*100.0)/(DEVICE_HEIGHT/12.0))/100.0;
	
	//NSLog(@"halfdev:%f x:%f, xspeed:%f",(DEVICE_HEIGHT/2.0),x,xspeed);
	
	rock.speed = BBPointMake(xspeed, speed, 0.0);
	
	CGFloat rotSpeed = 0.0;//RANDOM_INT(1,100)/200.0;
	//NSInteger flipRot = RANDOM_INT(1,10);
	//if (flipRot <= 5) rotSpeed *= -1.0;
	rock.rotation = BBPointMake(rock.speed.x*10.0, rock.speed.y, rock.speed.z);//rock.speed;//BBPointMake(xspeed, 0.0, 0.0);
	rock.rotationalSpeed = BBPointMake(0.0, 0.0, rotSpeed);	
}

+(BBRock*)randomRockWithScale:(NSRange)scaleRange
{
	BBRock* rock  = [[BBRock alloc] init];
	
	[BBRock calcPos:rock newObject:YES];
	
	return [rock autorelease];
}

-(void)awake
{
	{
		static NSInteger starVertexesCount = 6;
		NSInteger myVertexCount = starVertexesCount;
		static CGFloat starOutlineVertexes[12] = 
		{
			0.0,4.0,
			3.0,-2.0,
			-3.0,-2.0,
			-3.0,2.0,
			3.0,2.0,
			0.0,-4.0
		};
		verts  = starOutlineVertexes;
		colors = (CGFloat*) malloc(starVertexesCount * BBRockColorStride * sizeof(CGFloat));
		NSInteger vertexIndex = 0;
		for (vertexIndex = 0; vertexIndex < starVertexesCount; vertexIndex++)
		{
			NSInteger pos = vertexIndex * BBRockColorStride;
			colors[pos]   = 0.8;
			colors[pos+1] = 0.8;
			colors[pos+2] = 0.1;
			colors[pos+3] = 1.0;
		}
		
		// now alloc our mesh with our random verts
		mesh = [[BBMesh alloc] initWithVertexes:starOutlineVertexes 
									vertexCount:myVertexCount 
								   vertexStride:BBRockVertexStride
									renderStyle:GL_LINE_LOOP];
		
		mesh.colors = colors;
		mesh.colorStride = BBRockColorStride;
		mesh.renderStyle = GL_TRIANGLES;		
		self.collider = [BBCollider collider];
		return;		
	}
	
	{
		static NSInteger starVertexesCount = 10;
		NSInteger myVertexCount = starVertexesCount;
		static CGFloat starOutlineVertexes[20] = 
		{
			0.0,3.0,
			1.0,1.0,
			3.0,1.0,
			1.5,-0.5,
			3.0,-3.0,
			0.0,-1.5,
			-3.0,-3.0,
			-1.5,-0.5,
			-3.0,1.0,
			-1.0,1.0
		};
		verts  = starOutlineVertexes;
		colors = (CGFloat*) malloc(starVertexesCount * BBRockColorStride * sizeof(CGFloat));
		NSInteger vertexIndex = 0;
		for (vertexIndex = 0; vertexIndex < starVertexesCount; vertexIndex++)
		{
			NSInteger pos = vertexIndex * BBRockColorStride;
			colors[pos]   = 0.8;
			colors[pos+1] = 0.8;
			colors[pos+2] = 0.1;
			colors[pos+3] = 1.0;
		}
		
		// now alloc our mesh with our random verts
		mesh = [[BBMesh alloc] initWithVertexes:starOutlineVertexes 
									vertexCount:myVertexCount 
									vertexStride:BBRockVertexStride
									renderStyle:GL_LINE_LOOP];
		
		mesh.colors = colors;
		mesh.colorStride = BBRockColorStride;
		mesh.renderStyle = GL_TRIANGLE_STRIP;		
		self.collider = [BBCollider collider];
		return;
	}
	
	// pick a random number of vertexes, more than 8, less than the max count
	NSInteger myVertexCount = RANDOM_INT(8,BBRockOutlineVertexesCount);
	
	// malloc some memory for our vertexes and colors
	verts = (CGFloat *) malloc(myVertexCount * BBRockVertexStride * sizeof(CGFloat));
	colors = (CGFloat *) malloc(myVertexCount * BBRockColorStride * sizeof(CGFloat));
	
	// we need to use radians for our angle since we wil be using the trig functions
	CGFloat radians = 0.0;
	CGFloat radianIncrement = (2.0 * 3.14159) / (CGFloat)myVertexCount;

	// generate the vertexes
	NSInteger vertexIndex = 0;
	for (vertexIndex = 0; vertexIndex < myVertexCount; vertexIndex++) {
		NSInteger position = vertexIndex * BBRockVertexStride;
		// ranom radial adjustment
		CGFloat radiusAdjust = 0.25 - (RANDOM_INT(1,100)/100.0 * 0.5);
		// calculate the point on the circel, but vary the radius
		verts[position]		= cosf(radians) * (1.0 + radiusAdjust);
		verts[position + 1] = sinf(radians) * (1.0 + radiusAdjust);
		// move on to the next angle
		radians += radianIncrement;
	}
	
	// now the colors, just make it white for now, all 1's
	for (vertexIndex = 0; vertexIndex < myVertexCount * BBRockColorStride; vertexIndex++) {
		colors[vertexIndex] = 1.0;
	}
	
	// now alloc our mesh with our random verts
	mesh = [[BBMesh alloc] initWithVertexes:verts 
															vertexCount:myVertexCount 
															vertexStride:BBRockVertexStride
															renderStyle:GL_LINE_LOOP];
	
	mesh.colors = colors;
	mesh.colorStride = BBRockColorStride;
	
	self.collider = [BBCollider collider];
}

-(void)checkArenaBounds
{
	if ((translation.x > ((DEVICE_HEIGHT/2.0) + CGRectGetWidth(self.meshBounds)/2.0)) ||
		(translation.x < (-(DEVICE_HEIGHT/2.0) - CGRectGetWidth(self.meshBounds)/2.0)))
	{
		[BBRock calcPos:self newObject:NO];
		return;
	}
	if ((translation.y > ((DEVICE_WIDTH/2.0) + CGRectGetHeight(self.meshBounds)/2.0)) ||
		(translation.y < (-(DEVICE_WIDTH/2.0) - CGRectGetHeight(self.meshBounds)/2.0)))
	{
		[BBRock calcPos:self newObject:NO];
		return;
	}
	if (translation.x > ((DEVICE_HEIGHT/2.0) + CGRectGetWidth(self.meshBounds)/2.0))
	{
		translation.x -= DEVICE_HEIGHT + CGRectGetWidth(self.meshBounds);
	}
	if (translation.x < (-(DEVICE_HEIGHT/2.0) - CGRectGetWidth(self.meshBounds)/2.0))
	{
		translation.x += DEVICE_HEIGHT + CGRectGetWidth(self.meshBounds);
	}
	if (translation.y > ((DEVICE_WIDTH/2.0) + CGRectGetHeight(self.meshBounds)/2.0))
	{
		translation.y -= DEVICE_WIDTH + CGRectGetHeight(self.meshBounds);
	}
	if (translation.y < (-(DEVICE_WIDTH/2.0) - CGRectGetHeight(self.meshBounds)/2.0))
	{
		translation.y += DEVICE_WIDTH + CGRectGetHeight(self.meshBounds);
	}
}

-(void)smash
{
	smashCount++;
	// queue myself for removal
	[[BBSceneController sharedSceneController] removeObjectFromScene:self];

	// if we have already been smashed once, then that is it
	if (smashCount >= 2) return;
		
	// need to break ourself apart
	NSInteger smallRockScale = scale.x / 3.0;
	
	BBRock * newRock = [[BBRock alloc] init];
	newRock.scale = BBPointMake(smallRockScale, smallRockScale, 1.0); 
	// now we need to position it 
	BBPoint position = BBPointMake(0.0, 0.5, 0.0);
	newRock.translation = BBPointMatrixMultiply(position , matrix);
	newRock.speed = BBPointMake(speed.x + (position.x * SMASH_SPEED_FACTOR), speed.y + (position.y * SMASH_SPEED_FACTOR), 0.0);
	newRock.rotationalSpeed = rotationalSpeed;
	newRock.smashCount = smashCount;
	[[BBSceneController sharedSceneController] addObjectToScene:newRock];
	[newRock release];

	newRock = [[BBRock alloc] init];
	newRock.scale = BBPointMake(smallRockScale, smallRockScale, 1.0); 
	// now we need to position it 
	position = BBPointMake(0.35, -0.35, 0.0);
	newRock.translation = BBPointMatrixMultiply(position , matrix);
	newRock.speed = BBPointMake(speed.x + (position.x * SMASH_SPEED_FACTOR), speed.y + (position.y * SMASH_SPEED_FACTOR), 0.0);
	newRock.rotationalSpeed = rotationalSpeed;
	newRock.smashCount = smashCount;
	[[BBSceneController sharedSceneController] addObjectToScene:newRock];
	[newRock release];

	newRock = [[BBRock alloc] init];
	newRock.scale = BBPointMake(smallRockScale, smallRockScale, 1.0); 
	// now we need to position it 
	position = BBPointMake(-0.35, -0.35, 0.0);
	newRock.translation = BBPointMatrixMultiply(position , matrix);
	newRock.speed = BBPointMake(speed.x + (position.x * SMASH_SPEED_FACTOR), speed.y + (position.y * SMASH_SPEED_FACTOR), 0.0);
	newRock.rotationalSpeed = rotationalSpeed;
	newRock.smashCount = smashCount;
	[[BBSceneController sharedSceneController] addObjectToScene:newRock];
	[newRock release];
}

// called once every frame
-(void)update
{
	scale = BBPointMake(scale.x+=0.002, scale.y+=0.016, scale.z);	//bigger
	
	speed = BBPointMake(speed.x+(speed.x/200.0), speed.y+(speed.y/200.0), speed.z);	//faster
	
	[super update];
	//particleEmitter.translation = self.translation;
	//if (!smashed) return;
	//if ((particleEmitter.emitCounter <= 0) && (![particleEmitter activeParticles]))
	//{
	//	[[BBSceneController sharedSceneController] removeObjectFromScene:self];	
	//}
}

- (void) dealloc
{
	if (verts) free(verts);
	if (colors) free(colors);
	//if (particleEmitter != nil) [[BBSceneController sharedSceneController] removeObjectFromScene:particleEmitter];
	//[particleEmitter release];
	[super dealloc];
}

@end
