#import "HpsUpaSaleBuilder.h"

@implementation HpsUpaSaleBuilder

- (id)initWithDevice: (HpsUpaDevice*)upaDevice{
    self = [super init];
    if (self != nil)
    {
        device = upaDevice;
    }
    return self;   
}

- (void) execute:(void(^)(HpsUpaResponse*, NSError*))responseBlock{

    [self validate];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    HpsUpaRequest* request = [[HpsUpaRequest alloc] init];
    request.message = @"MSG";
    request.data = [[HpsUpaCommandData alloc] init];
    request.data.command = UPA_MSG_ID_toString[ UPA_MSG_ID_SALE ];
    request.data.EcrId = self.ecrId;
    if (self.referenceNumber > 0) {
        request.data.requestId = [NSString stringWithFormat:@"%d", self.referenceNumber];
    } else {
        request.data.requestId = [NSString stringWithFormat:@"%d", [device generateNumber]];
    }
    request.data.data = [[HpsUpaData alloc] init];
    
    request.data.data.params = [[HpsUpaParams alloc] init];
    request.data.data.params.clerkId = self.clerkId;
    request.data.data.params.tokenRequest = self.requestMultiUseToken ? @"1" : @"0";
    request.data.data.params.tokenValue = self.token;
    
    request.data.data.transaction = [[HpsUpaTransaction alloc] init];
    
    NSDecimalNumber* baseAmount = self.amount;
    
    if (baseAmount != nil && self.gratuity != nil) {
        baseAmount = [baseAmount decimalNumberBySubtracting:self.gratuity];
    }
    
    if (baseAmount != nil && self.taxAmount != nil) {
        baseAmount = [baseAmount decimalNumberBySubtracting:self.taxAmount];
    }
    
    request.data.data.transaction.baseAmount = baseAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[baseAmount doubleValue]]] : nil;
    request.data.data.transaction.tipAmount =  self.gratuity != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.gratuity doubleValue]]] : nil;
    request.data.data.transaction.taxAmount =  self.taxAmount != nil ? [formatter stringFromNumber:[NSNumber numberWithDouble:[self.taxAmount doubleValue]]] : nil;
    
    if (self.details != nil) {
        request.data.data.transaction.invoiceNbr = self.details.invoiceNumber;
    }
    
    [device processTransactionWithRequest:request withResponseBlock:^(id<IHPSDeviceResponse> response, NSError * error) {
        if (error != nil) {
            responseBlock(nil, error);
            return;
        }
        
        responseBlock((HpsUpaResponse*)response, nil);
    }];
}

- (void) validate
{
    if (self.amount == nil || self.amount <= 0) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Amount is required." userInfo:nil];
    }
    int i = 0;
    if (self.token != nil && self.token.length > 0) i++;
    if (i > 1) {
        @throw [NSException exceptionWithName:@"HpsUpaException" reason:@"Only one payment method allowed." userInfo:nil];
    }
}

@end