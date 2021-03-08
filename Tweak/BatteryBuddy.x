#import "BatteryBuddy.h"

%group BatteryBuddy

%hook _UIBatteryView

- (BOOL)_shouldShowBolt { // hide charging bolt

	return NO;

}

- (UIColor *)fillColor { // get color and lower the opacity of the battery icon fill color

	return [%orig colorWithAlphaComponent:0.25];
	
}

- (CGFloat)chargePercent { // update face corresponding the battery percentage

	CGFloat orig = %orig;
	int actualPercentage = orig * 100;

	if (actualPercentage <= 20 && !isCharging)
		[batteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/sad.png"]];
	else if (actualPercentage <= 49 && !isCharging)
		[batteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/neutral.png"]];
	else if (actualPercentage > 49 && !isCharging)
		[batteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/happy.png"]];
	else if (isCharging)
		[batteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/happy.png"]];

	[self updateIconColor];

	return orig;

}

- (long long)chargingState { // refresh icons when charging state changed

	long long orig = %orig;

	if (orig == 1) isCharging = YES;
	else isCharging = NO;

	[self refreshIcon];
	[self updateIconColor];
	
	return orig;

}

- (void)_updateFillLayer { // add face & charger

	%orig;

	[self refreshIcon];

}

%new
- (void)refreshIcon { // refresh status bar icons
	
	// remove existing images
	batteryIconView = nil;
	batteryChargerView = nil;
	for (UIImageView* imageView in [self subviews])
		[imageView removeFromSuperview];

	// face
	if (!batteryIconView) {
		batteryIconView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[batteryIconView setContentMode:UIViewContentModeScaleAspectFill];
		[batteryIconView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		if (![batteryIconView isDescendantOfView:self]) [self addSubview:batteryIconView];
	}

	// charger
	if (!batteryChargerView && isCharging) {
		batteryChargerView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[batteryChargerView setContentMode:UIViewContentModeScaleAspectFill];
		[batteryChargerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[batteryChargerView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/charger.png"]];
		if (![batteryChargerView isDescendantOfView:self]) [self addSubview:batteryChargerView];
	}

	[self chargePercent];

}

%new
- (void)updateIconColor {

	batteryIconView.image = [batteryIconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	batteryChargerView.image = [batteryChargerView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[batteryIconView setTintColor:[UIColor labelColor]];
	[batteryChargerView setTintColor:[UIColor labelColor]];

}

%end

%hook CSBatteryFillView

- (void)didMoveToWindow { // add lockscreen battery icons

	%orig;

	[[self superview] setClipsToBounds:NO];

	// face
	if (!LSBatteryIconView) {
		LSBatteryIconView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[LSBatteryIconView setContentMode:UIViewContentModeScaleAspectFill];
		[LSBatteryIconView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[LSBatteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/happyLS.png"]];
	}
	LSBatteryIconView.image = [LSBatteryIconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[LSBatteryIconView setTintColor:[batteryIconView tintColor]];
	if (![LSBatteryIconView isDescendantOfView:self]) [[self superview] addSubview:LSBatteryIconView];

	// charger
	if (!LSBatteryChargerView) {
		LSBatteryChargerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x - 25, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
		[LSBatteryChargerView setContentMode:UIViewContentModeScaleAspectFill];
		[LSBatteryChargerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[LSBatteryChargerView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/chargerLS.png"]];
	}
	LSBatteryChargerView.image = [LSBatteryChargerView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[LSBatteryChargerView setTintColor:[batteryIconView tintColor]];
	if (![LSBatteryChargerView isDescendantOfView:self]) [[self superview] addSubview:LSBatteryChargerView];

}

%end

%end

%ctor {

	%init(BatteryBuddy);

}