#import <UIKit/UIKit.h>

UIImageView* batteryIconView;
UIImageView* batteryChargerView;
UIImageView* LSBatteryIconView;
UIImageView* LSBatteryChargerView;
BOOL isCharging = NO;

@interface _UIBatteryView : UIView
- (CGFloat)chargePercent;
- (UIColor *)fillColor;
- (void)refreshIcon;
@end

@interface CSBatteryFillView : UIView
@end