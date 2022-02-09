//
//  FileInfo.h
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileInformation : NSObject {
    
}

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSImage *icon;
@property (strong, nonatomic) NSDate *modified_date;
@property (nonatomic) bool isreadable;
@property (nonatomic) bool isWritable;
- (instancetype) initWithURL:(NSString *)url Name: (NSString *)name type: (NSString *)type size: (NSString *)size;

@end

NS_ASSUME_NONNULL_END
