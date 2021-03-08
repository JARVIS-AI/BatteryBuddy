#import <UIKit/UIKit.h>

UIImageView* batteryIconView;
UIImageView* batteryChargerView;
UIImageView* LSBatteryIconView;
UIImageView* LSBatteryChargerView;
BOOL isCharging = NO;

@interface _UIBatteryView : UIView
- (CGFloat)chargePercent;
- (void)refreshIcon;
- (void)updateIconColor;
@end

@interface CSBatteryFillView : UIView
@end