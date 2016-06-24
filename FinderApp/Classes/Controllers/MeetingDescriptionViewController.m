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
@end

@implementation MeetingDescriptionViewController
@synthesize meetingDescriptionView;
@synthesize meetingDescriptionContainerView;
@synthesize meetingDescriptionLabel;
@synthesize meetingAgendaLabel;
@synthesize meetingDescription;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meetingDescriptionContainerView:)];
    tapGesture.delegate=self;
    [meetingDescriptionContainerView addGestureRecognizer:tapGesture];
    [self setMeetingDetail:meetingDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
-(void)setMeetingDetail:(NSString *)dscriptionText {
    NSString *messageText=dscriptionText;
    [meetingDescriptionView addShadow:meetingDescriptionView color:[UIColor lightGrayColor]];
    [meetingDescriptionView setCornerRadius:2.0f];
    meetingDescriptionView.translatesAutoresizingMaskIntoConstraints = YES;
    meetingAgendaLabel.translatesAutoresizingMaskIntoConstraints = YES;
    meetingDescriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    meetingDescriptionView.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width/2-meetingDescriptionView.frame.size.width/2, self.view.frame.size.height/2-meetingDescriptionView.frame.size.height/2, meetingDescriptionView.frame.size.width, 180);
    meetingAgendaLabel.frame = CGRectMake(0, 0, meetingDescriptionView.frame.size.width, 45);
    
    if ([messageText isEqualToString:@""]) {
        meetingDescriptionLabel.frame = CGRectMake(5, meetingAgendaLabel.frame.origin.y + meetingAgendaLabel.frame.size.height + 5, meetingDescriptionView.frame.size.width-5, 0);
        meetingDescriptionLabel.text = messageText;
        meetingDescriptionLabel.hidden = YES;
    }
    else {
        CGSize size = CGSizeMake(meetingAgendaLabel.frame.size.width,180);
        CGRect textRect = [messageText
                           boundingRectWithSize:size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
                           context:nil];
        meetingDescriptionLabel.numberOfLines = 0;
        
        if (textRect.size.height < 26) {
            textRect.size.height = 25;
        }
        meetingDescriptionLabel.frame = CGRectMake(5, meetingAgendaLabel.frame.origin.y + meetingAgendaLabel.frame.size.height + 5, meetingDescriptionView.frame.size.width-5, textRect.size.height);
        meetingDescriptionLabel.text = messageText;
        meetingDescriptionLabel.hidden = NO;
    }
    float alertViewHeight = meetingDescriptionLabel.frame.origin.y + meetingDescriptionLabel.frame.size.height + 10;
    meetingDescriptionView.frame = CGRectMake((self.view.frame.origin.x+self.view.frame.size.width/2-meetingDescriptionView.frame.size.width/2), (self.view.frame.size.height/2-meetingDescriptionView.frame.size.height/2), meetingDescriptionView.frame.size.width, alertViewHeight);
}
-(void) meetingDescriptionContainerView:(UITapGestureRecognizer *)sender {
      [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

@end
