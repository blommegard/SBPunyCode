//
//  SBPunyCode.m
//  LoopiaDNS
//
//  Created by Simon Blommegård and Tomas Franzén on 2010-03-03.
//

#import "SBPunyCode.h"
#import <punycode.h>

@implementation NSString (SBPunyCode)

- (NSString *)stringFromIDN {
	NSArray *domainParts = [self componentsSeparatedByString:@"."];
	NSMutableString *result = [NSMutableString string];
	
	for(NSString *part in domainParts) {
		if([result length]) [result appendString:@"."];
		if([part hasPrefix:@"xn--"]) {
			part = [part substringFromIndex:4];
			const char *string = [part cStringUsingEncoding:NSASCIIStringEncoding];
			punycode_uint output[[part length]];
			size_t outputLength = [part length];
			Punycode_status s;
			if((s = punycode_decode([part length], string, &outputLength, output, NULL)) == PUNYCODE_SUCCESS) {
				for(int i=0; i<outputLength; i++) {
					unichar c = output[i];
					[result appendString:[NSString stringWithCharacters:&c length:1]];
				}
			} else {
				return self;
			}
		} else {
			[result appendString:part];
		}
	}
	
	return result;
}

- (NSString *)stringToIDN {
	NSArray *domainParts = [self componentsSeparatedByString:@"."];
	NSMutableString *result = [NSMutableString string];
	
	NSCharacterSet *validHostnameChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"];
	
	for(NSString *part in domainParts) {
		if([result length]) [result appendString:@"."];
		if([[part stringByTrimmingCharactersInSet:validHostnameChars] length] != 0) {
			punycode_uint codepoints[[part length]];
			char output[[part length]*4];
			size_t outputLength = [part length]*4;
			Punycode_status s;
			for(int i=0; i<[part length]; i++)
				codepoints[i] = [part characterAtIndex:i];
			if((s = punycode_encode([part length],codepoints,NULL,&outputLength,output)) == PUNYCODE_SUCCESS) {
				NSString *partResult = [@"xn--" stringByAppendingString:[[[NSString alloc] initWithBytes:output length:outputLength encoding:NSUTF8StringEncoding] autorelease]];
				[result appendString:partResult];
			} else {
				return self;
			}
		} else {
			[result appendString:part];
		}
	}

	return result;
}

@end
