//
//  SKInfoViewController.m
//  Time Left
//
//  Created by Salavat Khanov on 1/24/14.
//  Copyright (c) 2014 Salavat Khanov. All rights reserved.
//

#import "SKInfoViewController.h"
#import "SKAppDelegate.h"

@interface SKInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SKInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupColors];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupColors
{
    SKAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSDictionary *colors = [delegate currentTheme];
    self.view.backgroundColor = [colors objectForKey:@"background"];
    self.textView.backgroundColor = [colors objectForKey:@"background"];
    self.textView.textColor = [colors objectForKey:@"colorText"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
