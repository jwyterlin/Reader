//
//  GenericModel.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 7/1/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "GenericModel.h"

@implementation GenericModel

-(NSArray *)setupListWithJson:(NSArray *)list {
    
    if ( ! list )
        return nil;
    
    NSMutableArray *listResult;
    
    if ( list.count > 0 ) {
        
        if ( [list[0] isKindOfClass:[NSDictionary class]] ) {
            
            listResult = [NSMutableArray new];
            
            for ( NSDictionary *obj in list ) {
                
                id objCreated = [self setupWithJson:obj];
                [listResult addObject:objCreated];
                
            }
            
        }
        
    }
    
    return listResult;
    
}

-(id)setupWithJson:(NSDictionary *)json {
    return self;
}

-(NSString *)receiveString:(NSString *)string {

    if ( [Validator isEmptyString:string] )
        return @"";
    else
        return string;

}

-(NSDate *)receiveDate:(NSString *)string {
    
    if ( [Validator isEmptyString:string] )
        return nil;
    else
        return [DateHelper dateFromString:string];
    
}

-(NSArray *)allWithEntityName:(NSString *)entityName {
    
    NSManagedObjectContext *context = [[Database sharedInstance] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
}

-(id)entityByIdentifier:(NSNumber *)identifier entityName:(NSString *)entityName {
    
    if ( ! identifier )
        return nil;
    
    if ( [Validator isEmptyString:entityName] )
        return nil;
    
    NSString *__identifier = [identifier stringValue];
    
    NSManagedObjectContext *context = [[Database sharedInstance] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", __identifier];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ( fetchedObjects.count )
        return fetchedObjects[0];
    else
        return nil;
    
}

-(void)setFieldsfromSource:(id)source toDestination:(id)destination class:(Class)class {
    
    @autoreleasepool {
        
        unsigned int numberOfProperties = 0;
        
        objc_property_t *propertyArray = class_copyPropertyList(class, &numberOfProperties);
        
        for ( NSUInteger i = 0; i < numberOfProperties; i++ ) {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName( property )];
            [destination setValue:[source valueForKey:name] forKey:name];
        }
        
        free( propertyArray );
        
    }
    
}

-(id)toEntityWithEntityName:(NSString *)entityName identifier:(NSNumber *)identifier {
    
    id entity = [self entityByIdentifier:identifier entityName:entityName];
    
    if ( entity == nil ) {
        
        NSManagedObjectContext *context = [[Database sharedInstance] managedObjectContext];
        entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        
    }
    
    // Attributes
    [self setFieldsfromSource:self toDestination:entity class:[self class]];
    
    return entity;
    
}

-(NSArray *)allEntitiesWithEntityName:(NSString *)entityName {
    
    if ( ! entityName )
        return nil;
    
    NSManagedObjectContext *context = [[Database sharedInstance] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
}

-(NSNumber *)lastIDWithEntityName:(NSString *)entityName {
    NSArray *all = [self allEntitiesWithEntityName:entityName];
    return [NSNumber numberWithInt:(int)all.count];
}

-(NSNumber *)nextIDWithEntityName:(NSString *)entityName {
    NSNumber *lastID = [self lastIDWithEntityName:entityName];
    NSNumber *nextID = [NSNumber numberWithInt:[lastID intValue]+1];
    return nextID;
}

@end
