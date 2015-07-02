//
//  UITableView+Helper.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UITableView (Helper)

-(void)registerNibForCellReuseIdentifier:(NSString *)identifier;
-(void)registerNibsForCellReuseIdentifiers:(NSArray *)identifiers;
-(void)cleanTableFooter;
-(void)removeSeparator;

@end
