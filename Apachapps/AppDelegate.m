//
//  AppDelegate.m
//  Apachapps
//
//  Created by Quentin RUBINI on 04/03/2014.
//  Copyright (c) 2014 Quentin RUBINI. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchAtLoginController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    
    //Get the result of command
    NSString *httpdOutput = runCommand(@"ps aux | grep httpd | wc -l");
    int httpDValue = [httpdOutput intValue];
    if (httpDValue > 2) {
        [self.statusItem setImage:[NSImage imageNamed:@"apache_on"]];
    }
    else {
        [self.statusItem setImage:[NSImage imageNamed:@"apache_off"]];
    }
    NSLog(@"%d | %@", httpDValue, httpdOutput);
    
    [self.statusItem setHighlightMode:YES];
    
    //Launch App at login
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:YES];
}

- (void)enableLoginItemWithURL:(NSURL *)itemURL
{
	LSSharedFileListRef loginListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
	if (loginListRef) {
		// Insert the item at the bottom of Login Items list.
		LSSharedFileListItemRef loginItemRef = LSSharedFileListInsertItemURL(loginListRef,
                                                                             kLSSharedFileListItemLast,
                                                                             NULL,
                                                                             NULL,
                                                                             (__bridge CFURLRef)itemURL, 
                                                                             NULL, 
                                                                             NULL);		
		if (loginItemRef) {
			CFRelease(loginItemRef);
		}
		CFRelease(loginListRef);
	}
}

-(IBAction)startApache:(id)sender
{
    NSDictionary *error = [NSDictionary dictionary];
    NSAppleScript *run = [[NSAppleScript alloc]initWithSource:@"do shell script \"/bin/bash apachectl start\" with administrator privileges"];
    [run executeAndReturnError:&error];
    
    [self.statusItem setImage:[NSImage imageNamed:@"apache_on"]];
    NSLog(@"Start");
}

-(IBAction)stopApache:(id)sender
{
    
    NSDictionary *error = [NSDictionary dictionary];
    NSAppleScript *run = [[NSAppleScript alloc]initWithSource:@"do shell script \"/bin/bash apachectl stop\" with administrator privileges"];
    [run executeAndReturnError:&error];

    [self.statusItem setImage:[NSImage imageNamed:@"apache_off"]];
    NSLog(@"Stop");
}

-(IBAction)restartApache:(id)sender
{
    
    [self.statusItem setImage:[NSImage imageNamed:@"apache_load"]];
    NSDictionary *error = [NSDictionary dictionary];
    NSAppleScript *run = [[NSAppleScript alloc]initWithSource:@"do shell script \"/bin/bash apachectl restart\" with administrator privileges"];
    [run executeAndReturnError:&error];
    
    [self.statusItem setImage:[NSImage imageNamed:@"apache_on"]];
    NSLog(@"Restart");
}

-(IBAction)terminate:(id)sender
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

NSString *runCommand(NSString *commandToRun)
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *output;
    output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}

@end
