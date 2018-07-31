
#import "HpsViewController.h"
#import "hps.h"
#import "HpsHeartSipDevice.h"

@interface HpsViewController ()
{
    HpsTokenData *tokenResponse;
}
@property (weak, nonatomic) IBOutlet UILabel *tokenResultText;
@property (weak, nonatomic) IBOutlet UILabel *tokenChargeResult;

@end

@implementation HpsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getTokenTouched:(id)sender {
	[self checkSipInit];
//    HpsTokenService *service = [[HpsTokenService alloc] initWithPublicKey:@"pkapi_cert_P6dRqs1LzfWJ6HgGVZ"];
//    tokenResponse = nil;
//    [service getTokenWithCardNumber:@"4242424242424242"
//                                cvc:@"023"
//                           expMonth:@"3"
//                            expYear:@"2017"
//                   andResponseBlock:^(HpsTokenData *response) {
//                       
//                       //saved for the charge.  Normally the token value is sent back to your server and you run a charge on it from the server to the gateway.
//                       //The server would securely store your secret api keys to use on the charge.
//                       tokenResponse = response;
//                       self.tokenResultText.text = [NSString stringWithFormat:@"Token: %@", response.tokenValue];
//                       
//                   }];

}
- (HpsHeartSipDevice*) setupDevice
{
	HpsConnectionConfig *config = [[HpsConnectionConfig alloc] init];
	config.ipAddress = @"10.12.220.130";
	config.port = @"12345";
	config.connectionMode = HpsConnectionModes_TCP_IP;
	HpsHeartSipDevice * device = [[HpsHeartSipDevice alloc] initWithConfig:config];
	return device;
}

-(void)checkSipInit{
	HpsHeartSipDevice *device = [self setupDevice];

	[device initialize:^(id<IInitializeResponse> payload, NSError *error) {

		HpsHeartSipInitializeResponse *response = (HpsHeartSipInitializeResponse *)payload;

		NSLog(@"%@",[response toString]);

	}];
}

- (IBAction)chargeTokenTouched:(id)sender {
    if (tokenResponse != nil) {
        // Issue HTTP request to your backend service to charge/store obtained token
        self.tokenChargeResult.text = [NSString stringWithFormat:@"Transaction ID: %@",
                                      @"123456789" // get from backend service response
                                      ];
    }else{
        self.tokenChargeResult.text = @"No token to charge";
    }
}



@end
