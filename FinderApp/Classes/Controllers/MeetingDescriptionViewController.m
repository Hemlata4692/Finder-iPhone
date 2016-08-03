//
//  MeetingDescriptionViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 24/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MeetingDescriptionViewController.h"

@interface MeetingDescriptionViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *meetingDescriptionView;
@property (weak, nonatomic) IBOutlet UIView *meetingDescriptionContainerView;
@property (weak, nonatomic) IBOutlet UILabel *meetingDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingAgendaLabel;
@property (strong, nonatomic) IBOutlet UILabel *titlelabel;
@property (strong, nonatomic) IBOutlet UILabel *venueDescription;
@property (strong, nonatomic) IBOutlet UILabel *venueLabel;
@property (strong, nonatomic) IBOutlet UILabel *separator;
@end

@implementation MeetingDescriptionViewController
@synthesize meetingDescriptionView;
@synthesize meetingDescriptionContainerView;
@synthesize meetingDescriptionLabel;
@synthesize meetingAgendaLabel;
@synthesize titlelabel;
@synthesize meetingDescription;
@synthesize meetingLocation;
@synthesize separator;
@synthesize venueLabel;
@synthesize venueDescription;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meetingDescriptionContainerView:)];
    tapGesture.delegate=self;
    [meetingDescriptionContainerView addGestureRecognizer:tapGesture];
    
    meetingLocation = @"my location";
    [self setMeetingDetail:meetingDescription locationText:meetingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
-(void)setMeetingDetail:(NSString *)descriptionText locationText:(NSString *)locationText {
    
    [meetingDescriptionView addShadow:meetingDescriptionView color:[UIColor lightGrayColor]];
    [meetingDescriptionView setCornerRadius:2.0f];
    meetingDescriptionView.translatesAutoresizingMaskIntoConstraints = YES;
    titlelabel.translatesAutoresizingMaskIntoConstraints = YES;
    meetingDescriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    separator.translatesAutoresizingMaskIntoConstraints = YES;
    venueLabel.translatesAutoresizingMaskIntoConstraints = YES;
    venueDescription.translatesAutoresizingMaskIntoConstraints = YES;
    meetingAgendaLabel.translatesAutoresizingMaskIntoConstraints = YES;
    
    meetingDescriptionView.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width/2-meetingDescriptionView.frame.size.width/2, self.view.frame.size.height/2-meetingDescriptionView.frame.size.height/2, meetingDescriptionView.frame.size.width, 180);
    titlelabel.frame = CGRectMake(0, 0, meetingDescriptionView.frame.size.width, 45);
    
    if ([descriptionText isEqualToString:@""]) {
        meetingDescriptionLabel.frame = CGRectMake(5, titlelabel.frame.origin.y + titlelabel.frame.size.height + 5, meetingDescriptionView.frame.size.width-5, 0);
        meetingDescriptionLabel.text = descriptionText;
        meetingDescriptionLabel.hidden = YES;
    }
    else {
        
         CGSize sizeValue = [self getDynamicLabelHeight:locationText font:[UIFont fontWithName:@"Roboto-Regular" size:14] widthValue:titlelabel.frame.size.width - 10 maxHeight:40.0];
        venueDescription.numberOfLines = 0;
        venueLabel.frame = CGRectMake(5, titlelabel.frame.size.height + 5, meetingDescriptionView.frame.size.width - 10, 25);
        venueDescription.frame = CGRectMake(5, venueLabel.frame.origin.y + venueLabel.frame.size.height, meetingDescriptionView.frame.size.width - 10, sizeValue.height);
        separator.frame = CGRectMake(0, venueDescription.frame.origin.y + venueDescription.frame.size.height + 5, meetingDescriptionView.frame.size.width, 1);
        
        sizeValue = [self getDynamicLabelHeight:descriptionText font:[UIFont fontWithName:@"Roboto-Regular" size:14] widthValue:titlelabel.frame.size.width maxHeight:180.0];
        meetingDescriptionLabel.numberOfLines = 0;
        meetingAgendaLabel.frame = CGRectMake(5, separator.frame.origin.y + separator.frame.size.height + 5, meetingDescriptionView.frame.size.width - 10, 25);
        meetingDescriptionLabel.frame = CGRectMake(5, meetingAgendaLabel.frame.origin.y + meetingAgendaLabel.frame.size.height, meetingDescriptionView.frame.size.width - 10, sizeValue.height);

        venueDescription.text = locationText;
        meetingDescriptionLabel.text = descriptionText;
        meetingDescriptionLabel.hidden = NO;
    }
    float alertViewHeight = meetingDescriptionLabel.frame.origin.y + meetingDescriptionLabel.frame.size.height + 10;
    meetingDescriptionView.frame = CGRectMake((self.view.frame.origin.x+self.view.frame.size.width/2-meetingDescriptionView.frame.size.width/2), (self.view.frame.size.height/2-alertViewHeight/2), meetingDescriptionView.frame.size.width, alertViewHeight);
}

#pragma mark - Get dynamic label height according to given string
- (CGSize)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue maxHeight:(float)maxHeight{
    
    CGSize size = CGSizeMake(widthValue,maxHeight);
    CGRect textRect=[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:font}
                     context:nil];
    return textRect.size;
}
#pragma mark - end

-(void) meetingDescriptionContainerView:(UITapGestureRecognizer *)sender {
      [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

@end
