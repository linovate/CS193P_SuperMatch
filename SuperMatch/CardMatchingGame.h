//
//  CardMatchingGame.h
//  MatchingGame
//
//  Created by Viet Trinh on 12/10/14.
//  Copyright (c) 2014 VietTrinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (strong, nonatomic, readonly) NSString* matchDetails;
// this variable is used to determine 2-card or 3-card game is playing
@property (nonatomic) NSUInteger typeOfGame;

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck*) deck;
-(Card*)cardAtIndex:(NSUInteger)index;
-(void)chooseCardAtIndex:(NSUInteger)index;
@end