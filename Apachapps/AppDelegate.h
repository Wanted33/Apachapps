//
//  AppDelegate.h
//  Apachapps
//
//  Created by Quentin RUBINI on 04/03/2014.
//  Copyright (c) 2014 Quentin RUBINI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusItem;

-(IBAction)startApache:(id)sender;
-(IBAction)stopApache:(id)sender;
-(IBAction)restartApache:(id)sender;
- (IBAction)terminate:(id)sender;

@end
