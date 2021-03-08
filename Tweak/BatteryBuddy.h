#import <UIKit/UIKit.h>

UIImageView* batteryIconView;
UIImageView* batteryChargerView;
UIImageView* LSBatteryIconView;
UIImageView* LSBatteryChargerView;
BOOL isCharging = NO;
BOOL lightStatusBar = YES;

@interface _UIBatteryView : UIView
- (CGFloat)chargePercent;
- (UIColor *)bodyColor;
- (void)refreshIcon;
- (void)updateIconColor;
@end

@interface CSBatteryFillView : UIView
@end