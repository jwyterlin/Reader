//
//  ImageDAO.h
//  Reader
//
//  Created by Jhonathan Wyterlin on 01/07/15.
//  Copyright © 2015 Jhonathan Wyterlin. All rights reserved.
//

#import "GenericDAO.h"

#import <UIKit/UIKit.h>

@interface ImageDAO : GenericDAO

-(void)imageByUrl:(NSString *)url completion:(void(^)(UIImage *image))completion;

-(void)defineImageById:(NSString *)identifier
            folderName:(NSString *)folderName
              filename:(NSString *)filename
            completion:(void(^)(UIImage *image))completion;

-(NSString *)getPhotoPathForUserId:(id)identifier
                        folderName:(NSString *)folderName
                      withFileName:(NSString *)fileName;

-(void)seekNSDataByUrl:(NSString *)url
            completion:(void(^)(NSData *data))completion;

-(void)saveImageById:(id)identifier
               photo:(NSData *)data
          folderName:(NSString *)folderName
            fileName:(NSString*)fileName;

-(UIImage *)seekImageLocallyById:(id)identifier
                      folderName:(NSString *)folderName
                        filename:(id)filename;

+(void)checkDateLastEmptyCache;

+(void)emptyCacheImages;

+(void)updateDateLastEmptyCache;

@end
