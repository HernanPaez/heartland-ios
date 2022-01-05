#import <Foundation/Foundation.h>
#import "HpsUpaResponse.h"
#import "HpsUpaDevice.h"
#import "HpsTransactionDetails.h"

@interface HpsUpaCaptureBuilder : NSObject
{
    HpsUpaDevice *device;
}

@property (nonatomic, readwrite) int referenceNumber;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, readwrite) BOOL requestMultiUseToken;
@property (nonatomic, strong) HpsTransactionDetails *details;
@property (nonatomic, strong) NSDecimalNumber *gratuity;
@property (nonatomic, strong) NSString *ecrId;
@property (nonatomic, strong) NSString *clerkId;
@property (nonatomic, strong) NSDecimalNumber *taxAmount;
@property (nonatomic, strong) NSString *issuerRefNumber;

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock;
- (id)initWithDevice: (HpsUpaDevice*)upaDevice;

@end