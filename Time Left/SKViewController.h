//
//  SKViewController.h
//  Time Left
//
//  Created by Salavat Khanov on 7/22/13.
//  Copyright (c) 2013 Salavat Khanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"

@interface SKViewController : UIViewController

@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;



@end
