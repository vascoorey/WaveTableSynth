//
//  Voice.m
//  Thumbafon
//
//  Created by Chris Lavender on 1/30/11.
//  Copyright 2011 Gnarly Dog Music. All rights reserved.
//

#import "Voice.h"
#import "AQPlayer.h"

@implementation Voice
@synthesize freq = _freq;

- (id)init
{
    self = [super init];
    if (self) {
        _maxNoteAmp = MAX_AMP / kNumberVoices;
    }
    return self;
}

- (void)on {
	_ampDelta = 1. / _attack;
}

- (void)on:(Float64)intensity
{
    intensity = (intensity > 1.0f) ? 1.0f : ((intensity < 0.0f) ? 0.0f : intensity);
    _ampDelta = intensity / _attack;
}

- (void)off {
	_ampDelta = -1. / _release;
}

-(Float64)getEnvelope {
	_amplitude += _ampDelta;
	//1.0 = 1 second)
	if (_amplitude >= 1.0) {
		_amplitude = _sustain;
		_ampDelta = 0.;
	}
	else if (_amplitude <= 0.0) {
		_amplitude = 0.; 
		_ampDelta = 0.;
	}
	return _amplitude;
}

+ (Float64) noteNumToFreq:(UInt8)noteNum {
	return pow(2., (Float64)(noteNum - 69) / 12.) * 440.;
}

- (void) setFreq:(double)val;{
	_freq = val;
	_deltaTheta = _freq / kSR;
}

-(void)getSamplesForFreq:(Float64*)buffer numFrames:(UInt32)numFrames {
	
	for (UInt32 i = 0; i < numFrames; ++i) {
		buffer[i] += _maxNoteAmp * [self getWaveTable:_theta] * [self getEnvelope];
		_theta += _deltaTheta;
    }
}

- (Float64)getWaveTable:(Float64)index {
	UInt32 i = index * kAudioDataByteSize;
	i %= kAudioDataByteSize;
	return _table[i];
}
@end
