//
//  ImageDAO.m
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "ImageDAO.h"

@implementation ImageDAO

-(void)imageByUrl:(NSString *)url completion:(void(^)(UIImage *image))completion {
    
    NSURL *imageURL = [NSURL URLWithString:url];
    
    runOnBackgroundQueue(^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (completion) {
            
            runOnMainQueueAsync(^{
                completion(image);
            });
            
        }
        
    });
    
}

-(void)defineImageById:(NSString *)identifier
            folderName:(NSString *)folderName
              filename:(NSString *)filename
            completion:(void(^)(UIImage *image))completion {
    
    // Search image locally
    NSString *localFilePath = [self getPhotoPathForUserId:identifier folderName:folderName withFileName:[filename lastPathComponent]];
    BOOL localExists = [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
    
    // Block that receives my completion as a parameter and download the image asynchronously calling this completion at the end.
    void (^downloadBlock)(void) = ^{
        
        [self seekNSDataByUrl:filename completion:^(NSData *data) {
            
            UIImage *image;
            
            if ( ! data ) {
                
                image = nil;
                
            } else {
                
                [self saveImageById:identifier photo:data folderName:folderName fileName:[filename lastPathComponent]];
                image = [UIImage imageWithData:data];
                
            }
            
            // make the callback with image downloaded from server.
            if ( completion )
                completion( image );

        }];
        
    };
    
    // I have image cached, but I need to check if it was changed in server.
    if ( localExists ) {
        
        NSError *error;
        
        // Size of local image
        long long localImageSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:localFilePath error:&error] fileSize];
        
        [Connection contentLengthForPath:filename completion:^(long long length) {
            
            if ( localImageSize == length ) {
                
                // The image not changed
                if ( completion ) {
                    
                    UIImage *localImage = [self seekImageLocallyById:identifier folderName:folderName filename:filename];
                    completion( localImage );
                    
                }
                
            // Fire downloadBlock to get image from server and call the completion block
            } else {
                downloadBlock();
            }
            
        }];
        
    } else {
        downloadBlock();
    }
    
}

-(NSString *)getPhotoPathForUserId:(id)identifier folderName:(NSString *)folderName withFileName:(NSString *)fileName {
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folder = [NSString stringWithFormat:@"%@/%@/%@/",docDir, kCachedImages,folderName];
    
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:folder];
    
    if ( ! folderExists ) {
        
        if ( ! [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL] ) {
            JW_log( @"Error: Create folder failed %@", docDir );
        }
        
    }
    
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@/%@/%@.%@", docDir, kCachedImages, folderName, identifier, [fileName pathExtension]];
    
    return pngFilePath;
    
}

-(void)seekNSDataByUrl:(NSString *)url completion:(void(^)(NSData *data))completion {
    
    NSURL *dataURL = [NSURL URLWithString:url];
    
    runOnBackgroundQueue(^{
        
        NSData *data = [NSData dataWithContentsOfURL:dataURL];
        
        if ( completion ) {
            
            runOnMainQueueAsync(^{
                completion(data);
            });
            
        }
        
    });
    
}

-(void)saveImageById:(id)identifier photo:(NSData *)data folderName:(NSString *)folderName fileName:(NSString*)fileName {
    
    NSString *filePath = [self getPhotoPathForUserId:identifier folderName:folderName withFileName:fileName];
    
    if ( [data length] > 0 ) {
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] )
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        
        [data writeToFile:filePath atomically:YES];
        
    }
    
}

-(UIImage *)seekImageLocallyById:(id)identifier folderName:(NSString *)folderName filename:(id)filename {
    
    if ( filename == NULL || filename == [NSNull null] )
        return NULL;
    
    if ( [filename isEqualToString:@""] )
        return NULL;
    
    NSString *filePath = [self getPhotoPathForUserId:identifier folderName:folderName withFileName:filename];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if ( fileExists )
        return [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
    else
        return NULL;
    
}

+(void)checkDateLastEmptyCache {
    
    // Condition to delete the pictures only once a month
    NSDate *dateLastEmptyCache = [[NSUserDefaults standardUserDefaults] objectForKey:kDateLastEmptyCache];
    
    if ( dateLastEmptyCache == NULL ) {
        
        [ImageDAO updateDateLastEmptyCache];
        
        return;
        
    }
    
    // It's been 30 days since the last time you emptied the cache?
    NSDate *currentDate = [NSDate date];
    
    [DateHelper addNumberOfDays:30 onDate:dateLastEmptyCache];
    
    if ( [currentDate compare:dateLastEmptyCache] == NSOrderedDescending || // currentDate is greater than dateLastEmptyCache
        [currentDate compare:dateLastEmptyCache] == NSOrderedSame ) { // currentDate is equals to dateLastEmptyCache
        
        [ImageDAO emptyCacheImages];
        
        return;
        
    }
    
}

+(void)emptyCacheImages {
    
    // Deletes all cached images
    NSString *docDir   = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/", docDir, kCachedImages];
    
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    // Deletes the directory
    if ( folderExists ) {
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        
        [ImageDAO updateDateLastEmptyCache];
        
    }
    
}

+(void)updateDateLastEmptyCache {
    
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kDateLastEmptyCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
