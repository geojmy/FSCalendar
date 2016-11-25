//
//  FSCalendarWeekdayView.m
//  FSCalendar
//
//  Created by dingwenchao on 03/11/2016.
//  Copyright © 2016 wenchaoios. All rights reserved.
//

#import "FSCalendarWeekdayView.h"
#import "FSCalendar.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarExtensions.h"

@interface FSCalendarWeekdayView()

- (void)commonInit;

@end

@implementation FSCalendarWeekdayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:contentView];
    _contentView = contentView;
    
    _weekdayLabels = [NSHashTable weakObjectsHashTable];
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.layer.cornerRadius = 2.0f;
        weekdayLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:weekdayLabel];
        [_weekdayLabels addObject:weekdayLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    CGFloat weekdayWidth = self.fs_width/self.weekdayLabels.count;
    UIEdgeInsets shapeLayerInsets = _calendar.appearance.fillShapeEdgeInsets;
    [self.weekdayLabels.allObjects enumerateObjectsUsingBlock:^(UILabel *weekdayLabel, NSUInteger index, BOOL *stop) {
        weekdayLabel.frame = CGRectMake(index*weekdayWidth + shapeLayerInsets.left, shapeLayerInsets.top, weekdayWidth - shapeLayerInsets.left - shapeLayerInsets.right, self.contentView.fs_height - shapeLayerInsets.top - shapeLayerInsets.bottom);
    }];
}

- (void)invalidateWeekdaySymbols
{
    BOOL useVeryShortWeekdaySymbols = (self.calendar.appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    NSArray *weekdaySymbols = useVeryShortWeekdaySymbols ? self.calendar.gregorian.veryShortStandaloneWeekdaySymbols : self.calendar.gregorian.shortStandaloneWeekdaySymbols;
    BOOL useDefaultWeekdayCase = (self.calendar.appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesDefaultCase;
    [self.weekdayLabels.allObjects enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        index += self.calendar.firstWeekday-1;
        index %= 7;
        NSString *text = useDefaultWeekdayCase ? weekdaySymbols[index] : [weekdaySymbols[index] uppercaseString];
        if (self.calendar.appearance.weekdayTextAlignment == NSTextAlignmentLeft) {
            label.text = [NSString stringWithFormat:@"  %@", text];
        } else {
            label.text = text;
        }
    }];
}

- (void)setCalendar:(FSCalendar *)calendar
{
    _calendar = calendar;
    [self invalidateWeekdaySymbols];
    for (UILabel *label in self.weekdayLabels) {
        label.font = self.calendar.appearance.preferredWeekdayFont;
        label.textColor = self.calendar.appearance.weekdayTextColor;
    }
}

@end
