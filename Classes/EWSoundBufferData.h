#import <Foundation/Foundation.h>
#import <OpenAL/al.h>

@interface EWSoundBufferData : NSObject
{
	ALuint openalDataBuffer;
	void* pcmDataBuffer;
	ALenum openalFormat;
	ALsizei dataSize;
	ALsizei sampleRate;
}

@property(nonatomic, assign, readonly) ALuint openalDataBuffer;

- (void) bindDataBuffer:(void*)pcm_data_buffer withFormat:(ALenum)al_format dataSize:(ALsizei)data_size sampleRate:(ALsizei)sample_rate;

@end

