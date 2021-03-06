// Copyright (c) 2006,2013 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//


#import "zkSObject.h"

@interface ZKEnvelope : NSObject {
	NSMutableString 	*env;
	int					state;
}

- (void)start:(NSString *)primaryNamespceUri;
- (void)writeSessionHeader:(NSString *)sessionId;
- (void)writeCallOptionsHeader:(NSString *)callOptions;
- (void)writeMruHeader:(BOOL)updateMru;

- (void) moveToHeaders;
- (void) moveToBody;
- (void) startElement:(NSString *)elemName;
- (void) endElement:(NSString *)elemName;
- (void) writeText:(NSString *)text;
- (void) addElement:(NSString *)elemName elemValue:(id)elemValue;
- (void) addElement:(NSString *)elemName elemValue:(id)elemValue nillable:(BOOL)nillable optional:(BOOL)optional;
- (void) addNullElement:(NSString *)elemName;
- (void) addBoolElement:(NSString *)elemName elemValue:(BOOL)elemValue;
- (void) addIntElement:(NSString *)elemName elemValue:(NSInteger)elemValue;

- (NSString *)end;

- (void) addElementArray:(NSString *)elemName   elemValue:(NSArray *)elemValues;
- (void) addElementSObject:(NSString *)elemName elemValue:(ZKSObject *)sobject;
- (void) addElementString:(NSString *)elemName  elemValue:(NSString *)elemValue;

@end
