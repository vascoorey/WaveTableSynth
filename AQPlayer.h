//
//  AQPlayer.h
//  Thumbafon
//
//  Created by Chris Lavender on 4/7/10.
//  Copyright 2010 Gnarly Dog Music. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


#define kNumberBuffers 3
#define kNumberVoices 32

#define kSR 22050.
#define kAudioDataByteSize 1024 //used for buffer size
#define MAX_AMP	1.0 //used for limiter as well as base amp info

@interface AQPlayer : NSObject {

	AudioStreamBasicDescription		mDataFormat;
	AudioQueueRef					mQueue;
	AudioQueueBufferRef				mBuffers[kNumberBuffers];
	
	BOOL							isRunning;

}
@property BOOL isRunning;

- (void)newAQ;

- (OSStatus)start;
- (OSStatus)stop;
- (OSStatus)volumeLevel:(float)level;

- (void)fillAudioBuffer:(Float64*)buffer numFrames:(UInt32)numFrames;

@end