#import "BBParticle.h"

@implementation BBParticle

@synthesize position,velocity,life,size;
@synthesize grow,decay;

-(void)update
{
	position.x += velocity.x;
	position.y += velocity.y;
	position.z += velocity.z;
	
	life -= decay;
	size += grow;
	if (size < 0.0) size = 0.0;
}
@end
